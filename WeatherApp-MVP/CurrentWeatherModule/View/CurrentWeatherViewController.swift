//
//  ViewController.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 27.09.2022.
//

import UIKit

final class CurrentWeatherViewController: UIViewController {
    
    // MARK: - Declare UI elements
    private let citySearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "find location"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Current city"
        label.font = Constants.systemFont50
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let degreeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "+16°C"
        label.font = Constants.systemFont80
        label.textColor = .label
        label.textAlignment = .center
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
    
    private lazy var currentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [citySearchBar,
                                                      cityLabel,
                                                      degreeLabel,
                                                      conditionImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Constants.defaultSpacing40
        return stackView
    }()
    
    // MARK: - Public properties
    public var presenter: CurrentWeatherPresenterProtocol?

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setDelegates()
        setConstraints()
    }
    
    // MARK: - Private methods
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(currentStackView)
    }
    
    private func setDelegates() {
        citySearchBar.delegate = self
    }
}

// MARK: - CurrentWeatherViewProtocol
extension CurrentWeatherViewController: CurrentWeatherViewProtocol {
    func reloadWeather(city: String, degree: String, condition: String) {
        cityLabel.text = city
        degreeLabel.text = degree
        conditionImageView.image = UIImage(systemName: condition)
    }
}

// MARK: - UISearchBarDelegate
extension CurrentWeatherViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // make request with city name
        if let cityName = searchBar.text {
            presenter?.getWeather(for: cityName)
        } else {
            searchBar.placeholder = "print the city name here"
        }

        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
}

// MARK: - setConstraints
extension CurrentWeatherViewController {
    private func setConstraints() {
        // set margins
        view.layoutMargins = UIEdgeInsets(top: Constants.defaultSpacing20,
                                          left: Constants.defaultSpacing20,
                                          bottom: Constants.defaultSpacing20,
                                          right: Constants.defaultSpacing20)
        let margins = view.layoutMarginsGuide
        
        // set priorities
        conditionImageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        cityLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        degreeLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        // set constraints
        NSLayoutConstraint.activate([
            currentStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            currentStackView.topAnchor.constraint(equalTo: margins.topAnchor),
            currentStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            currentStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
        ])
    }
}
