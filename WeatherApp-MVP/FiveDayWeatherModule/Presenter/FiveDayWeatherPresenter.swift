//
//  FiveDayWeatherPresenter.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 29.09.2022.
//

import UIKit

// input protocol
protocol FiveDayWeatherViewProtocol: UIViewController {
    func locationButtonTapped()
    func updateCityLabel(with city: String)
    func reloadDetailTableView()
    func showAlert(_ alert: UIAlertController)
}

// output protocol
protocol FiveDayWeatherPresenterProtocol: AnyObject {
    var fiveDayWeatherData: FiveDayWeatherData? {get set}
    init(view: FiveDayWeatherViewProtocol, networkService: NetworkServiceProtocol)

    func saveCityName(_ cityName: String)
    
    func loadWeatherForSavedCity()
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
    
    required init(view: FiveDayWeatherViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
    }

    internal func saveCityName(_ cityName: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(cityName, forKey: Constants.savedCityName)
    }
    
    func loadWeatherForSavedCity() {
        let userDefaults = UserDefaults.standard
        guard let cityName = userDefaults.string(forKey: Constants.savedCityName) else { return }
        getFiveDayWeatherCity(for: cityName)
    }
    
    func getFiveDayWeatherCity(for cityName: String) {
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
                let alert = UIAlertController.alertOk(title: "Error", message: "Please type a valid city name")
                DispatchQueue.main.async {
                    self?.view?.showAlert(alert)
                }
                print(error)
            }
        }
    }
    
    public func getFiveDayWeatherCoordinates(latitude lat: Double, longitude lon: Double) {
        // save cityName
        //        saveCityName(cityName)
        
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
            case .failure(let error):
//                let alert = UIAlertController.alertOk(title: "Error", message: "Please type a valid city name")
//                DispatchQueue.main.async {
//                    self?.view?.showAlert(alert)
//                }
                print(error)
            }
        }
    }
    
    func getDataForCitylabel() {
        guard let fiveDayWeatherData else { return }
        let cityViewData = CityViewData(name: fiveDayWeatherData.city.name,
                                        country: fiveDayWeatherData.city.country)
        DispatchQueue.main.async {
            self.view?.updateCityLabel(with: cityViewData.fullCityName)
        }
    }
    
    func getSectionHeader(for section: Int) -> String {
        guard let fiveDayWeatherData else { return "default" }
        let header = fiveDayWeatherData.list[section].dtTxt
        return header
    }
    
    func getDetailsWeather(for index: Int) -> DetailWeatherViewData? {
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
