//
//  ChatViewController.swift
//  talkative
//
//  Created by Ziad Hamdieh on 2018-05-11.
//  Copyright © 2018 Ziad Hamdieh. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class ChatViewController: UIViewController {
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up appropriate delegates and dataSource
        messageTextfield.delegate = self
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        // register cell's .xib
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "messageCell")
        
        // resize the tableview based on the size of the messages upon loading
        resizeTableView()
        
        // register a TableView to monitor tap gestures by user.
        // We can then use this to figure out when the user is clicking away from the message text box
        let userTappedScreen = UITapGestureRecognizer(target: self, action: #selector(tableViewWasTapped))
        
        // add tap gesture to the table view
        messageTableView.addGestureRecognizer(userTappedScreen)
        
    }
    
    
    @objc func tableViewWasTapped() {
        // this method calls textFieldDidEndEditing() which in turn resizes
        // the message box text field back to default when user has finished editing the message
        messageTextfield.endEditing(true)
    }
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
    
        
        
    }
    
    
    @IBAction func signOutPressed(_ sender: AnyObject) {
        
        do {
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)
        }
        catch {
            print("Error signing out")
            ProgressHUD.showError("Check Internet Connection")
        }
    }
    
    // resize TableView if user sends a long message
    func resizeTableView() {
        messageTableView.estimatedRowHeight = 100.0
        messageTableView.rowHeight = UITableViewAutomaticDimension
    }
}

extension ChatViewController: UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
        let messageArray = ["first", "second", "third"]
        cell.message.text = messageArray[indexPath.row]
        // avatar image cell shape customization below
//        cell.imageView?.image = UIImage(named: "")
//        cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.size.width)! / 2
//        cell.imageView?.layer.masksToBounds = true
        return cell
        
    }
    
    // tells the delegate that editing began in the specified text field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let userKeyboardHeight = 250
        let textBoxHeight = 50
        heightConstraint.constant = CGFloat(textBoxHeight + userKeyboardHeight)
        
        // tell AutoLayout to redraw screen elements after update
        view.layoutIfNeeded()
        
        // animate keyboard popup when user begins editing text field
        UIView.animate(withDuration: 0.3) {
           self.heightConstraint.constant = CGFloat(textBoxHeight + userKeyboardHeight)
           self.view.layoutIfNeeded()
        }
    }
    
    // tells the delegate that editing stopped in the specified text field
    // NOTE: This method does not get called by default, so we use tap gesture methods
    // to trigger itn ( see tableViewWasTapped() )
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
        
    }
}
