//
//  MapViewController.swift
//  AR Campus
//
//  Created by Chris Wang on 11/10/17.
//  Copyright © 2017 Chris Wang. All rights reserved.
//

import UIKit
import MapKit

// Protocol for dropping a pin at a specified place
protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func navigateButton(_ sender: Any) {
        
    }
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var routeCoordinates = [CLLocationCoordinate2D]()
    
    var resultSearchController: UISearchController?
    
    var selectedPin: MKPlacemark?
    
    // Temp Vars
    let sc = CLLocationCoordinate2D(latitude: 34.0195564, longitude: -118.2889155)
    let poFar = CLLocationCoordinate2D(latitude: 34.0949717, longitude: -117.7172595)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuring location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // Configure mapView
        mapView.delegate = self
        mapView.showsUserLocation = true

        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        guard let userCoordinate = locationManager.location?.coordinate else { return }
        let userRegion: MKCoordinateRegion = MKCoordinateRegion(center: userCoordinate, span: coordinateSpan)
        // Zoom to user location
        mapView.setRegion(userRegion, animated: true)
        
        // Hide back button
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        // Configure location search table view controller
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        locationSearchTable.handleMapSearchDelegate = self
        
        // Configure search bar
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        
        // Configure result search controller
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        // Hook up MapViewController's mapView to locationSearchTable
        locationSearchTable.mapView = mapView
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ARSegue" {
            let destinationViewController = segue.destination as? ViewController
            
            // Pass the selected object to the new view controller.
            destinationViewController?.routeCoordinates = self.routeCoordinates
        }
    }

    func calculateDirections(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let sourcePlacemark = MKPlacemark(coordinate: source)
        let destPlacemark = MKPlacemark(coordinate: destination)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destMapItem = MKMapItem(placemark: destPlacemark)
        let request = MKDirectionsRequest()
        request.source = sourceMapItem
        request.destination = destMapItem
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            
            if let error = error {
                print("There was an error " + error.localizedDescription)
                return
            }
            
            if let routeResponse = response?.routes {
                let route: MKRoute =
                    routeResponse.sorted(by: {$0.expectedTravelTime <
                        $1.expectedTravelTime})[0]
                
                // TODO: Implement travel time functionality
                print("Expected travel time \(route.expectedTravelTime)")
            
                // First of all overlay the route on the MapView
                for step in route.steps {
                    let stepCoordinate = step.polyline.coordinate
                    self.routeCoordinates.append(stepCoordinate)
                    
                    let stepLocation = CLLocation(latitude: stepCoordinate.latitude, longitude: stepCoordinate.longitude)
                }
                self.plotPolyline(route: route)
            }
        }
    }
    
    func plotPolyline(route: MKRoute) {
        mapView.add(route.polyline)
        // Set map view visible area
        mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
    }
    
    func getDirections() {
        performSegue(withIdentifier: "ARSegue", sender: self)
    }
}


extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        if (overlay is MKPolyline) {
            polylineRenderer.strokeColor =
                UIColor.blue.withAlphaComponent(0.75)
            polylineRenderer.lineWidth = 5
        }
        return polylineRenderer
    }
    
    // TODO: CHange this to a bottom sheet pop up view
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.green
        pinView?.canShowCallout = true
        return pinView
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0]
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error finding location: \(error.localizedDescription)")
    }
}


extension MapViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.2, 0.2)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
        
        // Plot a route to the destination from the user's current location
        guard let userCoordinate = locationManager.location?.coordinate else { return }
        calculateDirections(from: userCoordinate, to: placemark.coordinate)
    }
}


