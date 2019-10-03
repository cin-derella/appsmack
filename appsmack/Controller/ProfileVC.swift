//
//  ProfileVC.swift
//  appsmack
//
//  Created by Dante on 2019/10/3.
//  Copyright © 2019 cinderella. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()


    }


    @IBAction func closeModalPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        UserDataService.instance.logoutUser()
        NotificationCenter.default.post(name:NOTIF_USER_DATA_DID_CHANGE,object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    func setupView(){
        userName.text = UserDataService.instance.name
        userEmail.text = UserDataService.instance.email
        profileImage.image = UIImage(named:UserDataService.instance.avatarName)
        profileImage.backgroundColor = UserDataService.instance.returnUIColor(compoents: UserDataService.instance.avatarColor)
        
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
    }
    
    @objc func closeTap(_ recognizer : UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
}
