//
//  ListCommentController.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/16/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class ListCommentController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notification: UILabel!
    
    var shopList = [ShopResponse]()
    var cmtList = [CommentResponse]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerView()
        setupView()
        getComment()
    }
    
    func registerView() {
        tableView.register(UINib(nibName: CellIdentifier.comment.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.comment.rawValue)
        tableView.register(UINib(nibName: CellIdentifier.noComment.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.noComment.rawValue)
    }
    
    func setupView() {
        notification.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 30
        tableView.tableFooterView = UIView()
    }
    
    func getComment() {
        ShopService.instance.getListShop { (data) in
            guard let data = data else { return }
            self.shopList = data
            
            for i in 0 ..< self.shopList.count {
                CommentServices.instance.getCommentByShopId(shopID: self.shopList[i].id ?? "", completion: { (data) in
                    guard let data = data else { return}
                    
                    for cmt in data {
                        self.cmtList.append(cmt)
                    }
                    
                    if self.cmtList.count == 0 {
                        self.notification.text = NSLocalizedString("No data to show", comment: "")
                        self.notification.isHidden = false
                    }
                    
                    self.showData()
                })
            }
            
        }
    }
    
    func showData() {
        cmtList.sort(by: {$0.update_date! > $1.update_date! })
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is OneCommentController {
            let vc = segue.destination as? OneCommentController
            let index = sender as! Int
            vc?.lastComment = cmtList[index]
            vc?.isView = true
        }
    }
    
}

extension ListCommentController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: SegueIdentifier.listCommentToOne.rawValue, sender: indexPath.row)
    }
}

extension ListCommentController : UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cmtList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.comment.rawValue, for: indexPath) as! CommentCell
        cell.updateView(cmt: cmtList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
       
        let share = UITableViewRowAction(style: .normal, title: NSLocalizedString("Report", comment: "")) { (action, indexPath) in
            // share item at indexPath
            let alert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("Are you sure to report this comment to admin", comment: ""), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
                CommentServices.instance.changeStatus(cmtID: self.cmtList[indexPath.row].id ?? "", status: 2, completion: { (data) in
                    self.cmtList[indexPath.row].status = 2
                    self.tableView.reloadData()
                })
                
            }))
            
            self.present(alert, animated: true)
        }
        
        share.backgroundColor = .red
        
        return [share]
    }
    
}

