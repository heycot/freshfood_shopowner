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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notificationHeight: NSLayoutConstraint!
    
    var arrayCount = 1
    var items = [ShopItemResponse]()
    
    var fileName = ""
    var imgArr = [[UIImage]]()
    var imageName = [[String]]()
    
    var collectionView : UICollectionView?
    var collectionHeight: NSLayoutConstraint!
    var foodCells = [UITableViewCell]()
    var foodTFs = [[UITextField]]()
    
    
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
        
        foodCells.forEach { cell in
        }
        
        for i in 0 ..< arrayCount {
            print(foodTFs[i][1].text)
        }
    }
    
    func displayImage() {
        self.collectionView?.register(UINib(nibName: CellIdentifier.foodImage.rawValue, bundle: nil), forCellWithReuseIdentifier: CellIdentifier.foodImage.rawValue)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionHeight.constant = 100
        collectionView?.reloadData()
    }
    
}

extension AddFoodController : UICollectionViewDelegate {
    
}

extension AddFoodController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr[0].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.foodImage.rawValue, for: indexPath) as! FoodImageCell
        
        cell.image.image = imgArr[0][indexPath.row]
        return cell
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
        self.collectionView = cell.collectionView
        self.collectionHeight = cell.collectionHeight
        self.foodCells.append(cell)
        
        var foodTextField = [UITextField]()
        foodTextField.append(cell.name)
        foodTextField.append(cell.price)
        foodTextField.append(cell.unit)
        
        foodTFs.append(foodTextField)
        
        return cell
    }
    
    
}


// extension for add image
extension AddFoodController {
    @objc func addImagePressed(textField: UITextField) {
        
        
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 10
        let picker = YPImagePicker(configuration: config)
        self.present(picker, animated: true, completion: nil)
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            var images = [UIImage]()
            for item in items {
                switch item {
                case .photo(let photo):
                    images.append(photo.image)
                    print(photo)
                case .video(let video):
                    print(video)
                }
            }
            
            self.imgArr.append(images)
            self.displayImage()
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc func dismisHandle() {
         dismiss(animated: true, completion: nil)
    }
    
}
