//
//  DetailWeatherModel.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 29.09.2022.
//

import Foundation

struct DetailWeatherViewData {
    let dateHeader: String
    let tempMax: Double
    let feelsLike: Double
    let tempMin: Double
    let humidity: Int
    let windSpeed: Double
    let pressure: Int
    
    var tempMaxString: String {
        return String(format: "%.2f", tempMax)
    }
    
    var feelsLikeString: String {
        return String(format: "%.2f", feelsLike)
    }
    
    var tempMinString: String {
        return String(format: "%.2f", tempMin)
    }
    
    var humidityString: String {
        return String(humidity) + "%"
    }
    
    var windSpeedString: String {
        return String(windSpeed)
    }
    
    var pressureString: String {
        return String(pressure)
    }
}
