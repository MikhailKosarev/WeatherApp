//
//  FiveDayWeatherViewController.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 28.09.2022.
//

import UIKit

final class FiveDayWeatherViewController: UIViewController {
    
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
    
    private let detailsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Public properties
    public var presenter: FiveDayWeatherPresenterProtocol?
    
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
        view.addSubview(citySearchBar)
        view.addSubview(cityLabel)
        view.addSubview(detailsTableView)

        
        let userDefaults = UserDefaults.standard
        let test = userDefaults.string(forKey: Constants.savedCityName)
        print(test)
        
        detailsTableView.register(DetailsTableViewCell.self,
                                  forCellReuseIdentifier: DetailsTableViewCell.reuseID)
    }
    
    private func setDelegates() {
        citySearchBar.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.delegate = self
    }
}

// MARK: - FiveDayWeatherViewProtocol
extension FiveDayWeatherViewController: FiveDayWeatherViewProtocol {
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
        // make request with city name
        
        if let cityName = searchBar.text {
            presenter?.getFiveDayWeather(for: cityName)
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
//        return "Header \(section)"
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
            citySearchBar.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            citySearchBar.topAnchor.constraint(equalTo: margins.topAnchor),
            citySearchBar.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            
            
            cityLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            cityLabel.topAnchor.constraint(equalTo: citySearchBar.bottomAnchor, constant: Constants.spacing10),

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
