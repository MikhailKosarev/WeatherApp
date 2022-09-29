//
//  DaysCollectionViewCell.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 29.09.2022.
//

import UIKit

final class DaysCollectionViewCell: UICollectionViewCell {
    // MARK: - Static properties
    static let reuseID = "DaysCollectionViewCell"
    
    // MARK: - Declare UI elements
    private let dayOfWeekLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Fr"
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        return label
    }()
    
    private let dayOfMonthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "29"
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .label
        return label
    }()
    
    private let conditionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "cloud.drizzle")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        return imageView
    }()
    
    private let tempMaxLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "14°C"
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        return label
    }()
    
    private let tempMinLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "7°C"
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        return label
    }()
    
    private let pressureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1015 mbar"
        label.numberOfLines = 2
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        return label
    }()
    
    private lazy var dayStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [dayOfWeekLabel,
                                                     dayOfMonthLabel,
                                                     conditionImageView,
                                                     tempMaxLabel,
                                                     tempMinLabel,
                                                     pressureLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setupView() {
        contentView.addSubview(dayStackView)
        layer.cornerRadius = Constants.radius10
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
    }
    
    private func setConstraints() {
        layoutMargins = UIEdgeInsets(top: Constants.spacing10,
                                     left: 0,
                                     bottom: Constants.spacing10,
                                     right: 0)
        let margins = layoutMarginsGuide
        NSLayoutConstraint.activate([
            dayStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            dayStackView.topAnchor.constraint(equalTo: margins.topAnchor),
            dayStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            dayStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
        ])
    }
}
