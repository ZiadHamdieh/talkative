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
    
    // runs when activity is detected inside the text field (i.e. user starts typing)
    func textFieldDidBeginEditing(_ textField: UITextField) {
        <#code#>
    }
    
    // runs when activity inside text field stops
    func textFieldDidEndEditing(_ textField: UITextField) {
        <#code#>
    }
}
