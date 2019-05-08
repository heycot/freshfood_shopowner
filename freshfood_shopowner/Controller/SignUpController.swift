//
//  SignUpController.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/8/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import Photos
import Firebase
import FirebaseFirestore


class SignUpController: UIViewController {
    // Outlets
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var confirmPassTXT: UITextField!
    
    @IBOutlet weak var notification : UILabel!
    @IBOutlet weak var detailNotifi : UILabel!
    
    
    // variables
    var image : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        super.viewDidLoad()
        setUpUI()
    }
    

    func setUpUI() {
        avatarImage.setRounded(color: .white)
        nameTxt.setBottomBorder(color: APP_COLOR)
        emailTxt.setBottomBorder(color: APP_COLOR)
        passTxt.setBottomBorder(color: APP_COLOR)
        confirmPassTXT.setBottomBorder(color: APP_COLOR)
        
        passTxt.delegate = self
        confirmPassTXT.delegate = self
        
    }
    
    @IBAction func donePressed(_ sender: Any) {
        if checkInputData() {
            
            notification.text = ""
            detailNotifi.text = ""
            
            
            if image == nil {
                image = UIImage(named: "logo")
            }
            
            Auth.auth().createUser(withEmail: emailTxt.text!, password: passTxt.text!) { authResult, error in
                if (error != nil) {
                    print(error as Any)
                }
                else{
                    
                    let db = Firestore.firestore()
                    db.collection("user_profile").document(authResult!.user.uid).setData([
                        "name": self.nameTxt.text as Any,
                        "email": self.emailTxt.text as Any,
                        "phone": "",
                        "address": "",
                        "avatar": "logo",
                        "birthday": Date(),
                        "create_date": Date()
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                    
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        }
        
    }
    
    func backTwoViewController() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    func checkInputData() -> Bool {
        guard let name = nameTxt.text, nameTxt.text!.isValidUserName() else{
            notification.text = Notification.username.title.rawValue
            detailNotifi.text = Notification.username.detail.rawValue
            return false
        }
        
        guard let email = emailTxt.text , emailTxt.text!.isValidEmail() else {
            notification.text = Notification.email.title.rawValue
            detailNotifi.text = Notification.email.detail.rawValue
            return false
        }
        
        guard let password = passTxt.text, passTxt.text!.isValidPassword() else {
            notification.text = Notification.password.title.rawValue
            detailNotifi.text = Notification.password.detail.rawValue
            return false
        }
        
        guard  let _ = confirmPassTXT.text, confirmPassTXT.text!.isValidPassword(), confirmPassTXT.text! == password else {
            notification.text = Notification.confirmPass.title.rawValue
            detailNotifi.text = Notification.confirmPass.detail.rawValue
            return false
        }
        
        return true
    }
    
    @IBAction func chooseAvatarpressed(_ sender: Any) {
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


    
    
extension SignUpController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("begin edit text")
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("edit text")
        return true
    }
    
}

extension SignUpController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        var fileName = ""
        
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
            //            let fileManager = FileManager.default
            //            let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(fileName)
            //            print(paths)
            //            let imageData = selectedImage.jpegData(compressionQuality: 0.75)
            //            fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
            
//            user?.avatar = fileName
            self.image = selectedImage
            self.dismisHandle()
            self.avatarImage.image = selectedImage
        }
        self.dismisHandle()
    }
}

