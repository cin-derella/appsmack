//
//  CreateAccountVC.swift
//  appsmack
//
//  Created by Dante on 2019/10/1.
//  Copyright © 2019 cinderella. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

  
    }
    
    @IBAction func createAccntPressed(_ sender: Any) {
        guard let email = emailTxt.text, emailTxt.text != "" else { return }
        guard let pass = passTxt.text, passTxt.text != "" else { return }
        
        debugPrint("pass is \(pass)")
        
        AuthService.instance.registerUser(email: email, password: pass) { (success) in
            if success {
                print("register user succeeded!")
            } else {
                print("register user failed!")
            }
        }
    }
    
    @IBAction func pickAvatarPressed(_ sender: Any) {
    }
    
    @IBAction func pickBGColorPressed(_ sender: Any) {
    }
    
    @IBAction func closePreessed(_ sender: Any) {
      performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
  
}