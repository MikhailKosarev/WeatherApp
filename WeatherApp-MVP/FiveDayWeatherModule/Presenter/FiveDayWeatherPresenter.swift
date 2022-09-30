//
//  FiveDayWeatherPresenter.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 29.09.2022.
//

import UIKit

// input protocol
protocol FiveDayWeatherViewProtocol: UIViewController {
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
    init(view: FiveDayWeatherViewProtocol, networkService: NetworkServiceProtocol)
    
    func getFiveDayWeather(for cityName: String)
    func getDetailWeatherFor(dayNumber: Int, city cityName: String)
}

// MARK: - FiveDayWeatherPresenter
class FiveDayWeatherPresenter: FiveDayWeatherPresenterProtocol {
    weak var view: FiveDayWeatherViewProtocol?
    weak var networkService: NetworkServiceProtocol?
    
    required init(view: FiveDayWeatherViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
    }

    func getFiveDayWeather(for cityName: String) {
        networkService?.getFiveDayWeather(cityName: cityName) { result in
            switch result {
            case .success(let fiveDayWeatherData):
                print("successful")
                print(fiveDayWeatherData)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getDetailWeatherFor(dayNumber: Int, city cityName: String) {
//        view?.reloadDetailsTabelView(with: [DetailWeatherModel])
    }
    
    
}
