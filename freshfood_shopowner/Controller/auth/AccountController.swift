//
//  AccountController.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/12/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class AccountController: UIViewController {

    @IBOutlet weak var userAvatar: CustomImageView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userDescription: UITextField!
    @IBOutlet weak var accountBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    let titleCell = ["Email:", "Birthday:", "Address:", "Join on:", "Edit information", "Change password"]
    var detailCell = [String]()
    
    var user = UserResponse()
    var listComment = [CommentResponse]()
    var isActivity = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        disableUIView()
        
        setUpForTableView()
        
        viewInfor()
    }
    
    func registerCells() {
        
        tableView.register(UINib(nibName: CellIdentifier.userComment.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.userComment.rawValue)
    }
    
    func viewInfor() {
//        userAvatar.loadImageUsingUrlString(urlString: BASE_URL_IMAGE + user.avatar!)
        userAvatar.setRounded(color: .white)
        userName.text = user.name!
        userDescription.text = "newbee - Top 1000 - 10 Followers"
        
        userDescription.setboldSystemFontOfSize(size: 14)
        userName.setboldSystemFontOfSize(size: 18)
    }
    
    func setupDetailInfor() {
        
        detailCell.append(user.email!)

        if (user.birthday != nil) {
            let dateStr = NSObject().convertToString(date: user.birthdayDate! , dateformat: DateFormatType.date)
            detailCell.append(dateStr)
        } else {
            detailCell.append("")
        }

        let createDate = NSObject().convertToString(date: user.createDate! , dateformat: DateFormatType.date)

        detailCell.append(user.address!)
        detailCell.append(createDate)
        detailCell.append("")
        detailCell.append("")
        
        self.tableView.reloadData()
    }
    
    func setUpForTableView() {
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func commentBtnPressed(_ sender: Any) {
        isActivity = true
        tableView.reloadData()
    }
    
    @IBAction func accountBtnPressed(_ sender: Any) {
        getProfile()
        isActivity = false
        tableView.reloadData()
    }
    
    
    func getDataFromAPI(offset: Int, isLoadMore: Bool) {
        
        CommentServices.instance.getAllCommentByUser() { (data) in
            guard let data = data else { return }
            
            self.listComment = data
            self.getProfile()
        }
    }
    
    func getProfile() {
        AuthServices.instance.getProfile { (data) in
            guard let data = data else { return }
            
            self.user = data
            self.setupDetailInfor()
            self.tableView.reloadData()
        }
    }
    
    func disableUIView() {
        userName.isEnabled = false
        userDescription.isEnabled = false
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.destination is NewCommentController {
//            let vc = segue.destination as? NewCommentController
//            let index = sender as! Int
//
//            vc?.lastComment = convertCommentDTOToComment(commentDto: listComment[index])
//            vc?.isNew = false
//            vc?.shopitemId = listComment[index].shopitem_id!
//            vc?.nameShop = listComment[index].entity_name!
//        } else
            if segue.destination is ChangePasswordController {
            
        } else if segue.destination is EditInforController {
            let vc = segue.destination as? EditInforController
            vc?.user = user
        }
    }
    
//    func convertCommentDTOToComment(commentDto : CommentDTOResponse) -> CommentResponse {
//        return CommentResponse(id: commentDto.id!, title: commentDto.title!, content: commentDto.content!, create_date: commentDto.createDate!, user: user, rating: commentDto.rating!)
//    }
}

extension AccountController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isActivity ? listComment.count : titleCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isActivity {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.userComment.rawValue, for: indexPath) as! UserCommentCell
            
            cell.updateView(cmt: listComment[indexPath.row], user: nil, item: nil)
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
        
        getDataFromAPI(offset: 0, isLoadMore: false)
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
                performSegue(withIdentifier: SegueIdentifier.accountToPassword.rawValue, sender: nil)
            } else {
                performSegue(withIdentifier: SegueIdentifier.accountToEditInfor.rawValue, sender: nil)
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
//            CommentServices.shared.deleteOne(id: listComment[indexPath.row].id!) { (data) in
//                guard let data = data else { return }
//
//                if data == 1 {
//                    self.listComment.remove(at: indexPath.row)
//                    self.tableView.deleteRows(at: [indexPath], with: .bottom)
//                }
//            }
        }
    }
    
}
