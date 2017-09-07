//
//  ARViewController.swift
//  AR Navigation
//
//  Created by Chris Wang on 9/2/17.
//  Copyright © 2017 Chris Wang. All rights reserved.
//

import UIKit
import SceneKit
import MapKit
import ARCL

class ARViewController: UIViewController {
    
    let sceneLocationView = SceneLocationView()
    
    let mapView = MKMapView()
    var userAnnotation: MKPointAnnotation?
    var locationEstimateAnnotation: MKPointAnnotation?
    var updateUserLocationTimer: Timer?
    
    var infoLabel = UILabel()
    var updateInfoLabelTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneLocationView.showAxesNode = true
        sceneLocationView.locationDelegate = self
        
        
        
        // Set the destination location
        let pinCoordinate = CLLocationCoordinate2D(latitude: 33.8908694, longitude: -118.3774712)
        let pinLocation = CLLocation(coordinate: pinCoordinate, altitude: 10)
        let pinImage = UIImage(named: "pin")!
        let pinLocationNode = LocationAnnotationNode(location: pinLocation, image: pinImage)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: pinLocationNode)
        view.addSubview(sceneLocationView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneLocationView.run()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneLocationView.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = CGRect(
            x: 0,
            y: 0,
            width: self.view.frame.size.width,
            height: self.view.frame.size.height)
        
        infoLabel.frame = CGRect(x: 6, y: 0, width: self.view.frame.size.width - 12, height: 14 * 4)
        
        //        if showMapView {
        //            infoLabel.frame.origin.y = (self.view.frame.size.height / 2) - infoLabel.frame.size.height
        //        } else {
        //            infoLabel.frame.origin.y = self.view.frame.size.height - infoLabel.frame.size.height
        //        }
        
        mapView.frame = CGRect(
            x: 0,
            y: self.view.frame.size.height / 2,
            width: self.view.frame.size.width,
            height: self.view.frame.size.height / 2)
    }
    

}

// MKMapViewDelegate methods
extension ARViewController: MKMapViewDelegate {
    
}

// SceneLocationViewDelegate methods
extension ARViewController: SceneLocationViewDelegate {
    
    func sceneLocationViewDidAddSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        
    }
    
    func sceneLocationViewDidRemoveSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        
    }
    
    func sceneLocationViewDidConfirmLocationOfNode(sceneLocationView: SceneLocationView, node: LocationNode) {
        
    }
    
    func sceneLocationViewDidSetupSceneNode(sceneLocationView: SceneLocationView, sceneNode: SCNNode) {
        
    }
    
    func sceneLocationViewDidUpdateLocationAndScaleOfLocationNode(sceneLocationView: SceneLocationView, locationNode: LocationNode) {
        
    }
    
//    let sceneLocationView = SceneLocationView()
//    var userAnnotation: MKPointAnnotation?
//    var locationEstimateAnnotation: MKPointAnnotation?
//
//    var updateUserLocationTimer: Timer?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        sceneLocationView.showAxesNode = true
//        sceneLocationView.locationDelegate = self
//
//        // Set arbritary location
//        let pinCoordinate = CLLocationCoordinate2D(latitude: 51.504607, longitude: -0.019592)
//        let pinLocation = CLLocation(coordinate: pinCoordinate, altitude: 236)
//        let pinImage = UIImage(named: "pin")!
//        let pinLocationNode = LocationAnnotationNode(location: pinLocation, image: pinImage)
//        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: pinLocationNode)
//
//        view.addSubview(sceneLocationView)
//
//        updateUserLocationTimer = Timer.scheduledTimer(
//            timeInterval: 0.5,
//            target: self,
//            selector: #selector(ARViewController.updateUserLocation),
//            userInfo: nil,
//            repeats: true)
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        sceneLocationView.run()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        sceneLocationView.pause()
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        sceneLocationView.frame = CGRect(
//            x: 0,
//            y: 0,
//            width: self.view.frame.size.width,
//            height: self.view.frame.size.height)
//
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Release any cached data, images, etc that aren't in use.
//    }
//
//    @objc func updateUserLocation() {
////        DispatchQueue.main.async {
////
////            if let bestEstimate = self.sceneLocationView.bestLocationEstimate(),
////                let position = self.sceneLocationView.currentScenePosition() {
////
////                let translation = bestEstimate.translatedLocation(to: position)
////            }
////
////            if self.userAnnotation == nil {
////                self.userAnnotation = MKPointAnnotation()
////                self.mapView.addAnnotation(self.userAnnotation!)
////            }
////
////            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
////                self.userAnnotation?.coordinate = currentLocation.coordinate
////            }, completion: nil)
//
////            if self.centerMapOnUserLocation {
////                UIView.animate(withDuration: 0.45, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
////                    self.mapView.setCenter(self.userAnnotation!.coordinate, animated: false)
////                }, completion: {
////                    _ in
////                    self.mapView.region.span = MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
////                })
////            }
//
////            if self.displayDebugging {
////                let bestLocationEstimate = self.sceneLocationView.bestLocationEstimate()
////
////                if bestLocationEstimate != nil {
////                    if self.locationEstimateAnnotation == nil {
////                        self.locationEstimateAnnotation = MKPointAnnotation()
////                        self.mapView.addAnnotation(self.locationEstimateAnnotation!)
////                    }
////
////                    self.locationEstimateAnnotation!.coordinate = bestLocationEstimate!.location.coordinate
////                } else {
////                    if self.locationEstimateAnnotation != nil {
////                        self.mapView.removeAnnotation(self.locationEstimateAnnotation!)
////                        self.locationEstimateAnnotation = nil
////                    }
////                }
////            }
////        }
//    }
//}
//
//extension ARViewController: SceneLocationViewDelegate {
//    func sceneLocationViewDidAddSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
//        print("add scene location estimate, position: \(position), location: \(location.coordinate), accuracy: \(location.horizontalAccuracy), date: \(location.timestamp)")
//    }
//
//    func sceneLocationViewDidRemoveSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
//        print("remove scene location estimate, position: \(position), location: \(location.coordinate), accuracy: \(location.horizontalAccuracy), date: \(location.timestamp)")
//    }
//
//    func sceneLocationViewDidConfirmLocationOfNode(sceneLocationView: SceneLocationView, node: LocationNode) {
//    }
//
//    func sceneLocationViewDidSetupSceneNode(sceneLocationView: SceneLocationView, sceneNode: SCNNode) {
//    }
//
//    func sceneLocationViewDidUpdateLocationAndScaleOfLocationNode(sceneLocationView: SceneLocationView, locationNode: LocationNode) {
//    }
}
