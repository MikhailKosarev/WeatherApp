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
    
    private let daysCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
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
        view.addSubview(daysCollectionView)
        view.addSubview(detailsTableView)
        
        daysCollectionView.register(DaysCollectionViewCell.self.self,
                                    forCellWithReuseIdentifier: DaysCollectionViewCell.reuseID)
        detailsTableView.register(DetailsTableViewCell.self,
                                  forCellReuseIdentifier: DetailsTableViewCell.reuseID)
    }
    
    private func setDelegates() {
        daysCollectionView.dataSource = self
        daysCollectionView.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.delegate = self
    }
}

// MARK: - FiveDayWeatherViewProtocol
extension FiveDayWeatherViewController: FiveDayWeatherViewProtocol {
    
}

// MARK: - UICollectionViewDataSource
extension FiveDayWeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = daysCollectionView.dequeueReusableCell(withReuseIdentifier: DaysCollectionViewCell.reuseID, for: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension FiveDayWeatherViewController: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDelegateFlowLayout
extension FiveDayWeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 200
        let width: CGFloat = (view.bounds.width - 2 * Constants.spacing20) / 6
        return CGSize(width: width, height: height)
    }
}

// MARK: - UITableViewDataSource
extension FiveDayWeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Header \(section)"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = detailsTableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.reuseID) {
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
            
            daysCollectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            daysCollectionView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor,
                                                    constant: Constants.spacing20),
            daysCollectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            daysCollectionView.heightAnchor.constraint(equalToConstant: 200),
            
            detailsTableView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            detailsTableView.topAnchor.constraint(equalTo: daysCollectionView.bottomAnchor),
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
