//
//  LocationServicesProtocol.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/17/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol LocationServicesProtocol {
    var locationManager: CLLocationManager { get set }
    func authorizedLocationServices()
}

extension LocationServicesProtocol where Self: UIViewController {
    func accessLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .denied:
                alertPromptToAllowLocationAccessViaSettings()
            case .notDetermined, .restricted:
                permissionLocationServicesAccess()
            case .authorizedAlways, .authorizedWhenInUse:
                authorizedLocationServices()
            }
        } else {
            alertPromptToAllowLocationAccessViaSettings()
        }
    }
    
    func alertPromptToAllowLocationAccessViaSettings() {
        alertPromptToAccessPrivacy(title: "We would like to access your location", message: "Please grant permission to access your location.")
    }
    
    func permissionLocationServicesAccess() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        authorizedLocationServices()
    }
}

extension UIViewController {
    func alertPromptToAccessPrivacy(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert )
        let openSetting = UIAlertAction(title: "Open Settings", style: .default) { alert in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
        alert.addAction(openSetting)
        let declineAction = UIAlertAction(title: "Not Now", style: .cancel) { (alert) in
        }
        alert.addAction(declineAction)
        present(alert, animated: true, completion: nil)
    }
}

