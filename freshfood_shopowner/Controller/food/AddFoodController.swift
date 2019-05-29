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
import PKHUD

class AddFoodController: UIViewController {

    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var notificationHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var oldCollectionView: UICollectionView!
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var priceTxt: UITextField!
    @IBOutlet weak var unitTxt: UITextField!
    @IBOutlet weak var cmtLB: UILabel!
    @IBOutlet weak var photoLB: UILabel!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    
    var images = [UIImage]()
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
        oldCollectionView.register(UINib(nibName: CellIdentifier.foodImage.rawValue, bundle: nil), forCellWithReuseIdentifier: CellIdentifier.foodImage.rawValue)
    }
    
    func setupView() {
        priceTxt.keyboardType = .numberPad
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        oldCollectionView.delegate = self
        oldCollectionView.dataSource = self
    }
    
    
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        if nameTxt.text == "" || priceTxt.text == "" || unitTxt.text == "" {
            notification.text = NSLocalizedString("All the information is required", comment: "")
            notificationHeight.constant = 30
        } else {
            self.doneBtn.isEnabled = false
            HUD.show(.progress)
            
            saveDataToItem()
            if isNew {
                ShopItemService.instance.addOne(item: item) { (data) in
                    guard let data = data else { return }
                    
                    HUD.hide()
                    self.item.id = data
                    self.handleAfterUpdateData(isSuccess: true)
                    SearchServices.instance.addOneByShopItem(shopItem: self.item, completion: { (data) in
                        print("save search")
                    })
                }
            } else {
                ShopItemService.instance.editOne(item: item) { (data) in
                    guard let data = data else { return }
                    
                    HUD.hide()
                    self.handleAfterUpdateData(isSuccess: data)
                    SearchServices.instance.updateWhenEditShopItem(shopItem: self.item, completion: { (data) in
                        print("save search")
                    })
                }
            }
        }
    }
    
    func handleAfterUpdateData(isSuccess: Bool) {
        if isSuccess {
            self.uploadImages()
            
            let alert = UIAlertController(title: NSLocalizedString("Success", comment: ""), message: NSLocalizedString("Your food is saved success ", comment: ""), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: { action in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true)
        } else {
            self.notificationHeight.constant = 30
            self.notification.text = NSLocalizedString("Something went wrong. Please try again", comment: "")
        }
    }
    
    func saveDataToItem() {
        
        if isNew {
            for _ in 0 ..< images.count {
                imageNames.append(String.generateNameForImage())
            }
            
            item.avatar = imageNames[0]
            item.images = imageNames
        } else {
            for _ in 0 ..< images.count {
                let filename = String.generateNameForImage()
                imageNames.append(filename)
                item.images?.append(filename)
            }
        }
        
        
        item.name = nameTxt.text
        item.price = Double(priceTxt.text ?? "25000")
        item.unit = unitTxt.text
        
        item.shop_id = shop.id
        item.shop_name = shop.name
        item.item_id = rowSelected >= 0 ? itemList[rowSelected].id : ""
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ListFoodsController {
            let vc = segue.destination as? ListFoodsController
            vc?.addNotification = NSLocalizedString("Add Success", comment: "")
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
                self.cmtLB.text = NSLocalizedString("Comment: No data", comment: "")
            }
        }
    }
    
}

//extention for images {
extension AddFoodController {
    
    func addImagePressed() {
        
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
            
            self.oldCollectionView.reloadData()
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func uploadImages() {
        
        let reference = "\(ReferenceImage.shopItem.rawValue)/\(item.id ?? "")"
        ImageServices.instance.uploadListMedia(images: images, imageNames: imageNames, reference: reference, completion: { (data) in
            guard data != nil else { return }
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
            toolBar.items = [UIBarButtonItem.init(title: NSLocalizedString("Done", comment: ""), style: .done, target: self, action: #selector(onDoneButtonTapped))]
            self.view.addSubview(toolBar)
        } else {
            let alert = UIAlertController(title: NSLocalizedString("No data", comment: ""), message: NSLocalizedString("Do not have any data available", comment: ""), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
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
        cell.updateView(cmt: comments[indexPath.row], isUser: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let share = UITableViewRowAction(style: .normal, title: "Report") { (action, indexPath) in
            // share item at indexPath
            let alert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("Are you sure to report this comment to admin", comment: ""), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
                CommentServices.instance.changeStatus(cmtID: self.comments[indexPath.row].id ?? "", status: 2, completion: { (data) in
                    let alert = UIAlertController(title: NSLocalizedString("Success", comment: ""), message: NSLocalizedString("Report success", comment: ""), preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                })
                
            }))
            
            self.present(alert, animated: true)
        }
        
        share.backgroundColor = .red
        
        return [share]
    }
    
}

extension AddFoodController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            addImagePressed()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + images.count + (item.images?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.foodImage.rawValue, for: indexPath) as! FoodImageCell
        
        if indexPath.row == 0 {
            cell.image.image = UIImage(named: "add-image")
        } else {
            
            if indexPath.row <= images.count {
                cell.image.image = images[indexPath.row - 1]
            } else {
                let index = indexPath.row - images.count - 1
                
                let folder = ReferenceImage.shopItem.rawValue + item.id! + "/\(item.images?[index] ?? "")"
                cell.updateView(folder: folder)
            }
        }
        
        return cell
    }
}

extension AddFoodController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0 {
            return CGSize(width: 80, height: 100)
        } else {
            return CGSize(width: 120, height: 100)
        }
    }
}

