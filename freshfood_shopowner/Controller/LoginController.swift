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
            Auth.auth().signIn(withEmail: emailTxt.text!, password: passwordTxt.text!) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
                
                if error != nil {
                    let alert = UIAlertController(title: "Can not log in!", message: "Your email and password do not match any account.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                    strongSelf.present(alert, animated: true)
                } else {
                    if let user = authResult?.user {
                        let uid = user.uid
                
                        //Truy cập vào user_profile để lấy user profile với uid
                        let db = Firestore.firestore()
                        let docRef = db.collection("user_profile").document(uid)
                        
                        docRef.getDocument(completion: { (document, error) in
                            if let document = document, document.exists {
                                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"

                                print("Document data: \(dataDescription)")
                                print(document.data())
                                //Đoạn này em maping cái profile thành User object của em nha, hoặc lưu vào
                                //em thử map Data vào như em làm bên app kia coi có đc ko:
                                let jsonData = try? JSONSerialization.data(withJSONObject: document.data() as Any)
                                do {
                                    _ = try JSONDecoder().decode(UserResponse.self, from: jsonData!)
                                    print(String(AuthServices.instance.isLoggedIn) + " " + AuthServices.instance.userEmail)
                                } catch let jsonError {
                                    print("Error serializing json:", jsonError)
                                }
                                
                                 self?.performSegue(withIdentifier: SegueIdentifier.loginToView.rawValue, sender: nil)
                            } else {
                                print("User have no profile")
                            }
                        })
                    }
                }
            }
        }
    }
}
