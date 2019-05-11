//
//  LoginController.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/8/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AuthServices.instance.isLoggedIn {
            performSegue(withIdentifier: SegueIdentifier.loginToView.rawValue, sender: nil)
        }
        
        setUpUI()
    }
    
    func setUpUI() {
        emailTxt.setBottomBorder(color: APP_COLOR)
        passwordTxt.setBottomBorder(color: APP_COLOR)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ListShopController {
            
        }
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if !(emailTxt.text?.isValidEmail())! {
            let alert = UIAlertController(title: Notification.email.title.rawValue, message: Notification.email.detail.rawValue, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(alert, animated: true)
    
        } else if !(passwordTxt.text?.isValidPassword())! {
            let alert = UIAlertController(title: Notification.password.title.rawValue, message: Notification.password.detail.rawValue, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            
        } else {
            
            AuthServices.instance.signin(email: emailTxt.text!, password: passwordTxt.text!) { (data) in
                guard let data = data else { return }
                
                if !data {
                    let alert = UIAlertController(title: "Can not log in!", message: "Your email and password do not match any account.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    self.performSegue(withIdentifier: SegueIdentifier.loginToView.rawValue, sender: nil)
                }
            }
        }
    }
}
