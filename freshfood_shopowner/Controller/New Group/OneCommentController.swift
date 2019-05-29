//
//  OneCommentController.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/16/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import Cosmos
import IQKeyboardManagerSwift

class OneCommentController: UIViewController {
    @IBOutlet weak var shopItemName: UILabel!
    
    @IBOutlet weak var ratingview: CosmosView!
    @IBOutlet weak var titleCmt: UITextField!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    
    var shopitemId = 0
    var isView = true
    var shopitem = ShopItemResponse()
    var lastComment = CommentResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        
        setUpUI()
        handlerkeyboard()
        viewLastComment()
        
        if isView {
//            doneBtn.title = "Report"
            getUserInfor(id: lastComment.user_id ?? "")
            disableView()
        } else {
            getShopItemInfor(id: lastComment.shop_item_id ?? "")
        }
    }
    

    func getUserInfor(id: String) {
        AuthServices.instance.getProfile(userID: id) { (data) in
            guard let data = data else { return }
            self.shopItemName.text =  "User: \(data.name ?? "")"
        }
    }

    func getShopItemInfor(id: String) {
        ShopItemService.instance.getOneById(shop_item_id: id) { (data) in
            guard let data = data else { return }
            self.shopItemName.text = "Food: \(data.name ?? "")"
        }
    }
    
    func disableView() {
        ratingview.settings.updateOnTouch = false
        titleCmt.isEnabled = false
        content.isEditable = false
        
    }
    
    @objc func donePressed() {
        didPressOnDoneButton()
    }
    
    func viewLastComment() {
        titleCmt.text = lastComment.title ?? ""
        ratingview.rating = lastComment.rating ?? 3.0
        content.text = lastComment.content ?? ""
        content.textColor = .black
    }
    
    func setUpUI() {
        
        ratingview.rating = 3.0
        ratingview.settings.minTouchRating = 1.0
        ratingview.settings.updateOnTouch = true
        ratingview.settings.fillMode = .precise
        ratingview.text = "Rate me"
        
        titleCmt.delegate = self
        content.delegate = self
        
        content.setBorder(with: BORDER_TEXT_COLOR)
        content.setBorderRadious(radious: 10)
        //        ratingview.setBottomBorder(color: .darkGray)
        //        titleCmt.setBottomBorder(color: .darkGray)
        
    }
    
    
    // handle keyboard when add new comment
    func handlerkeyboard() {
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Send"
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        IQKeyboardManager.shared.shouldPlayInputClicks = false // set to true by default
    }
    
    func validString(string: String) -> String {
        var result = ""
        var strimString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        //trim the string
        strimString = strimString.trimmingCharacters(in: CharacterSet.newlines)
        // replace occurences within the string
        while let rangeToReplace = strimString.range(of: "\n\n") {
            strimString.replaceSubrange(rangeToReplace, with: "\n")
        }
        
        let resultArr  = strimString.split(separator: " ")
        
        for item in resultArr {
            result += item + " "
        }
        
        return result
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        didPressOnDoneButton()
    }
    
    @objc func didPressOnDoneButton() {
        if validateInput() {
            
            lastComment.content = validString(string: content.text)
            lastComment.title = validString(string: titleCmt.text!)
            lastComment.rating = ratingview.rating
            lastComment.create_date = Date().timeIntervalSince1970
            
            if isView {
                
            } else {
                CommentServices.instance.editOne(cmt: lastComment) { (data) in
                    guard let data = data else { return }
                    if data {
                        self.showAlert(title: "Error", message: "Something went wrong. Please try again.")
                    } else {
                        self.showAlert(title: "Error", message: "Something went wrong. Please try again.")
                    }
                }
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func validateInput() -> Bool {
        
        if titleCmt.text == "" || titleCmt.text?.lowercased() == "enter title" || content.text == "" || content.text.lowercased() == "enter content" {
            showAlertError(title: "Error", message: Notification.comment.nilWithInfor.rawValue)
            return false
        } else if !titleCmt.text!.isValidString() {
            showAlertError(title: "Error", message: Notification.comment.titleNotValid.rawValue)
            return false
            
        } else if content.text == nil || !content.text!.isValidString() {
            showAlertError(title: "Error", message: Notification.comment.contentNotValid.rawValue)
            return false
            
        } else {
            return true
        }
    }
    
    func showAlertError(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension OneCommentController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let invocation = IQInvocation(self, #selector(didPressOnDoneButton))
        textField.keyboardToolbar.doneBarButton.invocation = invocation
    }
}


extension OneCommentController: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        print("textViewDidChangeSelection")
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.selectedRange = NSMakeRange(0, 0);
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.selectedRange = NSMakeRange(0, 0);
        let invocation = IQInvocation(self, #selector(didPressOnDoneButton))
        textView.keyboardToolbar.doneBarButton.invocation = invocation
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if (textView.textColor == UIColor.lightGray) {
            
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    
}
