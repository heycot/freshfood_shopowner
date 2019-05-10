//
//  AddNewShopController.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/8/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase

class AddNewShopController: UIViewController {
    
    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var timeOpen: UITextField!
    @IBOutlet weak var timeClose: UITextField!
    @IBOutlet weak var addresstxt: UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    
    
    var locationManager = CLLocationManager()
    var zoomLevel: Float = 15.0
    var didUpdateLocation: Bool = false
    
    var currentLocation: CLLocation?
    var marker: GMSMarker?
    
    var originCoordinate: CLLocationCoordinate2D!
    var originAddress: String!
    
    var newShop = ShopResponse()
    var isTapMap = false
    
    
    var openTimePicker = UIDatePicker()
    var closeTimePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notification.isHidden = true
        configsMapp()
        showTimeOpenPicker()
        showTimeClosePicker()
        dateFormatter.dateFormat =  "HH:mm"
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        if checkValidateInput() {
            let userID = Auth.auth().currentUser!.uid
            //Truy cập vào user_profile để lấy user profile với uid
            let db = Firestore.firestore()
            let shop = [
                        "user_id": userID,
                        "name": self.nameTxt.text!,
                        "rating": 0.0,
                        "time_open": self.timeOpen.text!,
                        "time_close": self.timeClose.text!,
                        "create_date": Date().timeIntervalSince1970,
                        "status": 0,
                        "phone": "",
                        "avatar": "",
                        "sell": "",
                        "longitude": self.newShop.longitude as Any,
                        "latitude": self.newShop.latitude as Any,
                        "address": self.addresstxt.text!] as [String : Any]
            
            db.collection("shop").document().setData(shop) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    self.afterAddFinish()
                }
            }
        }
    }
    
    func afterAddFinish() {
        doneBtn.isEnabled = false
        nameTxt.isEnabled = false
        timeClose.isEnabled = false
        timeOpen.isEnabled = false
        addresstxt.isEnabled = false
        notification.text = "Add success, We will contract with you soon."
        notification.isHidden = false
        notification.textColor = .green 
    }
    
    
    func checkValidateInput() -> Bool {
        guard let name = nameTxt.text, nameTxt.text != "" else{
            notification.text = Notification.newShop.rawValue
            notification.isHidden = false
            return false
        }
        
        guard let time_open = timeOpen.text , timeOpen.text != "" else {
            notification.text = Notification.newShop.rawValue
            notification.isHidden = false
            return false
        }
        
        guard let time_close = timeClose.text, timeClose.text != "" else {
            notification.text = Notification.newShop.rawValue
            notification.isHidden = false
            return false
        }
        
        guard  let address = addresstxt.text, addresstxt.text != "" else {
            notification.text = Notification.newShop.rawValue
            notification.isHidden = false
            return false
        }
        
        if !isTapMap {
            notification.text = "Please mark your shop's location on the map."
            notification.isHidden = false
            return false
        }
        
        self.newShop.name = name
        self.newShop.time_open = time_open
        self.newShop.time_close = time_close
        self.newShop.address = address
        return true
    }
    
}

// extension for datepicker
extension AddNewShopController {
    func showTimeOpenPicker() {
        //Formate Date
        openTimePicker.datePickerMode = .time
        openTimePicker.locale = Locale(identifier: "en_GB")
        openTimePicker.minuteInterval = 5;
//        closeTimePicker.date = dateFormatter.date(from: "07:00") ??
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTimeOpenPicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTimeOpenPicker));
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        timeOpen.inputAccessoryView = toolbar
        timeOpen.inputView = openTimePicker
    }
    
    @IBAction func doneTimeOpenPicker(_ sender: Any) {
        dateFormatter.dateFormat = "HH:mm"
        timeOpen.text = dateFormatter.string(from: openTimePicker.date)
        // khongar cách its nhất 1h
        closeTimePicker.minimumDate = openTimePicker.date + 3600
        self.view.endEditing(true)
    }
    
    @IBAction func cancelTimeOpenPicker(_ sender: Any) {
        
        self.view.endEditing(true)
    }
    
    func showTimeClosePicker() {
        //Formate Date
        closeTimePicker.datePickerMode = .time
        closeTimePicker.locale = Locale(identifier: "en_GB")
        closeTimePicker.minuteInterval = 5;
//        closeTimePicker.date = dateFormatter.date(from: "19:00")!
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTimeClosePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTimeClosePicker));
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        timeClose.inputAccessoryView = toolbar
        timeClose.inputView = closeTimePicker
    }
    
    @IBAction func doneTimeClosePicker(_ sender: Any) {
        dateFormatter.dateFormat = "HH:mm"
        timeClose.text = dateFormatter.string(from: closeTimePicker.date)
        // cách nhau ít nhất 1h
        openTimePicker.maximumDate = closeTimePicker.date - 3600
        self.view.endEditing(true)
    }
    
    @IBAction func cancelTimeClosePicker(_ sender: Any) {
        self.view.endEditing(true)
    }
}


// extension for map
extension AddNewShopController {
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
        self.isTapMap = true
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

