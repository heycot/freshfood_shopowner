//
//  AddNewShopController.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/8/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import GoogleMaps

class AddNewShopController: UIViewController {
    
    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var timeOpen: UITextField!
    @IBOutlet weak var timeClose: UITextField!
    @IBOutlet weak var addresstxt: UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    
    
    var locationManager = CLLocationManager()
    var zoomLevel: Float = 15.0
    var didUpdateLocation: Bool = false
    
    var currentLocation: CLLocation?
    var marker: GMSMarker?
    
    var originCoordinate: CLLocationCoordinate2D!
    var originAddress: String!
    
    var newShop = ShopResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configsMapp()
    }
    
    func configsMapp() {
        addMap()
        
        configLocationManager()
    }
    
    func addMap() {
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
    }
    
    func showMarker(location: CLLocation) {
        let currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        // clear before show new one
        marker?.map = nil
        
        marker = GMSMarker(position: currentLocation)
        marker?.map = mapView
    }

    func configCamera(location: CLLocation, zoomLevel: Float) {
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)
        mapView.camera = camera
        
    }

    func configLocationManager() {
        // User Location
        locationManager.delegate = self
        
        // Start Location
        accessLocationServices()
    }
    
    func startUpdateLocation() {
        didUpdateLocation = false
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdateLocation() {
        didUpdateLocation = true
        locationManager.stopUpdatingLocation()
    }
}


extension AddNewShopController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("didTapInfoWindowOf")
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("didLongPressInfoWindowOf")
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture {
//            showShopInfo(false)
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("idleAt position \(position)")
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("tap")
        self.newShop.latitude = coordinate.latitude
        self.newShop.longitude = coordinate.longitude
        
        self.currentLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        guard let location = self.currentLocation else { return }
        configCamera(location: location, zoomLevel: zoomLevel)
        
        showMarker(location: location)
    }
    
}

extension AddNewShopController: CLLocationManagerDelegate {
    
    func handleDidUpdateLocation(location: CLLocation) {
        guard !didUpdateLocation else {
            stopUpdateLocation()
            return
        }
        
        stopUpdateLocation()
        self.currentLocation = location
        
        configCamera(location: location, zoomLevel: zoomLevel)
    }
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        handleDidUpdateLocation(location: location)
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
}

extension AddNewShopController: LocationServicesProtocol {
    func authorizedLocationServices() {
        startUpdateLocation()
    }
}

extension String {
    static func locationCoordinate(lat: Double?, lng: Double?) -> String {
        guard let latitude = lat, let longitude = lng else { return "" }
        
        return String("\(latitude), \(longitude)")
    }
}

