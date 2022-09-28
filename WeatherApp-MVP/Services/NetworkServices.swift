//
//  NetworkServices.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 28.09.2022.
//

import Foundation

protocol NetworkServiceProtocol {
    func getCurrentWeather(cityName: String, completion: @escaping(Result<CurrentWeatherModel, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    func getCurrentWeather(cityName: String, completion: @escaping (Result<CurrentWeatherModel, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?appid=c2f034e5d4f2fa20a5b92809ec6f83ca&units=metric&q=" + cityName
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data = data else { return }
            
            do {
                let decodedData = try JSONDecoder().decode(CurrentWeatherModel.self, from: data)
                completion(.success(decodedData))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
