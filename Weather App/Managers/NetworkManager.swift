//
//  NetworkManager.swift
//  Weather App
//
//  Created by Nursultan Konspayev on 05.08.2024.
//

import UIKit

class NetworkManager {
    ///Singleton
    static let shared = NetworkManager()
    
    private let apikey = "здесь могла бы быть ваша реклама"
    
    private lazy var urlComponent: URLComponents = {
        var component = URLComponents()
        component.scheme = "https"
        component.host = "api.openweathermap.org"
        component.queryItems = [
            URLQueryItem(
                name: "appid",
                value: apikey
            )
        ]
        return component
    }()
    
    ///Private constructor
    private init() {}
    
    ///Fetch current weather
    func fetchCurrentWeather(for city: String, completion: @escaping (Result<CurrentModel, Error>) -> Void) {
        var component = urlComponent
        component.path = "/data/2.5/weather"
        component.queryItems?.append(URLQueryItem(name: "q", value: city))
        component.queryItems?.append(URLQueryItem(name: "units", value: "metric"))

        guard let url = component.url else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let currentWeather = try JSONDecoder().decode(CurrentModel.self, from: data)
                completion(.success(currentWeather))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    /// Fetch 5-day forecast
    func fetchFiveDayForecast(for city: String, completion: @escaping (Result<ForecastModel, Error>) -> Void) {
        var component = urlComponent
        component.path = "/data/2.5/forecast"
        component.queryItems?.append(URLQueryItem(name: "q", value: city))
        component.queryItems?.append(URLQueryItem(name: "units", value: "metric"))
        
        guard let url = component.url else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let forecast = try JSONDecoder().decode(ForecastModel.self, from: data)
                completion(.success(forecast))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
