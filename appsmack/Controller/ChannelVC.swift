//
//  ChannelVC.swift
//  appsmack
//
//  Created by Dante on 2019/9/30.
//  Copyright © 2019 cinderella. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {


    @IBOutlet weak var userImg: CircleImage!
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBAction func prepareForUnwind(segue:UIStoryboardSegue){}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().rearViewRevealWidth=self.view.frame.size.width-60
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn{
            //show profile page
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile,animated: true,completion: nil)
        }
        else
        {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
    
    @objc func userDataDidChange(_ notif:Notification){
        if AuthService.instance.isLoggedIn{
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            userImg.image = UIImage(named:UserDataService.instance.avatarName)
            userImg.backgroundColor = UserDataService.instance.returnUIColor(compoents: UserDataService.instance.avatarColor)
        } else {
            loginBtn.setTitle("Login", for: .normal)
            userImg.image = UIImage(named:"menuProfileIcon")
            userImg.backgroundColor = UIColor.clear
            
        }
    }
}
