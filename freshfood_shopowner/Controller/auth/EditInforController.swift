//
//  EditInforController.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/12/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import Photos
import YPImagePicker
import PKHUD

class EditInforController: UIViewController {
    
    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var detailNotification: UILabel!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var birthdayTxt: UITextField!
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var avatar : CustomImageView!
    
    @IBOutlet weak var notiHeight: NSLayoutConstraint!
    
    var user =  UserResponse()
    var image : UIImage?
    var fileName : String?
    
    var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        phoneTxt.keyboardType = UIKeyboardType.numberPad
        viewInfor()
        showDatePicker()
    }
    
    
    func viewInfor() {
        
        notification.isHidden = true
        detailNotification.isHidden = true
        
        viewAvatar()
        emailTxt.text = user.email!
        nameTxt.text = user.name!
        phoneTxt.text = user.phone!
        addressTxt.text = user.address!
        
        if user.birthday != nil {
            let dateStr = NSObject().convertToString(date: user.birthdayDate! , dateformat: DateFormatType.date)
            birthdayTxt.text = dateStr
        } else {
            birthdayTxt.text = ""
        }
    }
    
    func viewAvatar() {
        let folder = ReferenceImage.user.rawValue + "\(user.avatar ?? "")"
        self.avatar.displayImage(folderPath: folder)
    }
    
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        guard let nameStr = nameTxt.text, (nameTxt.text?.isValidUserName())! else {
            notification.text = Notification.username.title.rawValue
            detailNotification.text = Notification.username.detail.rawValue
            notification.isHidden = false
            detailNotification.isHidden = false
            return
        }
        
        let userEdit = UserResponse()
        if fileName != nil {
            userEdit.avatar = fileName
        }
        userEdit.name = nameStr
        userEdit.phone = phoneTxt.text
        userEdit.birthday = convertToDate(dateString: birthdayTxt.text!).timeIntervalSince1970
        userEdit.address = addressTxt.text
        
        HUD.flash(.success, delay: 1.5)
        
        AuthServices.instance.edit(user: userEdit) { (data) in
            guard let data = data else { return }
            
            if data {
                self.notification.text = NSLocalizedString("Update successful", comment: "")
                self.notification.isHidden = false
                if self.fileName != nil {
                    self.uploadAvatar()
                }
            } else {
                self.notification.text = NSLocalizedString("Something went wrong. Please try again", comment: "")
                self.notification.isHidden = false
            }
            
            
        }
    }
    
    func uploadAvatar() {
        let foldler =  ReferenceImage.user.rawValue + fileName! 
        
        ImageServices.instance.uploadMedia(image: image ?? UIImage(named: "logo")!, reference: foldler) { (data) in
            guard data != nil else { return }
            
        }
    }
    
}


// handle datepicker
extension EditInforController {
    func showDatePicker() {
        //Formate Date
        datePicker.datePickerMode = .date
        
        var components = DateComponents()
        components.year = -100
        let minDate = Calendar.current.date(byAdding: components, to: Date())
        
        components.year = -10
        let maxDate = Calendar.current.date(byAdding: components, to: Date())
        
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        birthdayTxt.inputAccessoryView = toolbar
        birthdayTxt.inputView = datePicker
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        birthdayTxt.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}


// extention for ImagePicker
extension EditInforController {
    
    @IBAction func changeAvatarPressed(_ sender: Any) {
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                self.image = photo.image
                self.avatar.image = photo.image
                self.avatar.setRounded(color: .white)
                self.fileName = String.generateNameForImage()
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
}
