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
        // Steps to using Weather Kit:
        /// - Add "WeatherKit" capability
        /// - Add "iCloud" capability and enable "iCloud Documents" under iCloud configuration
        /// - Enable Weather Kit in your Developer Account under the App ID for your app:
        ///     - Go to Apple Developer portal.
        ///     - Select your app's Bundle ID under Identifiers.
        ///     - Check if WeatherKit is listed under Capabilities. If not, click Edit → check WeatherKit → Save.
        ///     - Now, back in Xcode:
        ///     - Go to Signing & Capabilities.
        ///     - Make sure Automatically manage signing is ON (recommended).
        ///     - Let Xcode regenerate the provisioning profile, or download and select the updated one manually.
        
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
            do {
                // Get weather
                let weather = try await weatherService.weather(for: location)
                
                // Get sunrise and sunset dates
                let sunrise = weather.dailyForecast.first?.sun.sunrise
                let sunset = weather.dailyForecast.first?.sun.sunset
                
                // Set the sky variation
                await MainActor.run {
                    self.setTimeOfDay(sunrise: sunrise, sunset: sunset)
                }
            } catch {
                print("Failed getting weather: \(error)")
                await MainActor.run { self.setTimeOfDay() }
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
    
    // MARK: Temporary
    /// Sets the current time of day.
    func updateAccordingToTime() {
        let hour = Calendar.current.component(.hour, from: Date())
        let startMorning = 7
        let startDay = 9
        let startEvening = 19
        let startNight = 23
        if hour >= startMorning && hour < startDay {
            currentTimeOfDay = .sunrise
        } else if hour >= startDay && hour < startEvening {
            currentTimeOfDay = .day
        } else if hour >= startEvening && hour < startNight {
            currentTimeOfDay = .sunset
        } else {
            currentTimeOfDay = .night
        }
    }
}
