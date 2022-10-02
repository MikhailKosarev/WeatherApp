//
//  CityModel.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 29.09.2022.
//

import Foundation

struct CityViewData {
    let name: String
    let country: String
    
    var fullCityName: String {
        "\(name), \(country)"
    }
}
