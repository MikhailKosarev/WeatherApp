//
//  DetailWeatherModel.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 29.09.2022.
//

import Foundation

struct DetailWeatherViewData {
    let tempMax: Double
    let feelsLike: Double
    let tempMin: Double
    let humidity: Int
    let windSpeed: Double
    let pressure: Int
    
    var tempMaxString: String {
        return String(format: "%.1f", tempMax) + "°C"
    }
    
    var feelsLikeString: String {
        return String(format: "%.1f", feelsLike) + "°C"
    }
    
    var tempMinString: String {
        return String(format: "%.1f", tempMin) + "°C"
    }
    
    var humidityString: String {
        return String(humidity) + "%"
    }
    
    var windSpeedString: String {
        return String(windSpeed) + " m/s"
    }
    
    var pressureString: String {
        return String(pressure) + " hPa"
    }
}
