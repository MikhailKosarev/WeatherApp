//
//  CurrentWeatherPresenter.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 27.09.2022.
//

import UIKit

// an input protocol
protocol CurrentWeatherViewProtocol: UIViewController {
    func reloadWeather(city: String, degree: String, condition: String)
}

// an output protocol
protocol CurrentWeatherPresenterProtocol: AnyObject {
    init(view: CurrentWeatherViewProtocol)
    
    func getWeather(for cityName: String)
}

// presenter class
class CurrentWeatherPresenter: CurrentWeatherPresenterProtocol {
    
    weak var view: CurrentWeatherViewProtocol?
    
    required init(view: CurrentWeatherViewProtocol) {
        self.view = view
    }
    
    func getWeather(for cityName: String) {
        // network request here
        view?.reloadWeather(city: "Gdańsk", degree: "+14°C", condition: "cloud.sun.rain")
    }
    
}
