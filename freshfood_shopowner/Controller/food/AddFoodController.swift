//
//  AddFoodController.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/12/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import Photos
import YPImagePicker

class AddFoodController: UIViewController {

    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var notificationHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var priceTxt: UITextField!
    @IBOutlet weak var unitTxt: UITextField!
    
    var fileName = ""
    var images = [UIImage]()
    var imageName = [String]()
    
    var itemList = [ItemResponse]()
    var item = ShopItemResponse()
    var shop = ShopResponse()
    var rowSelected = -1
    
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerView()
        setupView()
    }
    
    @IBAction func pcikerBtnPressed(_ sender: Any) {
        if itemList.count > 0 {
            
            picker = UIPickerView.init()
            picker.delegate = self
            picker.backgroundColor = UIColor.white
            picker.setValue(UIColor.black, forKey: "textColor")
            picker.autoresizingMask = .flexibleWidth
            picker.contentMode = .center
            picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
            self.view.addSubview(picker)
            
            toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
            //        toolBar.barStyle = .blackTranslucent
            toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
            self.view.addSubview(toolBar)
        } else {
            let alert = UIAlertController(title: "No data", message: "Do not have any data available", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func onDoneButtonTapped() {
        let row =  picker.selectedRow(inComponent: 0)
        nameTxt.text = itemList[row].name
        unitTxt.text = itemList[row].unit
        rowSelected = row
        
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    func registerView() {
        collectionView.register(UINib(nibName: CellIdentifier.foodImage.rawValue, bundle: nil), forCellWithReuseIdentifier: CellIdentifier.foodImage.rawValue)
    }
    
    func setupView() {
        priceTxt.keyboardType = .numberPad
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    
    @IBAction func addImagePressed(_ sender: Any) {
      
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 10
        let picker = YPImagePicker(configuration: config)
        self.present(picker, animated: true, completion: nil)
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            for item in items {
                switch item {
                case .photo(let photo):
                    self.images.append(photo.image)
                    print(photo)
                case .video(let video):
                    print(video)
                }
            }
            
            self.collectionView.reloadData()
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        if nameTxt.text == "" || priceTxt.text == "" || unitTxt.text == "" {
            notification.text = "All the information is required"
            notificationHeight.constant = 30
        } else {
            self.startSpinnerActivity()
            
            saveDataToItem()
            ShopItemService.instance.addOne(item: item) { (data) in
                guard let data = data else { return }
                
                if data {
                    self.uploadImages()
                    
                    let alert = UIAlertController(title: "Success", message: "Your food is added success ", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true)
                } else {
                    self.notificationHeight.constant = 30
                    self.notification.text = "Something went wrong. Please try again"
                }
            }
        }
    }
    
    func saveDataToItem() {
        
        item.name = nameTxt.text
//        let priceStr = String(format: "%0.2f", priceTxt.text ?? "")
        item.price = Double(priceTxt.text ?? "25000")
        item.unit = unitTxt.text
        
        item.shop_id = shop.id
        item.shop_name = shop.name
        item.item_id = rowSelected >= 0 ? itemList[rowSelected].id : ""
        item.avatar = String.generateNameForImage()
        item.keywords = String.gennerateKeywords([item.name ?? "", shop.address ?? "", shop.name ?? "" ])
    }
    
    
    
    func uploadImages() {
        for i in 0 ..< images.count {
            var fileName = item.avatar ?? ""
            if i != 0 {
                fileName = String.generateNameForImage()
            }
            
            let reference = "\(ReferenceImage.shopItem.rawValue)/\(item.id ?? "")/\(fileName)"
            ImageServices.instance.uploadMedia(image: images[i], reference: reference, completion: { (data) in
                guard data != nil else { return }
                self.stopSpinnerActivity()
            })
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ListFoodsController {
            let vc = segue.destination as? ListFoodsController
            vc?.addNotification = "Add Success"
        }
    }
    
}


extension AddFoodController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemList.count
    }
    
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return itemList[row].name
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        nameTxt.text = itemList[row].name
        unitTxt.text = itemList[row].unit
        rowSelected = row
    }
    
}

extension AddFoodController : UICollectionViewDelegate {
    
}

extension AddFoodController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.foodImage.rawValue, for: indexPath) as! FoodImageCell
        
        cell.image.image = images[indexPath.row]
        return cell
    }
}

