//
//  LoginViewController.swift
//  MyFBApp
//
//  Created by Anton Fomkin on 24/07/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    private var handle: AuthStateDidChangeListenerHandle!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try? Auth.auth().signOut()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.handle = Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                print("Авторизован")
                   self.performSegue(withIdentifier: "gotoResult", sender: nil)
                  self.usernameTextField.text = nil
                   self.passwordTextField.text = nil
            }
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         Auth.auth().removeStateDidChangeListener(handle)
    }
    
    @IBAction func loginTap(_ sender: Any) {
        guard let email = usernameTextField.text,
            let password = passwordTextField.text
            else {
                return
        }
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("error = \(error)")
            }
        }
    }
    
    
    @IBAction func signinTap(_ sender: Any) {
        guard let email = usernameTextField.text,
            let password = passwordTextField.text
             else {
                return
            }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
            if let error = error {
                print("error = \(error)")
            } else {
                Auth.auth().signIn(withEmail: email, password: password)
            }
        }
    }
}
