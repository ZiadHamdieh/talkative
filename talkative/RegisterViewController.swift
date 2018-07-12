//
//  ViewController.swift
//  talkative
//
//  Created by Ziad Hamdieh on 2018-05-11.
//  Copyright © 2018 Ziad Hamdieh. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
import SVProgressHUD

class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerPressed(_ sender: AnyObject) {
        
        // user auth on firebase
        Auth.auth().createUser(withEmail: email.text!,
                               password: password.text!) {
                                (userDetails, error) in
                                
                                SVProgressHUD.show()
                                
                                // completion handler
                                if error == nil {
                                    // successful registration
                                    SVProgressHUD.dismiss()
                                    ProgressHUD.showSuccess("registration was successful")
                                    
                                    
                                    // log user into app and go to chat screen
                                    self.performSegue(withIdentifier: "goToChatScreen", sender: self)
                                    
                                }
                                else {
                                    SVProgressHUD.dismiss()
                                    print(error!)
                                    ProgressHUD.showError("Invalid email/pasword")
                                }
        }
        
        
    }
    
    
}


