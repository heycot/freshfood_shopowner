//
//  OneFoodController.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/13/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class OneFoodController: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var unit: UITextField!
    @IBOutlet weak var notification: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var item = ShopItemResponse()
    var comments = [CommentResponse]()
    var shop = ShopResponse()
    var itemList = [ItemResponse]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell() 
        setupView()
        updateView()
    }
    
    func setupView() {
        price.keyboardType = .numberPad
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        
        if name.text == "" || price.text == "" || unit.text == "" {
            
            notification.text = "All the information are required"
        } else {
            
            item.name = name.text
            item.price = Double(price.text ?? "0.0")
            item.unit = unit.text
            item.keywords = String.gennerateKeywords([item.name ?? "", shop.address ?? "", shop.name ?? ""])
            
            ShopItemService.instance.editOne(item: item) { (data) in
                guard let data = data else { return }
                
                if data {
                    self.notification.text = "Edit success"
                    self.notification.textColor = APP_COLOR
                } else {
                    
                    self.notification.text = "Something went wrong. Please try again"
                }
            }
        }
    }
    
    func registerCell() {
        tableView.register(UINib(nibName: CellIdentifier.userComment.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.userComment.rawValue)
    }
    
    func updateView() {
//        let priceFormat = (item.price?.formatPrice())!
//        let priceStr = "VND " + String(priceFormat).replace(target: "$", withString: "")    + "/\(item.unit!)"
        
        name.text = item.name
        price.text = String(format: "%0.2f", item.price ?? 0.0)
        unit.text = item.unit
        
    }
    
    func getAllComment() {
        CommentServices.instance.getAllCommentByFood(foodID: item.id!) { (data) in
            guard let data = data else { return }
            
            self.comments = data
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func photosPressed(_ sender: Any) {
    }
    
    
    
}

extension OneFoodController : UITableViewDelegate {
    
}


extension OneFoodController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.userComment.rawValue, for: indexPath) as! UserCommentCell
        cell.updateView(cmt: comments[indexPath.row], user: nil, item: nil)
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAllComment()
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
}
