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
import Photos

class AddNewShopController: UIViewController {
    
    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var timeOpen: UITextField!
    @IBOutlet weak var timeClose: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var addresstxt: UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    @IBOutlet weak var notificationHeight: NSLayoutConstraint!
    
    @IBOutlet weak var changeAvatarBtn: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var checkFoodsBtn: UIButton!
    
    var locationManager = CLLocationManager()
    var zoomLevel: Float = 15.0
    var didUpdateLocation: Bool = false
    
    var currentLocation: CLLocation?
    var marker: GMSMarker?
    
    var originCoordinate: CLLocationCoordinate2D!
    var originAddress: String!
    
    var isTapMap = false
    
    
    var openTimePicker = UIDatePicker()
    var closeTimePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    
    var isNew = true
    var shop = ShopResponse()
    var image : UIImage?
    var fileName = "logo"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notification.isHidden = true
        configsMapp()
        showTimeOpenPicker()
        showTimeClosePicker()
        dateFormatter.dateFormat =  "HH:mm"
        phoneTxt.keyboardType = .numberPad
        checkFoodsBtn.isEnabled = false
        
        if !isNew {
            checkFoodsBtn.isEnabled = true
            showInforShop()
            showImage()
        }
    }
    
    func showImage() {
        let imageStorageRef = Storage.storage().reference(forURL: shop.avatar!)
        imageStorageRef.downloadURL(completion: { (url, error) in
            do {
                let data = try Data(contentsOf: url!)
                self.avatar.image = UIImage(data: data as Data)
                self.avatar.setRounded(color: .white)
            } catch let error {
                print("Error with load image: \(error)")
            }
        })
    }
    
    
    func showInforShop() {
        nameTxt.text = shop.name
        timeOpen.text = shop.time_open
        timeClose.text = shop.time_close
        addresstxt.text = shop.address
        phoneTxt.text = shop.phone
        let location = CLLocation(latitude: shop.latitude ?? 0.0, longitude: shop.longitude ?? 0.0)
        configCamera(location: location, zoomLevel: zoomLevel)
        
        showMarker(location: location)
        
        if shop.status != 1 {
            disbaleView()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ListFoodsController {
            let vc = segue.destination as? ListFoodsController
            vc?.shopID = shop.id ?? ""
        }
    }
    
    @IBAction func checkFoodBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: SegueIdentifier.shoptoListFood.rawValue, sender: nil)
    }
    
    @IBAction func chooseAvatarpressed(_ sender: Any) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType =  UIImagePickerController.SourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        if checkValidateInput() {
            
            if image == nil {
                image = UIImage(named: fileName)
            }
            
            ImageServices.instance.uploadMedia(image: image!, fileName: fileName, completion: { (data) in
                guard let data = data else { return }
                self.shop.avatar = data
                
                
                if self.isNew {
                    
                    ShopService.instance.addNewShop(shop: self.shop) { (data) in
                        guard let data = data else { return }
                        
                        if data {
                            
                            self.showNotification(mess: "Add success, We will contact you soon", color: APP_COLOR)
                            self.disbaleView()
                            
                        } else {
                            self.showNotification(mess: "Something went wrong. Please try again", color: .red)
                        }
                    }
                } else {
                    ShopService.instance.editShop(shop: self.shop) { (data) in
                        guard let data = data else { return }
                        
                        if data {
                            self.showNotification(mess: "Edit success, We will contact you soon", color: APP_COLOR)
                            self.disbaleView()
                        } else {
                            
                            self.showNotification(mess: "Something went wrong. Please try again", color: .red)
                        }
                    }
                }
            })
            
        }
    }
    
    func disbaleView() {
        
        doneBtn.isEnabled = false
        nameTxt.isEnabled = false
        timeClose.isEnabled = false
        timeOpen.isEnabled = false
        addresstxt.isEnabled = false
        phoneTxt.isEnabled = false
        changeAvatarBtn.isEnabled = false
    }
    
    
    
    func checkValidateInput() -> Bool {
        guard let name = nameTxt.text, nameTxt.text != "" else{
            showNotification(mess: Notification.newShop.rawValue, color: APP_COLOR)
            return false
        }
        
        guard let time_open = timeOpen.text , timeOpen.text != "" else {
            showNotification(mess: Notification.newShop.rawValue, color: APP_COLOR)
            return false
        }
        
        guard let time_close = timeClose.text, timeClose.text != "" else {
            showNotification(mess: Notification.newShop.rawValue, color: APP_COLOR)
            return false
        }
        
        guard  let address = addresstxt.text, addresstxt.text != "" else {
            showNotification(mess: Notification.newShop.rawValue, color: APP_COLOR)
            return false
        }
        
        guard  let phone = phoneTxt.text, phoneTxt.text != "" else {
            showNotification(mess: Notification.newShop.rawValue, color: APP_COLOR)
            return false
        }
        
        if !isTapMap && isNew {
            showNotification(mess: "Please mark your shop's location on the map.", color: APP_COLOR)
            return false
        }
        
        self.shop.avatar = "logo.jpg"
        self.shop.name = name
        self.shop.time_open = time_open
        self.shop.time_close = time_close
        self.shop.address = address
        self.shop.phone = phone
        return true
    }
    
    func showNotification(mess: String, color: UIColor) {
        notification.text = mess
        notification.textColor = color
        self.notificationHeight.constant = 30
        notification.isHidden = false
    }
    
}

extension AddNewShopController {
    func generateNameForImage() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "AVATAR_hh.mm.ss.dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    @objc func dismisHandle() {
        dismiss(animated: true, completion: nil)
    }
    
    func getImageFormatFromUrl(url : URL) -> String {
        
        if url.absoluteString.hasSuffix("JPG") {
            return"JPG"
        }
        else if url.absoluteString.hasSuffix("PNG") {
            return "PNG"
        }
        else if url.absoluteString.hasSuffix("GIF") {
            return "GIF"
        }
        else {
            return "jpg"
        }
    }
}

extension AddNewShopController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        
        if let url = info[UIImagePickerController.InfoKey.phAsset] as? URL {
            let assets = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil)
            // get for mat of image
            let imageFormat = getImageFormatFromUrl(url: url)
            
            if let firstAsset = assets.firstObject,
                let firstResource = PHAssetResource.assetResources(for: firstAsset).first {
                fileName = firstResource.originalFilename
            } else {
                fileName = generateNameForImage() + "." + imageFormat
            }
        } else {
            fileName = generateNameForImage() + ".jpg"
        }
        
        if (fileName != "") {
            self.image = selectedImage
            self.avatar.image = selectedImage
            self.avatar.setRounded(color: .white)
        }
        self.dismisHandle()
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
        self.shop.latitude = coordinate.latitude
        self.shop.longitude = coordinate.longitude
        
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

