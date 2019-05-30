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
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxt.text = "callie@enclave.vn"
        passwordTxt.text = "Q!123456"
        
        checkIfUserIsSignedIn()
    }
    
    private func checkIfUserIsSignedIn() {
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                // user is signed in
                // go to feature controller
                self.performSegue(withIdentifier: SegueIdentifier.loginToView.rawValue, sender: nil)
            } else {
                // user is not signed in
                // go to login controller
                self.setUpUI()
            }
        }
    }
    
    
    func setUpUI() {
        emailTxt.setBottomBorder(color: APP_COLOR)
        passwordTxt.setBottomBorder(color: APP_COLOR)
        loginBtn.setBorderRadious(radious: 10)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ListShopController {
            
        }
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if !(emailTxt.text?.isValidEmail())! {
            let alert = UIAlertController(title: NSLocalizedString(Notification.email.title.rawValue, comment: ""),
                                          message: NSLocalizedString(Notification.email.detail.rawValue, comment: "") ,
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil))
            self.present(alert, animated: true)
    
        } else if !(passwordTxt.text?.isValidPassword())! {
            let alert = UIAlertController(title: NSLocalizedString(Notification.password.title.rawValue, comment: ""),
                                          message: NSLocalizedString(Notification.password.detail.rawValue, comment: ""),
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil))
            self.present(alert, animated: true)
            
        } else {
            
            AuthServices.instance.signin(email: emailTxt.text!, password: passwordTxt.text!) { (data) in
                guard let data = data else { return }
                
                if !data {
                    let alert = UIAlertController(title: NSLocalizedString("Can not log in!", comment: ""), message: NSLocalizedString("Your email and password do not match any account", comment: ""), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    self.performSegue(withIdentifier: SegueIdentifier.loginToView.rawValue, sender: nil)
                }
            }
        }
    }
}
