//
//  LogInViewController.swift
//  talkative
//
//  Created by Ziad Hamdieh on 2018-05-11.
//  Copyright © 2018 Ziad Hamdieh. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
import SVProgressHUD

class LogInViewController: UIViewController {
    
    //MARK: - IBOutlets
    /*************************************************************************************/
   
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    //MARK: - IBActions
    /*************************************************************************************/
    
    @IBAction func logInPressed(_ sender: AnyObject) {
        Auth.auth().signIn(withEmail: email.text!,
                           password: password.text!) {
                            (userDetails, error) in
                            
                            SVProgressHUD.show()
                            if error == nil {
                                SVProgressHUD.dismiss()
                                ProgressHUD.showSuccess("Chat on, my dude!")
                                
                                self.performSegue(withIdentifier: "goToChatScreen", sender: self)
                            }
                            else {
                                SVProgressHUD.dismiss()
                                print(error!)
                                ProgressHUD.showError("Invalid Username/Password combination.")
                            }
        }
    }
}
