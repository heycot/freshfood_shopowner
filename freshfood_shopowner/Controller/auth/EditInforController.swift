//
//  EditInforController.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/12/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import Photos

class EditInforController: UIViewController {
    
    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var detailNotification: UILabel!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var birthdayTxt: UITextField!
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var avatar : UIImageView!
    
    @IBOutlet weak var notiHeight: NSLayoutConstraint!
    
    var user =  UserResponse()
    var image : UIImage?
    var fileName = "logo"
    
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
    
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        guard let nameStr = nameTxt.text, (nameTxt.text?.isValidUserName())! else {
            notification.text = Notification.username.title.rawValue
            detailNotification.text = Notification.username.detail.rawValue
            notification.isHidden = false
            detailNotification.isHidden = false
            return
        }
        
        let userEdit = User()
//        userEdit.id = user.id
        userEdit.name = nameStr
        userEdit.phone = phoneTxt.text
        //        userEdit.birthday = convertToDate(dateString: birthdayTxt.text!)
        userEdit.address = addressTxt.text
        
//        AuthServices.instance.editInfor(user: userEdit, dateStr: birthdayTxt.text!) { (data) in
//            guard let data = data else { return }
//
//            if data.id != nil {
//                self.notification.text = "Update successful"
//                self.notification.isHidden = false
//                self.user = data
//                self.viewInfor()
//                self.reloadInputViews()
//            } else {
//                self.notification.text = "Something went wrong. Please try again."
//                self.notification.isHidden = false
//            }
//        }
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
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        birthdayTxt.inputAccessoryView = toolbar
        birthdayTxt.inputView = datePicker
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
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
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType =  UIImagePickerController.SourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
    
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

extension EditInforController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
