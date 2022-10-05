//
//  NetworkServices.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 28.09.2022.
//

import Foundation

protocol NetworkServiceProtocol: AnyObject {
    func getWeather<WeatherData: Decodable>(type baseUrl: BaseUrl, cityName: String, completion: @escaping(Result<WeatherData, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    
    func getWeather<T: Decodable>(type baseUrl: BaseUrl, cityName: String, completion: @escaping (Result<T, Error>) -> Void) {
        let urlString = baseUrl.rawValue + cityName
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            // error
            if let error {
                completion(.failure(error))
            }
            
            // decode data
            guard let data else { return }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
