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
import FirebaseAuth
import YPImagePicker
import PKHUD

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
    var fileName = "logo"
    
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
            
            HUD.show(.progress)
            
            AuthServices.instance.signup(name: nameTxt.text!, email: emailTxt.text!, password: passTxt.text!, avatar: fileName) { (data) in
                guard let data = data else { return }
                
                HUD.hide()
                if data {
                    self.uploadImage()
//                    self.navigationController?.popViewController(animated: true)
                    self.performSegue(withIdentifier: SegueIdentifier.signupToListShop.rawValue, sender: nil)
                }
            }
        }
    }
    
    func backTwoViewController() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    func checkInputData() -> Bool {
        guard let _ = nameTxt.text, nameTxt.text!.isValidUserName() else{
            notification.text = NSLocalizedString(Notification.username.title.rawValue, comment: "")
            detailNotifi.text = NSLocalizedString(Notification.username.detail.rawValue, comment: "")
            return false
        }
        
        guard let _ = emailTxt.text , emailTxt.text!.isValidEmail() else {
            notification.text = NSLocalizedString(Notification.email.title.rawValue, comment: "")
            detailNotifi.text = NSLocalizedString(Notification.email.detail.rawValue, comment: "")
            return false
        }
        
        guard let password = passTxt.text, passTxt.text!.isValidPassword() else {
            notification.text = NSLocalizedString(Notification.password.title.rawValue, comment: "")
            detailNotifi.text = NSLocalizedString(Notification.password.detail.rawValue, comment: "")
            return false
        }
        
        guard  let _ = confirmPassTXT.text, confirmPassTXT.text!.isValidPassword(), confirmPassTXT.text! == password else {
            notification.text = NSLocalizedString(Notification.confirmPass.title.rawValue, comment: "")
            detailNotifi.text = NSLocalizedString(Notification.confirmPass.detail.rawValue, comment: "")
            return false
        }
        
        return true
    }
    
    @IBAction func chooseAvatarpressed(_ sender: Any) {
        
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                
                self.avatarImage.image = photo.image
                self.image = photo.image
                self.avatarImage.setRounded(color: .white)
                self.fileName = String.generateNameForImage()
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
        
    }
    
    func uploadImage() {
        if image == nil {
            image = UIImage(named: "logo")
        }
        
        let reference = "\(ReferenceImage.user.rawValue)\(fileName)"
        ImageServices.instance.uploadMedia(image: image!, reference: reference, completion: { (data) in
            guard data != nil else { return }
        })
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

//extension SignUpController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
//            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
//        }
//
//        var fileName = ""
//
//        if let url = info[UIImagePickerController.InfoKey.phAsset] as? URL {
//            let assets = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil)
//            // get for mat of image
//            let imageFormat = getImageFormatFromUrl(url: url)
//
//            if let firstAsset = assets.firstObject,
//                let firstResource = PHAssetResource.assetResources(for: firstAsset).first {
//                fileName = firstResource.originalFilename
//            } else {
//                fileName = generateNameForImage() + "." + imageFormat
//            }
//        } else {
//            fileName = generateNameForImage() + ".jpg"
//        }
//
//        if (fileName != "") {
//            //            let fileManager = FileManager.default
//            //            let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(fileName)
//            //            print(paths)
//            //            let imageData = selectedImage.jpegData(compressionQuality: 0.75)
//            //            fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
//
////            user?.avatar = fileName
//            self.image = selectedImage
//            self.dismisHandle()
//            self.avatarImage.image = selectedImage
//        }
//        self.dismisHandle()
//    }
//}

