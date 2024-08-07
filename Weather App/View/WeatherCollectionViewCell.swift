//
//  WeatherCollectionViewCell.swift
//  Weather App
//
//  Created by Nursultan Konspayev on 03.08.2024.
//

import UIKit
import SnapKit

class WeatherCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "WeatherCollectionViewCell"
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        return label
    }()
    
    private lazy var weatherLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .white	
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private lazy var weatherImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dayLabel.text = nil
        weatherLabel.text = nil
        temperatureLabel.text = nil
        weatherImage.image = nil
    }
    
    //MARK: - Methods
    private func setupUI() {
        contentView.backgroundColor = UIColor(red: 0.38, green: 0.32, blue: 0.76, alpha: 1.00)
        contentView.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 30
        
        contentView.addSubview(dayLabel)
        contentView.addSubview(weatherLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(weatherImage)
        
        dayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(46)
            make.leading.equalToSuperview().offset(15)
        }
        
        weatherLabel.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom).offset(26)
            make.leading.equalToSuperview().offset(15)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImage.snp.bottom).offset(13)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-15)
        }
        
        weatherImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(33)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
    
    func configure(with currentWeather: CurrentModel) {
            dayLabel.text = "Today"
            weatherLabel.text = currentWeather.weather.first?.description.capitalized
            temperatureLabel.text = "\(Int(currentWeather.main.temp))℃"
            
            let weatherCondition = currentWeather.weather.first?.id ?? 0
        weatherImage.image = UIImage(named: getWeatherImageName(for: weatherCondition))?.withTintColor(getTintColor(for: weatherCondition))
        }
    
    private func getWeatherImageName(for condition: Int) -> String {
        switch condition {
        case 200...232: return "thunderstorm"
        case 300...321: return "dizzle"
        case 500...531: return "rain"
        case 600...622: return "snow"
        case 700...781: return "fog"
        case 800: return "sunny"
        case 801...804: return "cloud"
        default: return ""
        }
    }
    
    private func getTintColor(for condition: Int) -> UIColor {
        switch condition {
        case 200...232: return .darkGray
        case 300...321: return .blue.withAlphaComponent(0.5)
        case 500...531: return .blue
        case 600...622: return .white
        case 700...781: return .lightGray
        case 800: return .yellow
        case 801...804: return .gray
        default: return UIColor()
        }
    }

    
    func configure(with forecast: DailyForecast) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dayLabel.text = dateFormatter.string(from: forecast.day)
        weatherLabel.text = forecast.weatherDescription.capitalized
        temperatureLabel.text = "\(Int(forecast.averageTemp))℃"
        
        let weatherCondition = forecast.id
        weatherImage.image = UIImage(named: getWeatherImageName(for: weatherCondition))?.withTintColor(getTintColor(for: weatherCondition))
    }
}
