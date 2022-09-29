//
//  DaysCollectionView.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 28.09.2022.
//

import UIKit


final class DaysView: UIView {
    
    // MARK: - Declare UI elements
    private let daysCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .green
        return collectionView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
//        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
