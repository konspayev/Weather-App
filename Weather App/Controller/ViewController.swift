//
//  ViewController.swift
//  Weather App
//
//  Created by Nursultan Konspayev on 03.08.2024.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    //MARK: - Properties
    private lazy var cityTitle: UILabel = {
        let label = UILabel()
        label.text = "Astana"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 48, weight: .heavy)
        return label
    }()
    
    private lazy var weatherCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 0
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: WeatherCollectionViewCell.identifier)
        collection.register(ForecastHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ForecastHeaderCollectionReusableView.identifier)
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    private var currentWeather: CurrentModel?
    
    private var dailyForecast: [DailyForecast] = []
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
        fetchWeatherData()
    }
    
    //MARK: - Methods
    private func setupUI() {
        view.addSubview(cityTitle)
        view.addSubview(weatherCollection)
        
        cityTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(34)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(26)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-34)
        }
        
        weatherCollection.snp.makeConstraints { make in
            make.top.equalTo(cityTitle.snp.bottom).offset(31)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(26)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-26)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }
    
    private func fetchWeatherData() {
        let city = "Astana"
        
        NetworkManager.shared.fetchCurrentWeather(for: city) { [weak self] result in
            switch result {
            case .success(let currentWeather):
                DispatchQueue.main.async {
                    self?.currentWeather = currentWeather
                }
            case .failure(let error):
                print("Failed to fetch current weather data: \(error.localizedDescription)")
            }
        }
        
        NetworkManager.shared.fetchFiveDayForecast(for: city) { [weak self] result in
            switch result {
            case .success(let forecast):
                DispatchQueue.main.async {
                    self?.dailyForecast = self?.processForecastData(forecast.list) ?? []
                    self?.weatherCollection.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch forecast weather data: \(error.localizedDescription)")
            }
        }
    }
    
    private func processForecastData(_ forecastList: [List]) -> [DailyForecast] {
        var dailyForecasts: [DailyForecast] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let filteredForecasts = forecastList.filter { item in
            guard let date = dateFormatter.date(from: item.dtTxt) else { return false }
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour], from: date)
            return components.hour == 12
        }
        
        // Создаем массив DailyForecast из отфильтрованных данных
        for item in filteredForecasts {
            guard let weatherDescription = item.weather.first?.description else {
                continue
            }
            
            let dailyForecast = DailyForecast(
                day: dateFormatter.date(from: item.dtTxt) ?? Date(),
                id: item.weather.first?.id ?? 800,
                weatherDescription: weatherDescription,
                averageTemp: item.main.temp
            )
            
            dailyForecasts.append(dailyForecast)
        }
        
        return dailyForecasts
    }
    
    
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : dailyForecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.identifier, for: indexPath) as? WeatherCollectionViewCell else { fatalError() }
        
        if indexPath.section == 0 {
            if let currentWeather = currentWeather {
                cell.configure(with: currentWeather)
            }
        } else {
            let forecastItem = dailyForecast[indexPath.item]
            cell.configure(with: forecastItem)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 144)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section == 1 ? CGSize(width: collectionView.frame.width, height: 24) : .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ForecastHeaderCollectionReusableView.identifier, for: indexPath) as? ForecastHeaderCollectionReusableView else { fatalError() }
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 49, right: 0)
    }
}
