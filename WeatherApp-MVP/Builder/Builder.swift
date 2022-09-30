//
//  Buidler.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 30.09.2022.
//

import UIKit

protocol Builder {
    static func createCurrentWeatherModule() -> UIViewController
    static func createFiveDayWeatherModule() -> UIViewController
}

class ModuleBulder: Builder {
    static func createCurrentWeatherModule() -> UIViewController {
        let view = CurrentWeatherViewController()
        let networkService = NetworkService()
        let presenter = CurrentWeatherPresenter(view: view, networkService: networkService)
        view.presenter = presenter
        return view
    }
    
    static func createFiveDayWeatherModule() -> UIViewController {
        let view = FiveDayWeatherViewController()
        let networkService = NetworkService()
        let presenter = FiveDayWeatherPresenter(view: view, networkService: networkService)
        view.presenter = presenter
        return view
    }
}
