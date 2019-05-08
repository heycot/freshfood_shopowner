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
        setUpUI()
    }
    
    
    func setUpUI() {
        emailTxt.setBottomBorder(color: APP_COLOR)
        passwordTxt.setBottomBorder(color: APP_COLOR)
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if !(emailTxt.text?.isValidEmail())! {
            let alert = UIAlertController(title: Notification.email.title.rawValue, message: Notification.email.detail.rawValue, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            
            //        } else if !(passwordTF.text?.isValidPassword())! {
            //            let alert = UIAlertController(title: Notification.password.title.rawValue, message: Notification.password.detail.rawValue, preferredStyle: .alert)
            //            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
            //            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            //            self.present(alert, animated: true)
            
            
        } else {
            
            Auth.auth().signIn(withEmail: emailTxt.text!, password: passwordTxt.text!) { [weak self] user, error in
                guard let strongSelf = self else { return }
                
                if error != nil {
                    let alert = UIAlertController(title: "Can not log in!", message: "Your email and password do not match any account.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                    self!.present(alert, animated: true)
                } else {
                    
                    //set up is logined
                    AuthServices.instance.isLoggedIn = true
                    AuthServices.instance.authToken = ""
                    AuthServices.instance.userEmail = ""
                }
            }
            
        }
        
    }
    
    
}
