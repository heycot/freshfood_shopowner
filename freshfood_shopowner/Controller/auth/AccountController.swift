//
//  AccountController.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/12/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import Firebase

class AccountController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var userAvatar: CustomImageView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var inforUser: UITextField!
    @IBOutlet weak var activitiesBtn: UIButton!
    @IBOutlet weak var accountBtn: UIButton!
    @IBOutlet weak var notification: UILabel!
    
    var titleCell = ["Email:", "Birthday:", "Address:", "Join on:", "Edit information", "Change password", ""]
    var detailCell = [String]()
    
    var user : UserResponse?
    var listComment = [CommentResponse]()
    var isActivity = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        disableUIView()
        
        
        setUpForTableView()
        notification.isHidden = true
    }
    
    func registerCells() {
        
        tableView.register(UINib(nibName: CellIdentifier.userComment.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.userComment.rawValue)
    }
    
    func handleAfterLogOut() {
        userAvatar.image = UIImage(named: "logo")
        userAvatar.setBottomBorder(color: .white)
        username.text = "Guest"
        inforUser.text = "You are using this application as a guest"
        notification.text = "No data to show"
        notification.isHidden = false
        
        detailCell = [String]()
        
        for _ in 0 ..< 7 {
            detailCell.append("")
        }
        
        titleCell[titleCell.count - 1] = "Log in "
        listComment.removeAll()
        
        tableView.reloadData()
    }
    
    func getUser() {
        
        AuthServices.instance.checkLogedIn { (data) in
            guard let data = data else { return }
            
            if data {
                let userID = Auth.auth().currentUser?.uid
                AuthServices.instance.getProfile(userID: userID ?? "", completion: { (data) in
                    guard let data = data else { return }
                    self.user = data
                    self.getDataFromAPI(offset: 0, isLoadMore: false)
                    self.setupDetailInfor()
                })
            } else {
                self.handleAfterLogOut()
                self.notification.text = "No data to show"
                self.notification.isHidden = false
            }
        }
    }
    
    
    func viewInfor() {
        userAvatar.displayImage(folderPath: ReferenceImage.user.rawValue + "\(user?.avatar ?? "")")
        userAvatar.setRounded(color: .white)
        username.text = user?.name ?? ""
        inforUser.text = "newbee - Top 1000 - 10 Followers"
        
        inforUser.setboldSystemFontOfSize(size: 14)
        username.setboldSystemFontOfSize(size: 18)
    }
    
    func setupDetailInfor() {
        
        titleCell[titleCell.count - 1] = "Log out "
        detailCell.removeAll()
        
        detailCell.append(user?.email ?? "")
        
        if (user?.birthday != nil) {
            let dateStr = NSObject().convertToString(date: user?.birthdayDate ?? Date() , dateformat: DateFormatType.date)
            detailCell.append(dateStr)
        } else {
            detailCell.append("")
        }
        
        let createDate = NSObject().convertToString(date: user?.createDate ?? Date(), dateformat: DateFormatType.date)
        
        detailCell.append(user?.address ?? "")
        detailCell.append(createDate)
        detailCell.append("")
        detailCell.append("")
        detailCell.append("")
        viewInfor()
        tableView.reloadData()
    }
    
    func setUpForTableView() {
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func activitiesBtnPressed(_ sender: Any) {
        isActivity = true
        
        if listComment.count == 0 || user == nil {
            notification.text = "No data to show"
            notification.isHidden = false
        } else {
            notification.isHidden = true
        }
        
        tableView.reloadData()
    }
    
    @IBAction func accountBtnPressed(_ sender: Any) {
        isActivity = false
        
        if user == nil {
            notification.text = "No data to show"
            notification.isHidden = false
        } else {
            notification.isHidden = true
        }
        
        
        tableView.reloadData()
    }
    
    
    func getDataFromAPI(offset: Int, isLoadMore: Bool) {
        
        CommentServices.instance.getAllCommentByUser { (data) in
            guard let data = data else { return }
            
            if data.count == 0 {
                self.notification.text = "No data to show"
                self.notification.isHidden = false
            }
            
            self.listComment = data
            self.tableView.reloadData()
        }
    }
    
    func disableUIView() {
        username.isEnabled = false
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is OneCommentController {
            let vc = segue.destination as? OneCommentController
            let index = sender as! Int

            vc?.isView = false
            vc?.lastComment = listComment[index]
        } else
            if segue.destination is ChangePasswordController {
            
        } else if segue.destination is EditInforController {
            let vc = segue.destination as? EditInforController
            vc?.user = user ?? UserResponse()
        }
    }
    
}

extension AccountController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isActivity ? listComment.count : titleCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isActivity {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.userComment.rawValue, for: indexPath) as! UserCommentCell
            
            cell.updateView(cmt: listComment[indexPath.row], isUser: false)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.account.rawValue, for: indexPath)
            
            cell.detailTextLabel?.text = detailCell[indexPath.row]
            cell.textLabel?.text = titleCell[indexPath.row]
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
            
            if indexPath.row < (titleCell.count - 2) {
                cell.selectionStyle = UITableViewCell.SelectionStyle.none;
            }
            
            return cell
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        getUser()
        isActivity = true
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        
        if isActivity {
            performSegue(withIdentifier: SegueIdentifier.accountToComment.rawValue, sender: indexPath?.row)
        }
            
        else {
            let index = titleCell.count - 1
            
            if indexPath?.row == index  {
                self.user = nil
                AuthServices.instance.signout()
                self.handleAfterLogOut()
            
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginControllerID") as UIViewController
                // .instantiatViewControllerWithIdentifier() returns AnyObject! this must be downcast to utilize it
                
                self.present(viewController, animated: false, completion: nil)
                
            } else if indexPath?.row == index  {
                performSegue(withIdentifier: SegueIdentifier.accountToPassword.rawValue, sender: nil)
            } else {
                performSegue(withIdentifier: SegueIdentifier.accountToEditInfor.rawValue, sender: nil)
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let share = UITableViewRowAction(style: .normal, title: title) { (action, indexPath) in
            // share item at indexPath
            let alert = UIAlertController(title: "Alert", message: "Are you sure want to delet this comment?", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                
                CommentServices.instance.deleteOne(cmtID: self.listComment[indexPath.row].id ?? "", completion: { (data) in
                    guard let data = data else { return }
                    
                    if data {
                        
                        self.listComment.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .bottom)
                    } else {
                        let alert = UIAlertController(title: "Failed", message: "Please try next time", preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                        self.present(alert, animated: true)
                    }
                })
            }))
            
            self.present(alert, animated: true)
        }
        
        share.backgroundColor = .red
        
        return [share]
    }
    
    
}
