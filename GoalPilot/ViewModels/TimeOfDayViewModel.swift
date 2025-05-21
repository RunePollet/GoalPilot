//
//  TimeOfDayViewModel.swift
//  GoalPilot
//
//  Created by Rune Pollet on 16/05/2025.
//

import SwiftUI
import WeatherKit

@Observable
class TimeOfDayViewModel {
    enum TimeOfDay {
        case sunrise, day, sunset, night
        
        var preferredColorScheme: ColorScheme {
            switch self {
            case .day, .sunrise:
                return .light
            case .night, .sunset:
                return .dark
            }
        }
    }
    
    var currentTimeOfDay: TimeOfDay = .day
    var preferredColorScheme: ColorScheme { currentTimeOfDay.preferredColorScheme }
    
    private let locationService = LocationService()
    private let weatherService = WeatherService()
    
    /// Updates the current sky variation according to the current time.
    func updateTimeOfDay() async {
        // Get user location
        let location = await withCheckedContinuation { continuation in
            locationService.getLocation { location in
                continuation.resume(returning: location)
            }
        }
        
        guard let location else {
            setTimeOfDay()
            return
        }
        
        let weatherService = self.weatherService
        Task.detached {
            // Get weather
            guard let weather = try? await weatherService.weather(for: location) else {
                await MainActor.run { self.setTimeOfDay() }
                return
            }
            
            // Get sunrise and sunset dates
            let sunrise = weather.dailyForecast.first?.sun.sunrise
            let sunset = weather.dailyForecast.first?.sun.sunset
            
            
            // Set the sky variation
            await MainActor.run {
                self.setTimeOfDay(sunrise: sunrise, sunset: sunset)
            }
        }
    }
    
    private func setTimeOfDay(sunrise: Date? = nil, sunset: Date? = nil) {
        let sunriseDate = sunrise ?? .today(at: .init(hour: 7, minute: 00))
        let sunsetDate = sunset ?? .today(at: .init(hour: 19, minute: 00))
        
        // Reference dates
        let now = Date()
        let sunrise = (start: sunriseDate.addingTimeInterval(-1800), end: sunriseDate.addingTimeInterval(1800))
        let sunset = (start: sunsetDate.addingTimeInterval(-1800), end: sunsetDate.addingTimeInterval(1800))
        
        // Determine what the sky should be
        if now < sunrise.start || now > sunset.end {
            currentTimeOfDay = .night
        } else if now > sunrise.end && now < sunset.start {
            currentTimeOfDay = .day
        } else if now >= sunrise.start && now <= sunrise.end {
            currentTimeOfDay = .sunrise
        } else {
            currentTimeOfDay = .sunset
        }
    }
}
