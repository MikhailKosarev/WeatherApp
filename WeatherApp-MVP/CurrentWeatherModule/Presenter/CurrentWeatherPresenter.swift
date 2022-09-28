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
    init(view: CurrentWeatherViewProtocol, networkService: NetworkServiceProtocol)
    
    func getWeather(for cityName: String)
}

// presenter class
final class CurrentWeatherPresenter: CurrentWeatherPresenterProtocol {
    
    weak var view: CurrentWeatherViewProtocol?
    let networkService: NetworkServiceProtocol?
    
    required init(view: CurrentWeatherViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
    }
    
    func getWeather(for cityName: String) {
        networkService?.getCurrentWeather(cityName: cityName) { [weak self ]  result in
            switch result {
            case .success(let currentWeatherData):
                // get data
                let cityName = currentWeatherData.name
                let temperature = currentWeatherData.main.temp
                let conditionId = currentWeatherData.weather[0].id
                // write the model
                let currentWeather = CurrentWeatherModel(cityName: cityName,
                                                       temperature: temperature,
                                                       conditionId: conditionId)
                // reload view
                DispatchQueue.main.async {
                    
                    self?.view?.reloadWeather(city: currentWeather.cityName,
                                              degree: currentWeather.temperatureString,
                                              condition: currentWeather.conditionName)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
