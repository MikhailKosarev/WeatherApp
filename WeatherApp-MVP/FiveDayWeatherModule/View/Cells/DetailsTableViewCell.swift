//
//  DetailsTableViewCell.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 29.09.2022.
//

import UIKit

final class DetailsTableViewCell: UITableViewCell {
    
    // MARK: - Static properties
    static let reuseID = "DetailsTableViewCell"
    
    // MARK: - Declare UI elements
    private let tempMaxTitleLabel = UILabel.makeDetailWeatherCellTitleLabel(text: "Temperature max")
    private let tempMaxValueLabel = UILabel.makeDetailWeatherCellValueLabel()
    private lazy var tempMaxStackView = UIStackView(arrangedSubviews: [tempMaxTitleLabel, tempMaxValueLabel])
    
    private let feelsLikeTitleLabel = UILabel.makeDetailWeatherCellTitleLabel(text: "Feels like")
    private let feelsLikeValueLabel = UILabel.makeDetailWeatherCellValueLabel()
    private lazy var feelsLikeStackView = UIStackView(arrangedSubviews: [feelsLikeTitleLabel, feelsLikeValueLabel])
    
    private let tempMinTitleLabel = UILabel.makeDetailWeatherCellTitleLabel(text: "Temperature min")
    private let tempMinValueLabel = UILabel.makeDetailWeatherCellValueLabel()
    private lazy var tempMinStackView = UIStackView(arrangedSubviews: [tempMinTitleLabel, tempMinValueLabel])
    
    private let humidityTitleLabel = UILabel.makeDetailWeatherCellTitleLabel(text: "Humidity")
    private let humidityValueLabel = UILabel.makeDetailWeatherCellValueLabel()
    private lazy var humidityStackView = UIStackView(arrangedSubviews: [humidityTitleLabel, humidityValueLabel])
    
    private let windSpeedTitleLabel = UILabel.makeDetailWeatherCellTitleLabel(text: "Wind speed")
    private let windSpeedValueLabel = UILabel.makeDetailWeatherCellValueLabel()
    private lazy var windSpeedStackView = UIStackView(arrangedSubviews: [windSpeedTitleLabel, windSpeedValueLabel])
    
    private let pressureTitleLabel = UILabel.makeDetailWeatherCellTitleLabel(text: "Pressure")
    private let pressureValueLabel = UILabel.makeDetailWeatherCellValueLabel()
    private lazy var pressureStackView = UIStackView(arrangedSubviews: [pressureTitleLabel, pressureValueLabel])
    
    private lazy var mainStackView = UIStackView(arrangedSubviews: [tempMaxStackView,
                                                                   feelsLikeStackView,
                                                                    tempMinStackView,
                                                                    humidityStackView,
                                                                    windSpeedStackView,
                                                                    pressureStackView],
                                                 axis: .vertical)
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setupView() {
        addSubview(mainStackView)
    }
    
    private func setConstraints() {
        let margins = layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            mainStackView.topAnchor.constraint(equalTo: margins.topAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
        ])
    }
    
    // MARK: - Public methods
    public func configure(with viewData: DetailWeatherViewData) {
//        titleLabel.text = viewData.
    }
}
