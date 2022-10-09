//
//  CurrentWeatherPresenter.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 27.09.2022.
//

import UIKit

// an input protocol
protocol CurrentWeatherViewProtocol: UIViewController {
    func locationButtonTapped()
    func reloadWeather(city: String, degree: String, condition: String)
    func showAlert(_ alert: UIAlertController)
}

// an output protocol
protocol CurrentWeatherPresenterProtocol: AnyObject {
    init(view: CurrentWeatherViewProtocol, networkService: NetworkServiceProtocol)
    func makeAlert() -> UIAlertController
    func loadWeatherForSavedCity()
    func saveCityName(_ cityName: String)
    func getCurrentWeatherCity(for cityName: String)
    func getCurrentWeatherCoordinates(latitude lat: Double, longitude lon: Double)
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
    
    internal func saveCityName(_ cityName: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(cityName, forKey: Constants.savedCityName)
    }
    
    // MARK: - Public methods
    public func loadWeatherForSavedCity() {
        let userDefaults = UserDefaults.standard
        guard let cityName = userDefaults.string(forKey: Constants.savedCityName) else { return }
        getCurrentWeatherCity(for: cityName)
    }
    
    public func getCurrentWeatherCity(for cityName: String) {
        // save cityName
        saveCityName(cityName)
        
        // get data
        networkService.getWeatherCity(type: BaseUrl.currentWeatherCity, cityName: cityName) { [weak self] (result: Result<CurrentWeatherData, Error>) in
            switch result {
            case .success(let currentWeatherData):
                // write the model
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
    }
    
    public func getCurrentWeatherCoordinates(latitude lat: Double, longitude lon: Double) {
        // save cityName
        //        saveCityName(cityName)
        let latString = String(lat)
        let lonString = String(lon)
        // get data
        networkService.getWeatherCoordinates(type: BaseUrl.currentWeatherCoordinates,
                                             lat: latString,
                                             lon: lonString) { [weak self] (result: Result<CurrentWeatherData, Error>) in
            switch result {
            case .success(let currentWeatherData):
                // write the model
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
                print("incorrect coordinates")
//                let alert = UIAlertController.alertOk(title: "Error", message: "Please type a valid city name")
//                DispatchQueue.main.async {
//                    self?.view?.showAlert(alert)
//                }
                print(error)
            }
        }
    }
}
