//
//  DataRequest.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 05.10.2022.
//

import Foundation

enum BaseUrl: String {
    case currentWeatherCity = "https://api.openweathermap.org/data/2.5/weather?appid=c2f034e5d4f2fa20a5b92809ec6f83ca&units=metric&q="
    case fiveDayWeatherCity = "https://api.openweathermap.org/data/2.5/forecast?appid=c2f034e5d4f2fa20a5b92809ec6f83ca&units=metric&q="
    case currentWeatherCoordinates = "https://api.openweathermap.org/data/2.5/weather?appid=c2f034e5d4f2fa20a5b92809ec6f83ca&units=metric"
    case fiveDayWeatherCoordinates = "https://api.openweathermap.org/data/2.5/forecast?appid=c2f034e5d4f2fa20a5b92809ec6f83ca&units=metric"
}


