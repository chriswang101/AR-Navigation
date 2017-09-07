//
//  ViewController.swift
//  AR Navigation
//
//  Created by Chris Wang on 9/1/17.
//  Copyright © 2017 Chris Wang. All rights reserved.
//

import UIKit
import MapKit

protocol SearchHandleDelegate {
    func didSelectLocation(selectedLocation: location)
}

var searchResultsController: UISearchController? = nil

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let defaultRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2DMake(34.0216878, -118.2857177),
        span: MKCoordinateSpanMake(0.1, 0.1)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        // Set map to default location
        mapView.setRegion(defaultRegion, animated: true)
        
        // Configure searchResultsController
        let searchResultsTable = storyboard!.instantiateViewController(withIdentifier: "LocationTableViewController") as! LocationTableViewController
        searchResultsController = UISearchController(searchResultsController: searchResultsTable)
        searchResultsController?.searchResultsUpdater = searchResultsTable
        searchResultsTable.delegate = self
        // Initialize search bar
        let searchBar = searchResultsController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for a location"
        navigationItem.titleView = searchResultsController?.searchBar
        
        // Configure UISearchController appearance
        searchResultsController?.hidesNavigationBarDuringPresentation = false
        searchResultsController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations[0])
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("There was an error: \(error)")
    }
}

extension MapViewController: SearchHandleDelegate {
    func didSelectLocation(selectedLocation: location) {
        print(selectedLocation.name)
        
    }
}
