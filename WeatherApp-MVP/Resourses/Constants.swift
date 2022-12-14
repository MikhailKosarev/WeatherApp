//
//  Constants.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 27.09.2022.
//

import UIKit

public struct Constants {
    // default spacing
    static let spacing5: CGFloat = 5.0
    static let spacing10: CGFloat = 10.0
    static let spacing20: CGFloat = 20.0
    static let spacing30: CGFloat = 30.0
    static let spacing40: CGFloat = 40.0
    
    // fonts
    static let systemFont30 = UIFont.systemFont(ofSize: 30)
    static let systemFont50 = UIFont.systemFont(ofSize: 50)
    static let systemFont80 = UIFont.systemFont(ofSize: 80)
    
    // default corner radiuses
    static let radius10: CGFloat = 10
    
    // tabBar images
    static let currentImageSystemName = "clock.arrow.circlepath"
    static let fiveDaySystemName = "goforward.5"
    
    // location image
    static let locationImageSystemName = "location.circle"
    
    // userDefaults keys
    static let savedCityName = "savedCityName"
    static let savedCityLatitude = "savedCityLatitude"
    static let savedCityLongitude = "savedCityLongitude"
    static let weatherSavedType = "weatherSavedType"

}

// types of saved weather
enum WeatherSavedType: String {
    case name
    case coordinates
}
