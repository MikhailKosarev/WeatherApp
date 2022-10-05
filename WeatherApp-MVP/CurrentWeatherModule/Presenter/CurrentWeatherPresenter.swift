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
    func showAlert(_ alert: UIAlertController)
}

// an output protocol
protocol CurrentWeatherPresenterProtocol: AnyObject {
    init(view: CurrentWeatherViewProtocol, networkService: NetworkServiceProtocol)
    func makeAlert() -> UIAlertController
    func getCurrentWeather(for cityName: String)
}

// presenter class
final class CurrentWeatherPresenter: CurrentWeatherPresenterProtocol {
    
    weak var view: CurrentWeatherViewProtocol?
    var networkService: NetworkServiceProtocol
    
    required init(view: CurrentWeatherViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
    }
    
    // MARK: - Private methods
    internal func makeAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: "Please type a valid city name", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .destructive)
        alert.addAction(okAction)
        return alert
    }
    
    
    // MARK: - Public methods
    public func getCurrentWeather(for cityName: String) {
        networkService.getWeather(type: BaseUrl.currentWeather, cityName: cityName) { [weak self] (result: Result<CurrentWeatherData, Error>) in
            switch result {
            case .success(let currentWeatherData):
                // write the model
                print(currentWeatherData)
                let currentWeather = CurrentWeatherModel(cityName: currentWeatherData.name,
                                                         temperature: currentWeatherData.main.temp,
                                                         conditionId: currentWeatherData.weather[0].id)
                // reload view
                DispatchQueue.main.async {
                    self?.view?.reloadWeather(city: currentWeather.cityName,
                                              degree: currentWeather.temperatureString,
                                              condition: currentWeather.conditionName)
                }
            case .failure(let error):
                let alert = UIAlertController.alertOk(title: "Error", message: "Please type a valid city name")
                DispatchQueue.main.async {
                    self?.view?.showAlert(alert)
                }
                print(error)
            }
        }
        
//        let networkNew = NetworkNew()
//        networkNew.getWeather(type: BaseUrl.currentWeather, cityName: cityName) { [weak self] (result: Result<CurrentWeatherData, Error>) in
//            switch result {
//            case .success(let currentWeatherData):
//                print("2")
//                print(currentWeatherData)
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
}
