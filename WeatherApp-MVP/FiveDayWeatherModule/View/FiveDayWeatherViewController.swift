//
//  FiveDayWeatherViewController.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 28.09.2022.
//

import UIKit
import CoreLocation

final class FiveDayWeatherViewController: UIViewController {
    
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
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.systemFont50
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private lazy var locSearchStackView = UIStackView(arrangedSubviews: [citySearchBar,
                                                                         locationButton],
                                                      axis: .horizontal)
    
    private let detailsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        return tableView
    }()
    
    // MARK: - Private properties
    private let locationManager = CLLocationManager()
    
    // MARK: - Public properties
    public var presenter: FiveDayWeatherPresenterProtocol?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setDelegates()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.loadSavedWeather()
    }
    
    // MARK: - Private methods
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(locSearchStackView)
        view.addSubview(cityLabel)
        view.addSubview(detailsTableView)
    
        detailsTableView.register(DetailsTableViewCell.self,
                                  forCellReuseIdentifier: DetailsTableViewCell.reuseID)
    }
    
    private func setDelegates() {
        citySearchBar.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.delegate = self
        locationManager.delegate = self
    }
    
    private func locationRequests() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

// MARK: - FiveDayWeatherViewProtocol
extension FiveDayWeatherViewController: FiveDayWeatherViewProtocol {
    @objc func locationButtonTapped() {
        locationManager.requestLocation()
    }
    
    func updateCityLabel(with city: String) {
        cityLabel.text = city
    }
    
    func reloadDetailTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.detailsTableView.reloadData()
        }
    }
    
    func showAlert(_ alert: UIAlertController) {
        self.present(alert, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension FiveDayWeatherViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let cityName = searchBar.text {
            presenter?.getFiveDayWeatherCity(for: cityName)
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


// MARK: - UITableViewDataSource
extension FiveDayWeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter?.getSectionHeader(for: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.fiveDayWeatherData?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = detailsTableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.reuseID) as? DetailsTableViewCell {
            if let viewData = presenter?.getDetailsWeather(for: indexPath.section) {
                cell.configure(with: viewData)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate
extension FiveDayWeatherViewController: UITableViewDelegate {
    
}

// MARK: - CLLocationManagerDelegate
extension FiveDayWeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        presenter?.getFiveDayWeatherCoordinates(latitude: lat, longitude: lon)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// MARK: - setConstraints
extension FiveDayWeatherViewController {
    private func setConstraints() {
        // set margins
        view.layoutMargins = UIEdgeInsets(top: Constants.spacing20,
                                          left: Constants.spacing20,
                                          bottom: Constants.spacing20,
                                          right: Constants.spacing20)
        let margins = view.layoutMarginsGuide
        
        // set constraints
        NSLayoutConstraint.activate([
            locationButton.heightAnchor.constraint(equalToConstant: 40),
            locationButton.widthAnchor.constraint(equalToConstant: 40),
            
            locSearchStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            locSearchStackView.topAnchor.constraint(equalTo: margins.topAnchor),
            locSearchStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            
            
            cityLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            cityLabel.topAnchor.constraint(equalTo: locationButton.bottomAnchor, constant: Constants.spacing10),

            detailsTableView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            detailsTableView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: Constants.spacing20),
            detailsTableView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            detailsTableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
        ])
    }
}


#if DEBUG
import SwiftUI

struct FiveDayWeatherViewController_Preview: PreviewProvider {
    static var previews: some View {
        FiveDayWeatherViewController().showPreview()
    }
}
#endif
