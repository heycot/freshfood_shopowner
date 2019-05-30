//
//  ChangePasswordController.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/12/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class ChangePasswordController: UIViewController {

    @IBOutlet weak var doneBtn: UIBarButtonItem!
    @IBOutlet weak var notiTitle: UILabel!
    @IBOutlet weak var notiDetail: UILabel!
    
    @IBOutlet weak var currentPass: UITextField!
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var confPass: UITextField!
    
    
    var password = ""
    var newPassword = ""
    
    var isCurrentCorrect =  false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        super.viewDidLoad()
        notiTitle.isHidden = true
        notiDetail.isHidden = true
        currentPass.delegate = self
        newPass.delegate = self
        confPass.delegate = self
    }
    

    @IBAction func doneBtnPressed(_ sender: Any) {
        if validInput() && isCurrentCorrect {
//            AuthServices.instance.changePassword(pass: self.newPassword) { (data) in
//                guard let data = data else { return }
//
//                if data == 1 {
//                    self.notiTitle.text = "Change password successfully!"
//                    self.notiDetail.isHidden = true
//                    self.notiTitle.isHidden = false
//                    self.clearInput()
//                } else {
//                    self.notiTitle.text = "Something went wrong. Please try again."
//                    self.notiTitle.isHidden = false
//                    self.notiDetail.isHidden = true
//                }
//            }
        }
    }
    
    func clearInput() {
        currentPass.text = ""
        newPass.text = ""
        confPass.text = ""
    }
    
    func disableInputText() {
        newPass.isUserInteractionEnabled = false
        confPass.isUserInteractionEnabled = false
    }
    
    func enableInputText() {
        newPass.isUserInteractionEnabled = true
        confPass.isUserInteractionEnabled = true
    }
    
    
    func validInput() -> Bool {
        
        if !checkValidNewPass() || !checkValidConfirmPass() {
            return false
        }
        return true
    }
    
    func checkValidNewPass() -> Bool {
        guard let pass = newPass.text, newPass.text!.isValidPassword() else {
            notiTitle.text = NSLocalizedString(Notification.password.title.rawValue, comment: "")
            notiDetail.text = NSLocalizedString(Notification.password.detail.rawValue, comment: "")
            notiTitle.isHidden = false
            notiDetail.isHidden = false
            return false
        }
        
        newPassword = pass
        return true
    }
    
    func checkValidConfirmPass() -> Bool {
        guard  let _ = confPass.text, confPass.text!.isValidPassword(), confPass.text! == newPassword else {
            notiTitle.text = NSLocalizedString(Notification.confirmPass.title.rawValue, comment: "")
            notiDetail.text = NSLocalizedString(Notification.confirmPass.detail.rawValue, comment: "")
            notiDetail.isHidden = false
            notiTitle.isHidden = false
            return false
        }
        
        return true
    }
}

extension ChangePasswordController : UITextFieldDelegate {
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case currentPass:
//            guard let password = currentPass.text, currentPass.text!.isValidPassword()  else {
//                notiTitle.text = Notification.password.detail.rawValue
//                disableInputText()
//                self.isCurrentCorrect = false
//                return
//            }
            
//            AuthServices.instance.checkPassword(pass: password) { (data) in
//                guard let data = data else { return }
//
//                if data == 0 {
//                    self.isCurrentCorrect = false
//                    self.titleNotification.text = "Your current password is not correct."
//                    self.titleNotification.isHidden = false
//                    self.notification.isHidden = true
//
//                } else {
//                    self.isCurrentCorrect = true
//                    self.titleNotification.isHidden = true
//                    self.notification.isHidden = true
//                }
//
//            }
            break
        case newPass:
            if !checkValidNewPass() {
                //
            }
            break
        default:
            if !checkValidConfirmPass() {
                //
            }
        }
    }
}
