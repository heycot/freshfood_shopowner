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
import PKHUD

class ListShopController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notification: UILabel!
    
    var listItem = [ShopResponse]()
    // location manager
    var locationManager = CLLocationManager()
    var didUpdateLocation: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
        ShopItemService.instance.getlist()
        
//        self.title = NSLocalizedString("Shops", comment: "")
//        self.navigationController?.navigationBar.barTintColor = APP_COLOR
//        setupCurrentLocation()
//        setupView()
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
    
    
    @IBAction func addBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: SegueIdentifier.listShopToNew.rawValue, sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AddNewShopController {
            if sender == nil {
                
            } else {
                let index = sender as! Int
                let vc = segue.destination as? AddNewShopController
                vc?.isNew = false
                vc?.shop = listItem[index]
            }
        } else if segue.destination is ListFoodsController {
            
            let index = sender as! Int
            let vc = segue.destination as? ListFoodsController
            vc?.shop = listItem[index]
        }
    }
    
    func getAllShop() {
        HUD.show(.progress)
        ShopService.instance.getListShop() { (data) in
            guard let data = data else { return }
            
            HUD.hide()
            
            if data.count == 0 {
                self.notification.text = NSLocalizedString("No data to show", comment: "")
                self.notification.isHidden = false
                
            } else {
                self.listItem = data
                self.tableView.reloadData()
            }
        }
    }
}

// extention for uitableview
extension ListShopController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: SegueIdentifier.listShopToFood.rawValue, sender: indexPath.row)
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if listItem[indexPath.row].status ?? 0 <= 1 {
            return handleChangeStatus(title: NSLocalizedString("Deactivate", comment: ""), message: NSLocalizedString("Are you sure want to deactivate this shop?", comment: ""), status: 2, color: .red)
            
        } else {
            return handleChangeStatus(title: NSLocalizedString("Activate", comment: ""), message: NSLocalizedString("Are you sure want to enable this shop?", comment: ""), status: 1, color: APP_COLOR)
        }
        
        
    }
    
    func handleChangeStatus(title: String, message: String, status: Int, color: UIColor) -> [UITableViewRowAction]? {
        let share = UITableViewRowAction(style: .normal, title: title) { (action, indexPath) in
            // share item at indexPath
            let alert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: message, preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
                
                ShopService.instance.changeStatus(id: self.listItem[indexPath.row].id ?? "", status: status) { (data) in
                    guard let data = data else { return }
                    
                    if data {
                        self.listItem[indexPath.row].status = status
                        self.tableView.reloadData()
                        ShopItemService.instance.changeStatusByShop(shopId: self.listItem[indexPath.row].id ?? "", status: status)
                    } else {
                        let alert = UIAlertController(title: NSLocalizedString("Failed", comment: ""), message: NSLocalizedString("Please try next time", comment: ""), preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            }))
            
            self.present(alert, animated: true)
        }
        
        let edit = UITableViewRowAction(style: .normal, title: NSLocalizedString("Edit", comment: "")) { (action, indexPath) in
            
            self.performSegue(withIdentifier: SegueIdentifier.listShopToNew.rawValue, sender: indexPath.row)
        }
        
        edit.backgroundColor = .blue
        share.backgroundColor = color
        
        return [edit, share]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        getAllShop()
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
