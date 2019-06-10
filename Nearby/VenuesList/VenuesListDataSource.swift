//
//  VenuesListDataSource.swift
//  Nearby
//
//  Created by Tung Vo on 10.6.2019.
//  Copyright © 2019 Tung Vo. All rights reserved.
//

import UIKit
import CoreLocation

protocol VenuesListDataSource: UITableViewDataSource {
    func configure(_ tableView: UITableView)
    func loadVenues(around location: CLLocationCoordinate2D, completion: ((Error?) -> Void)?)
}

enum VenuesListContentState {
    case initial
    case loaded([Venue])
    case error(Error?)
}

final class VenuesListDataProvider: NSObject, VenuesListDataSource, UITableViewDataSource, VenueTableViewCellDelegate {
    
    var tableView: UITableView?
    
    // Api request
    let nearbyVenuesRequestLoader = APIRequestLoader(request: NearbyVenuesRequest())
    
    // Handling favorite state of venue
    var venueController: VenuesControlling = VenuesController()
    
    private var cellIdentifier: String { return "Cell" }
    
    private var contentState: VenuesListContentState = .initial {
        didSet {
            tableView?.reloadData()
            configureTableView(for: contentState)
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch contentState {
        case let .loaded(venues):
            return venues.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let venue = venueForCell(at: indexPath) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? VenueTableViewCell {
                cell.populate(from: venue, isFavorited: venueController.isVenueFavorited(venue))
                cell.delegate = self
                return cell
            } else {
                fatalError("Table view is not correctly configured") // Must have unit test for this
            }
        }
        
        fatalError("This method should not be called if not for showing venues") // Must have unit test for this
    }
    
    func loadVenues(around location: CLLocationCoordinate2D, completion: ((Error?) -> Void)?) {
        nearbyVenuesRequestLoader.loadRequest(requestData: location) { [weak self] (venues, error) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.contentState = .error(error)
                } else if let venues = venues {
                    self.contentState = .loaded(self.makeVenues(from: venues))
                } else {
                    self.contentState = .loaded([])
                }
            }
            
            completion?(error)
        }
    }
    
    func configure(_ tableView: UITableView) {
        tableView.register(UINib(nibName: "VenueTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.tableView = tableView
        configureTableView(for: contentState)
    }
    
    func makeVenues(from venues: [Venue]) -> [Venue] {
        return Array(venues.prefix(15))
    }
    
    private func venueForCell(at indexPath: IndexPath) -> Venue? {
        switch contentState {
        case let .loaded(venues):
            if venues.count > indexPath.row {
                return venues[indexPath.row]
            }
        default:
            break
        }
        return nil
    }
    
    // Litle optimization for empty state. Row height is same as when there is data.
    private func configureTableView(for state: VenuesListContentState) {
        switch contentState {
        case .loaded:
            tableView?.rowHeight = UITableView.automaticDimension
        default:
            tableView?.rowHeight = 80
        }
    }
    
    // MARK: - VenueTableViewCellDelegate
    func venueTableViewCell(_ cell: VenueTableViewCell, favoriteDidChange isFavorite: Bool) {
        if let indexPath = tableView?.indexPath(for: cell), let venue = venueForCell(at: indexPath) {
            venueController.updateVenue(venue, with: isFavorite)
        }
    }
}
