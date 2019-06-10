//
//  VenuesListViewController.swift
//  Nearby
//
//  Created by Tung Vo on 10.6.2019.
//  Copyright © 2019 Tung Vo. All rights reserved.
//

import UIKit
import CoreLocation

final class VenuesListViewController: UITableViewController {
    
    var venuesDataSource: VenuesListDataSource = VenuesListDataProvider()
    
    var locationManager: UserLocationManaging = RandomLocationProvider()
    
    private lazy var loader: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        view.hidesWhenStopped = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        venuesDataSource.configure(tableView)
        tableView.dataSource = venuesDataSource // Data source set on view controller (meaning venuesDataSource can be reused in multiple tableView)
        
        let barButtonItem = UIBarButtonItem(customView: loader)
        navigationItem.rightBarButtonItem = barButtonItem
        
        title = "Nearby"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startGettingUserLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopGettingUserLocation()
    }
    
    private func startGettingUserLocation() {
        locationManager.startGettingLocationPeriodically(withTimeInterval: 10) { [weak self] location in
            guard let self = self, let location = location else { return }
            self.loadVenues(around: location)
        }
    }
    
    private func stopGettingUserLocation() {
        locationManager.stopGettingLocation()
    }
    
    private func loadVenues(around location: CLLocationCoordinate2D) {
        loader.startAnimating()
        venuesDataSource.loadVenues(around: location) { [weak self] error in
            DispatchQueue.main.async {
                self?.loader.stopAnimating()
            }
        }
    }

}

