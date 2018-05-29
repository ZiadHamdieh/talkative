//
//  ViewController.swift
//  talkative
//
//  Created by Ziad Hamdieh on 2018-05-11.
//  Copyright © 2018 Ziad Hamdieh. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @IBAction func registerPressed(_ sender: AnyObject) {
        
        // user auth on firebase
        Auth.auth().createUser(withEmail: emailTextField.text!,
                               password: passwordTextField.text!) { (user, error) in
                                if error == nil {
                                    // successful registration
                                    print("registration was successful")
                                }
                                else {
                                    print(error!)
                                }
        }
    }
    
    
}


