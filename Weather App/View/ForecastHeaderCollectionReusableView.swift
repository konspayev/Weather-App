//
//  ForecastHeaderCollectionReusableView.swift
//  Weather App
//
//  Created by Nursultan Konspayev on 04.08.2024.
//

import UIKit
import SnapKit

class ForecastHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "ForecastHeaderCollectionReusableView"
    
    private lazy var headerTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "Forcast for 7 days"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerTitle)
        
        headerTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
