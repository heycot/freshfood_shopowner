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
    @IBOutlet weak var newCollectionView: UICollectionView!
    @IBOutlet weak var newCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var oldCollectionView: UICollectionView!
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var priceTxt: UITextField!
    @IBOutlet weak var unitTxt: UITextField!
    @IBOutlet weak var cmtLB: UILabel!
    @IBOutlet weak var photoLB: UILabel!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    
    var fileName = ""
    var images = [UIImage]()
    var oldImages = [UIImage]()
    var imageNames = [String]()
    
    var itemList = [ItemResponse]()
    var item = ShopItemResponse()
    var shop = ShopResponse()
    var comments = [CommentResponse]()
    var rowSelected = -1
    var isNew = true
    
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerView()
        setupView()
        
        if !isNew {
            showData()
        } else {
            photoLB.isHidden = true
            cmtLB.isHidden = true
        }
    }
    
    func showData() {
        nameTxt.text = item.name
        priceTxt.text = String(format: "%0.2f", item.price ?? 25000.0)
        unitTxt.text = item.unit
        getAllComment()
    }
    
    
    func registerView() {
        tableView.register(UINib(nibName: CellIdentifier.userComment.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.userComment.rawValue)
        newCollectionView.register(UINib(nibName: CellIdentifier.foodImage.rawValue, bundle: nil), forCellWithReuseIdentifier: CellIdentifier.foodImage.rawValue)
        oldCollectionView.register(UINib(nibName: CellIdentifier.foodImage.rawValue, bundle: nil), forCellWithReuseIdentifier: CellIdentifier.foodImage.rawValue)
    }
    
    func setupView() {
        priceTxt.keyboardType = .numberPad
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        newCollectionView.delegate = self
        newCollectionView.dataSource = self
        
        oldCollectionView.delegate = self
        oldCollectionView.dataSource = self
    }
    
    
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        if nameTxt.text == "" || priceTxt.text == "" || unitTxt.text == "" {
            notification.text = "All the information is required"
            notificationHeight.constant = 30
        } else {
            self.doneBtn.isEnabled = false
            self.startSpinnerActivity()
            
            saveDataToItem()
            if isNew {
                ShopItemService.instance.addOne(item: item) { (data) in
                    guard let data = data else { return }
                    self.item.id = data
                    self.handleAfterUpdateData(isSuccess: true)
                }
            } else {
                ShopItemService.instance.editOne(item: item) { (data) in
                    guard let data = data else { return }
                    self.handleAfterUpdateData(isSuccess: data)
                }
            }
        }
    }
    
    func handleAfterUpdateData(isSuccess: Bool) {
        if isSuccess {
            notificationHeight.constant = 30
            self.notification.text = "Your food is saved success. But please wait to upload images."
            self.uploadImages()
        } else {
            self.notificationHeight.constant = 30
            self.notification.text = "Something went wrong. Please try again"
        }
    }
    
    func saveDataToItem() {
        for i in 0 ..< images.count {
            
            var fileName = item.avatar ?? ""
            if i != 0 {
                fileName = String.generateNameForImage()
            }
            
            imageNames.append(fileName)
            
        }
        
        item.name = nameTxt.text
        item.price = Double(priceTxt.text ?? "25000")
        item.unit = unitTxt.text
        item.images = imageNames
        
        item.shop_id = shop.id
        item.shop_name = shop.name
        item.item_id = rowSelected >= 0 ? itemList[rowSelected].id : ""
        item.avatar = String.generateNameForImage()
        item.keywords = String.gennerateKeywords([item.name ?? "", shop.address ?? "", shop.name ?? "" ])
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ListFoodsController {
            let vc = segue.destination as? ListFoodsController
            vc?.addNotification = "Add Success"
        }
    }
    
}

// extention for edit food
extension AddFoodController {
    
    func getAllComment() {
        CommentServices.instance.getAllCommentByFood(foodID: item.id!) { (data) in
            guard let data = data else { return }
            
            if data.count > 0 {
                self.comments = data
                self.tableView.reloadData()
            } else {
                self.cmtLB.text = "Comment: No data"
            }
        }
    }
    
    func getAllPhotos() {
        
    }
}

//extention for images {
extension AddFoodController {
    
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
            
            self.newCollectionHeight.constant = 70
            self.newCollectionView.reloadData()
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func uploadImages() {
        
        let reference = "\(ReferenceImage.shopItem.rawValue)/\(item.id ?? "")"
        ImageServices.instance.uploadListMedia(images: images, imageNames: imageNames, reference: reference, completion: { (data) in
            guard let data = data else { return }
            if data {
                
                let alert = UIAlertController(title: "Success", message: "Your images is saved success ", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true)
            }
            self.stopSpinnerActivity()
        })
    }
}

// extension for name
extension AddFoodController {
    
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

extension AddFoodController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.userComment.rawValue, for: indexPath) as! UserCommentCell
        cell.updateView(cmt: comments[indexPath.row], user: nil, item: nil)
        return cell
    }
    
}

extension AddFoodController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == newCollectionView ? images.count : oldImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.foodImage.rawValue, for: indexPath) as! FoodImageCell
        
        if collectionView == newCollectionView {
            cell.image.image = images[indexPath.row]
        } else {
            cell.image.image = oldImages[indexPath.row]
        }
        
        return cell
    }
}

extension AddFoodController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 70)
    }
}

