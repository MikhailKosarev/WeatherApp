//
//  FiveDayWeatherPresenter.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 29.09.2022.
//

import UIKit

// input protocol
// MARK: - FiveDayWeatherViewProtocol definition
protocol FiveDayWeatherViewProtocol: UIViewController {
    func locationButtonTapped()
    func updateCityLabel(with city: String)
    func reloadDetailTableView()
    func showAlert(_ alert: UIAlertController)
}

// output protocol
// MARK: - FiveDayWeatherPresenterProtocol definition
protocol FiveDayWeatherPresenterProtocol: AnyObject {
    var fiveDayWeatherData: FiveDayWeatherData? {get set}
    init(view: FiveDayWeatherViewProtocol, networkService: NetworkServiceProtocol)

    // internal
    func saveCityCoordinates(lat: Double, lon: Double)
    func saveCityName(_ cityName: String)
    func loadWeatherForSavedCityName()
    func loadWeatherForSavedCityCoordinates()
    
    // public
    func loadSavedWeather()
    func getFiveDayWeatherCity(for cityName: String)
    func getFiveDayWeatherCoordinates(latitude lat: Double, longitude lon: Double)
    func getDataForCitylabel()
    func getSectionHeader(for section: Int) -> String
    func getDetailsWeather(for index: Int) -> DetailWeatherViewData?
}

// MARK: - FiveDayWeatherPresenter
class FiveDayWeatherPresenter: FiveDayWeatherPresenterProtocol {
    var fiveDayWeatherData: FiveDayWeatherData?
    
    weak var view: FiveDayWeatherViewProtocol?
    var networkService: NetworkServiceProtocol
    let userDefaults = UserDefaults.standard
    
    required init(view: FiveDayWeatherViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
    }
    
    // MARK: - Internal methods
    internal func saveCityCoordinates(lat: Double, lon: Double) {
        userDefaults.set(WeatherSavedType.coordinates.rawValue, forKey: Constants.weatherSavedType)
        userDefaults.set(lat, forKey: Constants.savedCityLatitude)
        userDefaults.set(lon, forKey: Constants.savedCityLongitude)
    }
    
    internal func saveCityName(_ cityName: String) {
        userDefaults.set(WeatherSavedType.name.rawValue, forKey: Constants.weatherSavedType)
        userDefaults.set(cityName, forKey: Constants.savedCityName)
    }
    
    internal func loadWeatherForSavedCityName() {
        guard let cityName = userDefaults.string(forKey: Constants.savedCityName) else { return }
        getFiveDayWeatherCity(for: cityName)
    }
    
    internal func loadWeatherForSavedCityCoordinates() {
        let lat = userDefaults.double(forKey: Constants.savedCityLatitude)
        let lon = userDefaults.double(forKey: Constants.savedCityLongitude)
        getFiveDayWeatherCoordinates(latitude: lat, longitude: lon)
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
    
    public func getFiveDayWeatherCity(for cityName: String) {
        // save cityName
        saveCityName(cityName)
        
        // get data
        networkService.getWeatherCity(type: BaseUrl.fiveDayWeatherCity, cityName: cityName) { [weak self] (result: Result<FiveDayWeatherData, Error>) in
            switch result {
            case .success(let fiveDayWeatherData):
                // reload citylabel
                self?.fiveDayWeatherData = fiveDayWeatherData
                self?.getDataForCitylabel()
                // reload detailsTableView
                self?.view?.reloadDetailTableView()
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
    
    public func getFiveDayWeatherCoordinates(latitude lat: Double, longitude lon: Double) {
        // save city coordinates
        saveCityCoordinates(lat: lat, lon: lon)
        
        let latString = String(lat)
        let lonString = String(lon)
        // get data
        networkService.getWeatherCoordinates(type: BaseUrl.fiveDayWeatherCoordinates,
                                             lat: latString,
                                             lon: lonString)  { [weak self] (result: Result<FiveDayWeatherData, Error>) in
            switch result {
            case .success(let fiveDayWeatherData):
                // reload citylabel
                self?.fiveDayWeatherData = fiveDayWeatherData
                self?.getDataForCitylabel()
                // reload detailsTableView
                self?.view?.reloadDetailTableView()
            case .failure:
                let alert = UIAlertController.alertOk(title: "Error",
                                                      message: "Incorrect coordinates")
                DispatchQueue.main.async {
                    self?.view?.showAlert(alert)
                }
            }
        }
    }
    
    public func getDataForCitylabel() {
        guard let fiveDayWeatherData else { return }
        let cityViewData = CityViewData(name: fiveDayWeatherData.city.name,
                                        country: fiveDayWeatherData.city.country)
        DispatchQueue.main.async {
            self.view?.updateCityLabel(with: cityViewData.fullCityName)
        }
    }
    
    public func getSectionHeader(for section: Int) -> String {
        guard let fiveDayWeatherData else { return "default" }
        let header = fiveDayWeatherData.list[section].dtTxt
        return header
    }
    
    public func getDetailsWeather(for index: Int) -> DetailWeatherViewData? {
        guard let fiveDayWeatherData else { return nil }
        let currentList = fiveDayWeatherData.list[index]
        
        let detailWeatherViewData = DetailWeatherViewData(tempMax: currentList.main.tempMax,
                                                          feelsLike: currentList.main.feelsLike,
                                                          tempMin: currentList.main.tempMin,
                                                          humidity: currentList.main.humidity,
                                                          windSpeed: currentList.wind.speed,
                                                          pressure: currentList.main.pressure)
        return detailWeatherViewData
    }
}
