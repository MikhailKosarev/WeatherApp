//
//  DayWeatherModel.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 29.09.2022.
//

import Foundation

struct DayWeatherViewData {
    //TODO: date logic
    let dayOfWeek: String = "Fr"
    let dayOfMonth: String = "29"
    let conditionId: Int
    let tempMax: Double
    let tempMin: Double
    let pressure: Int
    
    var tempMaxString: String {
        return String(format: "%.2f", tempMax)
    }
    
    var tempMinString: String {
        return String(format: "%.2f", tempMin)
    }
    
    var pressureString: String {
        return String(pressure)
    }
    
    var conditionName: String {
        switch conditionId {
        // Group 2xx: Thunderstorm
        case 200...202, 230...232:
            return "cloud.bolt.rain"
        case 210...221:
            return "cloud.bolt"
        // Group 3xx: Drizzle
        case 300...321:
            return "cloud.drizzle"
        // Group 5xx: Rain
        case 500...531:
            return "cloud.rain"
        // Group 6xx: Snow
        case 600...602:
            return "cloud.snow"
        case 611...622:
            return "cloud.sleet"
        // Group 7xx: Atmosphere
        case 701...781:
            return "cloud.fog"
        // Group 800: Clear
        case 800:
            return "sun.max"
        // Group 80x: Clouds
        case 801...802:
            return "cloud.sun"
        case 803...804:
            return "cloud"
        default:
            return "cloud"
        }
    }
}
