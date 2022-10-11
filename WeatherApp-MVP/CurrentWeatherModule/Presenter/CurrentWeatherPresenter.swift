//
//  CurrentWeatherPresenter.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 27.09.2022.
//

import UIKit

// an input protocol
// MARK: - CurrentWeatherViewProtocol definition
protocol CurrentWeatherViewProtocol: UIViewController {
    func locationButtonTapped()
    func reloadWeather(viewData: CurrentWeatherViewData)
    func showAlert(_ alert: UIAlertController)
}

// an output protocol
// MARK: - CurrentWeatherPresenterProtocol definition
protocol CurrentWeatherPresenterProtocol: AnyObject {
    init(view: CurrentWeatherViewProtocol, networkService: NetworkServiceProtocol)
    
    // internal
    func makeAlert() -> UIAlertController
    func saveCityCoordinates(lat: Double, lon: Double)
    func saveCityName(_ cityName: String)
    func loadWeatherForSavedCityName()
    func loadSavedWeather()
    
    // public
    func getCurrentWeatherCity(for cityName: String)
    func getCurrentWeatherCoordinates(latitude lat: Double, longitude lon: Double)
}

// presenter class
// MARK: - CurrentWeatherPresenter
final class CurrentWeatherPresenter: CurrentWeatherPresenterProtocol {
    
    weak var view: CurrentWeatherViewProtocol?
    var networkService: NetworkServiceProtocol
    let userDefaults = UserDefaults.standard
    
    required init(view: CurrentWeatherViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
    }
    
    // MARK: - Internal methods
    internal func makeAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Error",
                                      message: "Please type a valid city name",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .destructive)
        alert.addAction(okAction)
        return alert
    }
    
    internal func saveCityCoordinates(lat: Double, lon: Double) {
        userDefaults.set(WeatherSavedType.coordinates.rawValue, forKey: Constants.weatherSavedType)
        userDefaults.set(lat, forKey: Constants.savedCityLatitude)
        userDefaults.set(lon, forKey: Constants.savedCityLongitude)
    }
    
    internal func saveCityName(_ cityName: String) {
        // set weatherSavedType (name or coordinates
        userDefaults.set(WeatherSavedType.name.rawValue, forKey: Constants.weatherSavedType)
        userDefaults.set(cityName, forKey: Constants.savedCityName)
    }
    
    internal func loadWeatherForSavedCityName() {
        guard let cityName = userDefaults.string(forKey: Constants.savedCityName) else { return }
        getCurrentWeatherCity(for: cityName)
    }
    
    internal func loadWeatherForSavedCityCoordinates() {
        let lat = userDefaults.double(forKey: Constants.savedCityLatitude)
        let lon = userDefaults.double(forKey: Constants.savedCityLongitude)
        getCurrentWeatherCoordinates(latitude: lat, longitude: lon)
    }
    
    // MARK: - Public methods
    public func loadSavedWeather() {
        guard let currentWeatherSavedType = userDefaults.string(forKey: Constants.weatherSavedType) else { return }
        if currentWeatherSavedType == WeatherSavedType.name.rawValue {
            loadWeatherForSavedCityName()
        } else {
            loadWeatherForSavedCityCoordinates()
        }
    }
    
    public func getCurrentWeatherCity(for cityName: String) {
        // save cityName
        saveCityName(cityName)
        
        // get data
        networkService.getWeatherCity(type: BaseUrl.currentWeatherCity, cityName: cityName) { [weak self] (result: Result<CurrentWeatherData, Error>) in
            switch result {
            case .success(let currentWeatherData):
                // write the model
                let currentWeather = CurrentWeatherViewData(cityName: currentWeatherData.name,
                                                         countryName: currentWeatherData.sys.country,
                                                         temperature: currentWeatherData.main.temp,
                                                         feelsLike: currentWeatherData.main.feelsLike,
                                                         conditionId: currentWeatherData.weather[0].id)
                // reload view
                DispatchQueue.main.async {
                    self?.view?.reloadWeather(viewData: currentWeather)
                }
            case .failure(let error):
                let alert = UIAlertController.alertOk(title: "Error",
                                                      message: "Please type a valid city name")
                DispatchQueue.main.async {
                    self?.view?.showAlert(alert)
                }
                print(error)
            }
        }
    }
    
    public func getCurrentWeatherCoordinates(latitude lat: Double, longitude lon: Double) {
        // save city coordinates
        saveCityCoordinates(lat: lat, lon: lon)
        let latString = String(lat)
        let lonString = String(lon)
        // get data
        networkService.getWeatherCoordinates(type: BaseUrl.currentWeatherCoordinates,
                                             lat: latString,
                                             lon: lonString) { [weak self] (result: Result<CurrentWeatherData, Error>) in
            switch result {
            case .success(let currentWeatherData):
                // write the model
                let currentWeather = CurrentWeatherViewData(cityName: currentWeatherData.name,
                                                         countryName: currentWeatherData.sys.country,
                                                         temperature: currentWeatherData.main.temp,
                                                         feelsLike: currentWeatherData.main.feelsLike,
                                                         conditionId: currentWeatherData.weather[0].id)
                // reload view
                DispatchQueue.main.async {
                    self?.view?.reloadWeather(viewData: currentWeather)
                }
            case .failure:
                print("incorrect coordinates")
                let alert = UIAlertController.alertOk(title: "Error",
                                                      message: "Incorrect coordinates")
                DispatchQueue.main.async {
                    self?.view?.showAlert(alert)
                }
            }
        }
    }
}
