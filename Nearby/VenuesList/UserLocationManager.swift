//
//  UserLocationManager.swift
//  Nearby
//
//  Created by Tung Vo on 10.6.2019.
//  Copyright © 2019 Tung Vo. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

/// Responsible for providing user location
/// We can easily replace current implementation of hard-coded data
/// with real values getting from CLLocationManageer.
protocol UserLocationManaging {
    func startGettingLocationPeriodically(withTimeInterval: TimeInterval, completion: ((CLLocationCoordinate2D?) -> Void)?)
    func stopGettingLocation()
}

// MARK: - RandomLocationProvider
final class RandomLocationProvider: UserLocationManaging {
    
    private var completion: ((CLLocationCoordinate2D?) -> Void)?
    
    private var timer: Timer?
    
    private lazy var locations: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 60.170187, longitude: 24.930599),
        CLLocationCoordinate2D(latitude: 60.169418, longitude: 24.931618),
        CLLocationCoordinate2D(latitude: 60.169818, longitude: 24.932906),
        CLLocationCoordinate2D(latitude: 60.170005, longitude: 24.935105),
        CLLocationCoordinate2D(latitude: 60.169108, longitude: 24.936210),
        CLLocationCoordinate2D(latitude: 60.168355, longitude: 24.934869),
        CLLocationCoordinate2D(latitude: 60.167560, longitude: 24.932562),
        CLLocationCoordinate2D(latitude: 60.168254, longitude: 24.931532),
        CLLocationCoordinate2D(latitude: 60.169012, longitude: 24.930341),
        CLLocationCoordinate2D(latitude: 60.170085, longitude: 24.929569)
    ]
    
    func startGettingLocationPeriodically(withTimeInterval timeInterval: TimeInterval, completion: ((CLLocationCoordinate2D?) -> Void)?) {
        self.completion = completion
        timer?.invalidate()
        
        self.completion?(self.locations.randomElement())
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            self.completion?(self.locations.randomElement())
        })
    }
    
    func stopGettingLocation() {
        timer?.invalidate()
    }
    
}
