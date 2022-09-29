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
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Temperature"
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "14°C"
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel,
                                                      valueLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
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
        addSubview(labelsStackView)
    }
    
    private func setConstraints() {
//        layoutMargins = UIEdgeInsets(top: 0,
//                                     left: Constants.spacing10,
//                                     bottom: 0,
//                                     right: Constants.spacing10)
        let margins = layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            labelsStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            labelsStackView.topAnchor.constraint(equalTo: margins.topAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
        ])
    }
}
