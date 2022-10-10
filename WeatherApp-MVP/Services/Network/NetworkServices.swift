//
//  NetworkServices.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 28.09.2022.
//

import Foundation

protocol NetworkServiceProtocol: AnyObject {
    func getWeatherCity<WeatherData: Decodable>(type baseUrl: BaseUrl, cityName: String, completion: @escaping(Result<WeatherData, Error>) -> Void)
    func getWeatherCoordinates<WeatherData: Decodable>(type baseUrl: BaseUrl, lat: String, lon: String, completion: @escaping(Result<WeatherData, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    
    func getWeatherCity<T: Decodable>(type baseUrl: BaseUrl, cityName: String, completion: @escaping (Result<T, Error>) -> Void) {
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
    
    func getWeatherCoordinates<T: Decodable>(type baseUrl: BaseUrl, lat: String, lon: String, completion: @escaping (Result<T, Error>) -> Void) {
        let urlString = baseUrl.rawValue + "&lat=" + lat + "&lon=" + lon
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
