//
//  AddFoodController.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/12/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import Photos

class AddFoodController: UIViewController {

    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notificationHeight: NSLayoutConstraint!
    
    var arrayCount = 1
    var items = [ShopItemResponse]()
    
    var fileName = ""
    var images = [UIImage]()
    var imageName = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell() 
        setupView()
    }
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView =  UIView()
    }
    
    func registerCell() {
        tableView.register(UINib(nibName: CellIdentifier.newFood.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.newFood.rawValue)
    }
    
    @IBAction func newFoodPressed(_ sender: Any) {
        arrayCount += 1
        tableView.reloadData()
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        
    }
    
    
}


extension AddFoodController : UITableViewDelegate {
    
}

extension AddFoodController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.newFood.rawValue, for: indexPath) as! NewFoodCell
        
        
        cell.addImageBtn.addTarget(self, action: #selector(addImagePressed), for: UIControl.Event.touchDown)
        
        return cell
    }
    
    
}


// extension for add image
extension AddFoodController {
    @objc func addImagePressed(textField: UITextField) {
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType =  UIImagePickerController.SourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    
    
    @objc func dismisHandle() {
         dismiss(animated: true, completion: nil)
    }
    
}

extension AddFoodController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        
        if let url = info[UIImagePickerController.InfoKey.phAsset] as? URL {
            let assets = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil)
            // get for mat of image
            let imageFormat = String.getImageFormatFromUrl(url: url)
            
            if let firstAsset = assets.firstObject,
                let firstResource = PHAssetResource.assetResources(for: firstAsset).first {
                fileName = firstResource.originalFilename
            } else {
                fileName = String.generateNameForImage() + "." + imageFormat
            }
        } else {
            fileName = String.generateNameForImage() + ".jpg"
        }
        
        if (fileName != "") {
            self.images.append(selectedImage)
            self.imageName.append(fileName)
        }
        self.dismisHandle()
    }
}

