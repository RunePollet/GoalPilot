//
//  RandomValue.swift
//  GoalPilot
//
//  Created by Rune Pollet on 19/12/2024.
//

import Foundation

struct RandomValue<T> {
    var value: T
    var occurence: Double
    
    /// Randomizes the given values taking their occurences in account.
    static func randomize<U>(values: [RandomValue<U>]) -> U {
        var result = values[0]
        let randomDouble = Double.random(in: 1...100)
        
        var count = 0.0
        
        for value in values {
            // Update the count to check against the random double value
            count += value.occurence
            if count >= randomDouble {
                result = value
                break
            }
        }
        
        return result.value
    }
}
