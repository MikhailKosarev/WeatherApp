//
//  FiveDayWeatherPresenter.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 29.09.2022.
//

import UIKit

// input protocol
protocol FiveDayWeatherViewProtocol: UIViewController {
    func reloadCityLabel(with city: String)
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
    
    func getDetailWeatherFor(dayNumber: Int, city cityName: String)
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
        print(networkService)
        networkService.getFiveDayWeather(cityName: cityName) { [weak self] result in
            switch result {
            case .success(let fiveDayWeatherData):
                // reload citylabel
                self?.fiveDayWeatherData = fiveDayWeatherData
                self?.getDataForCitylabel()
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
            self.view?.reloadCityLabel(with: cityViewData.fullCityName)
        }
    }
    
    func getDetailWeatherFor(dayNumber: Int, city cityName: String) {
//        view?.reloadDetailsTabelView(with: [DetailWeatherModel])
    }
    
    
}
