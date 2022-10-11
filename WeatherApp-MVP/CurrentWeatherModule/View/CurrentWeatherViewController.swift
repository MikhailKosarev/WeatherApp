//
//  ViewController.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 27.09.2022.
//

import UIKit
import CoreLocation

final class CurrentWeatherViewController: UIViewController {
    
    // MARK: - Declare UI elements
    private lazy var locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: Constants.locationImageSystemName), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let citySearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "find location"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    private let cityLabel = UILabel.makeWeatherInfoLabel(font: Constants.systemFont50)
    private let degreeLabel = UILabel.makeWeatherInfoLabel(font: Constants.systemFont80)
    private let feelsLikeLabel = UILabel.makeWeatherInfoLabel(font: Constants.systemFont30)
    private let windLabel = UILabel.makeWeatherInfoLabel(font: Constants.systemFont30)
    private let humidityLabel = UILabel.makeWeatherInfoLabel(font: Constants.systemFont30)
    
    private let conditionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        return imageView
    }()
    
    private lazy var locSearchStackView = UIStackView(arrangedSubviews: [citySearchBar,
                                                                         locationButton],
                                                      axis: .horizontal)
    
    private lazy var currentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [locSearchStackView,
                                                       cityLabel,
                                                       conditionImageView,
                                                       degreeLabel,
                                                       feelsLikeLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.setCustomSpacing(Constants.spacing10, after: locSearchStackView)
        stackView.setCustomSpacing(Constants.spacing10, after: degreeLabel)
        stackView.spacing = Constants.spacing40
        return stackView
    }()
    
    // MARK: - Private properties
    private let locationManager = CLLocationManager()
    
    // MARK: - Public properties
    public var presenter: CurrentWeatherPresenterProtocol?

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setDelegates()
        setConstraints()
        locationRequests()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.loadSavedWeather()
    }
    
    // MARK: - Private methods
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(currentStackView)
    }
    
    private func setDelegates() {
        citySearchBar.delegate = self
        locationManager.delegate = self
    }
    
    private func locationRequests() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

// MARK: - CurrentWeatherViewProtocol
extension CurrentWeatherViewController: CurrentWeatherViewProtocol {
    @objc func locationButtonTapped() {
        locationManager.requestLocation()
    }
    
    func showAlert(_ alert: UIAlertController) {
        self.present(alert, animated: true)
    }
    
    func reloadWeather(viewData: CurrentWeatherViewData)  {
        cityLabel.text = viewData.fullCityName
        conditionImageView.image = UIImage(systemName: viewData.conditionName)
        degreeLabel.text = viewData.temperatureString
        feelsLikeLabel.text = viewData.feelsLikeString
    }
}

// MARK: - UISearchBarDelegate
extension CurrentWeatherViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // make request with city name
        if let cityName = searchBar.text {
            presenter?.getCurrentWeatherCity(for: cityName)
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

// MARK: - CLLocationManagerDelegate
extension CurrentWeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        presenter?.getCurrentWeatherCoordinates(latitude: lat, longitude: lon)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// MARK: - setConstraints
extension CurrentWeatherViewController {
    private func setConstraints() {
        // set margins
        view.layoutMargins = UIEdgeInsets(top: Constants.spacing20,
                                          left: Constants.spacing20,
                                          bottom: Constants.spacing20,
                                          right: Constants.spacing20)
        let margins = view.layoutMarginsGuide
        
        // set priorities
        conditionImageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        cityLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        degreeLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        // set constraints
        NSLayoutConstraint.activate([
            locationButton.heightAnchor.constraint(equalToConstant: 40),
            locationButton.widthAnchor.constraint(equalToConstant: 40),
            
            conditionImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            
            currentStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            currentStackView.topAnchor.constraint(equalTo: margins.topAnchor),
            currentStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            currentStackView.bottomAnchor.constraint(lessThanOrEqualTo: margins.bottomAnchor)
        ])
    }
}

#if DEBUG
import SwiftUI

struct CurrentWeatherViewController_Preview: PreviewProvider {
    static var previews: some View {
        CurrentWeatherViewController().showPreview()
    }
}
#endif
