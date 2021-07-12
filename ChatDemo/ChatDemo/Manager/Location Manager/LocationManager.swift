//
//  LocationManager.swift
//  ChatDemo
//
//  Created by Amit Chauhan on 28/04/20.
//  Copyright © 2020 Amit Chauhan. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

protocol LocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation])
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
}

class LocationManager: NSObject, CLLocationManagerDelegate {

    var location:CLLocation?
    var location_Manager:CLLocationManager?
    var delegate:LocationManagerDelegate?
    
    static let sharedInstanse = LocationManager()
    
    
    func startLocationManager(){
        if let _ = location_Manager{
            if (CLLocationManager.locationServicesEnabled()){
                location_Manager?.requestLocation()
                location_Manager?.startUpdatingLocation()
            }
        }else{
            location_Manager = CLLocationManager()
            location_Manager?.delegate = self
            location_Manager?.desiredAccuracy = kCLLocationAccuracyBest
            location_Manager?.distanceFilter = 10
            //            location_Manager?.requestAlwaysAuthorization()
            location_Manager?.requestWhenInUseAuthorization()
            if (CLLocationManager.locationServicesEnabled()){
                location_Manager?.requestLocation()
                location_Manager?.startUpdatingLocation()
            }
        }
    }
    
    func stopLocationManager(){
        location_Manager?.stopUpdatingLocation()
    }

    
    
    // MARK:- Location Manager Delegate method
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        stopLocationManager()
        print("Error \(error)")
        delegate?.locationManager(manager, didFailWithError: error)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
//        let currentLocation = locations.last! as CLLocation
        print("locations >>> \(locations)")

        delegate?.locationManager(manager, didUpdateLocations: locations)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        if status == .authorizedWhenInUse {
            location_Manager?.requestLocation()
            location_Manager?.startUpdatingLocation()
        }

        delegate?.locationManager(manager, didChangeAuthorization: status)
    }

    
}
