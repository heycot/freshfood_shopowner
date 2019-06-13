//
//  ListFoodsController.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/11/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class ListFoodsController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notificationHeight: NSLayoutConstraint!
    @IBOutlet weak var notification: UILabel!
    
    var ShopItemList = [ShopItemResponse]()
    var shop = ShopResponse()
    var itemList = [ItemResponse]()
    var itemListForEdit = [ItemResponse]()
    var newItems = [ItemResponse]()
    var isNew = true
    
    var addNotification: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupView()
        getList(isNew: true)
    }
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        notificationHeight.constant = 0
        
        self.tableView.reloadData()
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = 90
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        isNew = true
        getItemNotAlreadyExists()
        self.performSegue(withIdentifier: SegueIdentifier.listFoodToAdd.rawValue, sender: nil)
        
    }
    
    func getListItem() {
        ItemService.instance.getAllItem { (data) in
            guard let data = data else { return }
            self.itemList = data
            
            if data.count == 0 {
                self.notificationHeight.constant = 30
                self.notification.text = NSLocalizedString("No data to show", comment: "")
            } else {
                self.notificationHeight.constant = 0
                self.notification.text = NSLocalizedString("", comment: "")
            }
        }
    }
    
    func getListItemForEdit(index: Int) {
        ItemService.instance.getAllItemForEdit(category_id: ShopItemList[index].category_id ?? "") { (data) in
            guard let data = data else { return }
            self.itemListForEdit = data
            self.isNew = false
            self.performSegue(withIdentifier: SegueIdentifier.listFoodToAdd.rawValue, sender: index)
        }
    }
    
    func getList(isNew: Bool) {
        ShopItemService.instance.getListShopItem(shopID: shop.id ?? "") { (data) in
            guard let data = data else { return }
            
            if data.count == 0 {
                self.notificationHeight.constant = 30
                self.notification.text = NSLocalizedString("No data to show", comment: "")
            } else {
                
                self.notificationHeight.constant = 0
                self.notification.text = NSLocalizedString("", comment: "")
                
                self.ShopItemList = data
                self.tableView.reloadData()
                
            }
            
            self.getListItem()
        }
    }
    
    
    func getItemNotAlreadyExists() {
        newItems = [ItemResponse]()
        for item in itemList {
            if !checkItemInList(itemID: item.id ?? "") {
                newItems.append(item)
            }
        }
    }
    
    func checkItemInList(itemID: String) -> Bool {
        for item in ShopItemList {
            if item.item_id == itemID {
                return true
            }
        }
        
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AddFoodController {
            let vc = segue.destination as? AddFoodController
            vc?.shop = shop
            
            if !isNew {
                let index = sender as! Int
                vc?.item = ShopItemList[index]
                vc?.isNew = false
                vc?.itemList = itemListForEdit
            } else {
                vc?.itemList = newItems
                vc?.isNew = true
            }
        }
    }
}


extension ListFoodsController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.getListItemForEdit(index: indexPath.row)
    }
    
    
}

extension ListFoodsController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShopItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.food.rawValue, for: indexPath) as! FoodCell
        cell.updateView(item: ShopItemList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if ShopItemList[indexPath.row].status ?? 0 <= 1 {
            return handleChangeStatus(title: NSLocalizedString("Deactivate", comment: ""), message: NSLocalizedString("Are you sure want to deactivate this food?", comment: ""), status: 2, color: .red)
            
        } else {
            return handleChangeStatus(title: NSLocalizedString("Activate", comment: ""), message: NSLocalizedString("Are you sure want to activate this food?", comment: ""), status: 1, color: APP_COLOR)
        }
            
    }
    
    func handleChangeStatus(title: String, message: String, status: Int, color: UIColor) -> [UITableViewRowAction]? {
        let share = UITableViewRowAction(style: .normal, title: title) { (action, indexPath) in
            // share item at indexPath
            let alert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: message, preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
                
                ShopItemService.instance.changeStatus(id: self.ShopItemList[indexPath.row].id ?? "", status: status) { (data) in
                    guard let data = data else { return }
                    
                    if data {
                        self.ShopItemList[indexPath.row].status = status
                        self.tableView.reloadData()
                    } else {
                        let alert = UIAlertController(title: NSLocalizedString("Failed", comment: ""), message: NSLocalizedString("Please try next time", comment: ""), preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            }))
            
            self.present(alert, animated: true)
        }
        
        share.backgroundColor = color
        
        return [share]
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        getList(isNew: false)
        super.viewWillAppear(true)
        tableView.reloadData()
    }
}
