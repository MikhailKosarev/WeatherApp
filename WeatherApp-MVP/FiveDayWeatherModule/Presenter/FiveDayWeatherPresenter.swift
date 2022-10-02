//
//  FiveDayWeatherPresenter.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 29.09.2022.
//

import UIKit

// input protocol
protocol FiveDayWeatherViewProtocol: UIViewController {
    func updateCityLabel(with city: String)
//    func updateWeatherHeader(with header: String)
    func updateDetailsWeather(with viewData: DetailWeatherViewData?)
    func reloadDetailTableView()
//    func reloadDaysCollectionView(dayOfWeek: String,
//                                  dayOfMonth: String,
//                                  tempMaxString: String,
//                                  tempMinString: String,
//                                  pressureString: String,
//                                  conditionName: String)
//    
//    func reloadDetailsTabelView(dateHeader: String,
//                                tempMaxString: String,
//                                feelsLikeString: String,
//                                tempMinString: String,
//                                humidityString: String,
//                                windSpeedString: String,
//                                pressureString: String)
}

// output protocol
protocol FiveDayWeatherPresenterProtocol: AnyObject {
    var fiveDayWeatherData: FiveDayWeatherData? {get set}
    init(view: FiveDayWeatherViewProtocol, networkService: NetworkServiceProtocol)
    
    func getFiveDayWeather(for cityName: String)
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

    func getFiveDayWeather(for cityName: String) {
        networkService.getFiveDayWeather(cityName: cityName) { [weak self] result in
            switch result {
            case .success(let fiveDayWeatherData):
                // reload citylabel
                self?.fiveDayWeatherData = fiveDayWeatherData
                self?.getDataForCitylabel()
                self?.view?.reloadDetailTableView()
                // reload daysCollectionView
                
                // reload detailsTableView
                
                print("successful")
            case .failure(let error):
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
