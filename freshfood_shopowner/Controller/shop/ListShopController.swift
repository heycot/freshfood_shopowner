//
//  ViewController.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/8/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import FirebaseCore

class ListShopController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var listItem = [ShopResponse]()
    // location manager
    var locationManager = CLLocationManager()
    var didUpdateLocation: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCurrentLocation()
        setupView()
    }
    
    func setupView() {
        navigationController?.navigationBar.barTintColor = APP_COLOR
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        self.tableView.reloadData()
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = 90
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AddNewShopController {
            
        }
    }
    
    func getAllShop() {
        let userID = Auth.auth().currentUser!.uid
        
        let db = Firestore.firestore()
        let docRef = db.collection("shop").document(userID)
        
        docRef.getDocument(completion: { (document, error) in
            if let document = document, document.exists {
//                _ = document.data().map(String.init(describing:)) ?? "nil"
                
                let jsonData = try? JSONSerialization.data(withJSONObject: document.data() as Any)
                do {
                    self.listItem = try JSONDecoder().decode([ShopResponse].self, from: jsonData!)
                   
                } catch let jsonError {
                    print("Error serializing json:", jsonError)
                }
                
            } else {
                print("User have no profile")
            }
        })
    }
}

// extention for uitableview
extension ListShopController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        getShopInfor(id: listItem[indexPath.row].id!)
    }
}

extension ListShopController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.shop.rawValue, for: indexPath) as! ShopCell
        
        
        cell.updateView(shop: listItem[indexPath.row])
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    
}

// extention for location
extension ListShopController {
    func setupCurrentLocation() {
        
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

extension ListShopController: CLLocationManagerDelegate {
    
    func handleDidUpdateLocation(location: CLLocation) {
        guard !didUpdateLocation else {
            stopUpdateLocation()
            return
        }
        
        stopUpdateLocation()
        AuthServices.instance.currentLocation = location
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

extension ListShopController : LocationServicesProtocol {
    func authorizedLocationServices() {
        startUpdateLocation()
    }
}
