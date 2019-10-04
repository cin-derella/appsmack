//
//  LoginVC.swift
//  appsmack
//
//  Created by Dante on 2019/10/1.
//  Copyright © 2019 cinderella. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    //Outlets
    @IBOutlet weak var usernameTxt: UITextField!
    
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        spinner.isHidden = false
        spinner.startAnimating()
        
        guard let email = usernameTxt.text, usernameTxt.text != "" else { return }
        guard let pass = passwordTxt.text, passwordTxt.text != "" else { return }
        
        AuthService.instance.loginUser(email: email, password: pass) { (success) in
            if success{
                AuthService.instance.findUserByEmail { (success) in
                    if success{
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        self.spinner.isHidden = true
                        self.spinner.stopAnimating()
                        print("login succeeded and email exists:\(AuthService.instance.userEmail)")
                        MessageService.instance.findAllChannel { (success) in
                            print("all channel find:true")
                            NotificationCenter.default.post(name: NOTIF_CHANNEL_DATA_DID_CHANGE, object: nil)
                        }
                        self.dismiss(animated: true, completion: nil)
                    }
                    else {
                        self.spinner.isHidden = true
                        self.spinner.stopAnimating()
                        print("email is bad:\(AuthService.instance.userEmail)")
                        //self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            else {
                self.spinner.isHidden = true
                self.spinner.stopAnimating()
                print("login failed:\(AuthService.instance.userEmail)")
                //self.dismiss(animated: true, completion: nil)
            }
        }
    }
       
       
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
     }
    
    @IBAction func createAccountBtnPressed(_ sender: Any) {
            
            performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
        }
  
    func setupView(){
        spinner.isHidden = true
        usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor:cinPurplePlaceholder])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor:cinPurplePlaceholder])
    }
}
