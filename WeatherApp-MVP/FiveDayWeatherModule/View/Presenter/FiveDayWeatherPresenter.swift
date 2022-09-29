//
//  FiveDayWeatherPresenter.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 29.09.2022.
//

import UIKit

// input protocol
protocol FiveDayWeatherViewProtocol: UIViewController {
    func reloadDaysCollectionView(with dayWeatherModels: [DayWeatherModel])
    func reloadDetailsTabelView(with detailWeatherModels: [DetailWeatherModel])
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
            networkService?.getFiveDayWeather(cityName: cityName) { [weak self] result in
                switch result {
                case .success(let fivaDayWeatherData):
                DispatchQueue.main.async {
                    self?.view?.reloadDaysCollectionView(with: [DayWeatherModel])
                }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func getDetailWeatherFor(dayNumber: Int, city cityName: String) {
        view?.reloadDetailsTabelView(with: [DetailWeatherModel])
    }
    
    
}
