//
//  NetworkServices.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 28.09.2022.
//

import Foundation

protocol NetworkServiceProtocol: AnyObject {
    func getCurrentWeather(cityName: String, completion: @escaping(Result<CurrentWeatherData, Error>) -> Void)
    func getFiveDayWeather(cityName: String, completion: @escaping (Result<FiveDayWeatherData, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    func getCurrentWeather(cityName: String, completion: @escaping (Result<CurrentWeatherData, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?appid=c2f034e5d4f2fa20a5b92809ec6f83ca&units=metric&q=" + cityName
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data = data else { return }
            
            do {
                let decodedData = try JSONDecoder().decode(CurrentWeatherData.self, from: data)
                completion(.success(decodedData))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getFiveDayWeather(cityName: String, completion: @escaping (Result<FiveDayWeatherData, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?appid=c2f034e5d4f2fa20a5b92809ec6f83ca&units=metric&q=" + cityName
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                completion(.failure(error))
            }
            
            guard let data else { return }
            do {
                let decodedData = try JSONDecoder().decode(FiveDayWeatherData.self, from: data)
                completion(.success(decodedData))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
