//
//  ChatVC.swift
//  appsmack
//
//  Created by Dante on 2019/9/30.
//  Copyright © 2019 cinderella. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    //Outlets
    
    @IBOutlet weak var menuBtn: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        if AuthService.instance.isLoggedIn{
            AuthService.instance.findUserByEmail(completion: {(success)in
                NotificationCenter.default.post(name:NOTIF_USER_DATA_DID_CHANGE,object: nil)
            })
        }
    }
    

}
