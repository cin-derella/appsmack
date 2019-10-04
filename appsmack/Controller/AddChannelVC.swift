//
//  AddChannelVC.swift
//  appsmack
//
//  Created by Dante on 2019/10/3.
//  Copyright © 2019 cinderella. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {
    
    @IBOutlet weak var nameTxt: UITextField!
    
    @IBOutlet weak var chanDesc: UITextField!
    

    @IBOutlet weak var bgView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }



    @IBAction func createChannelPressed(_ sender: Any) {
        guard let channelName = nameTxt.text, nameTxt.text != "" else {return}
        guard let channelDesc = chanDesc.text else {return}
        SocketService.instance.addChannel(channelName: channelName, channelDescription: channelDesc) { (success) in
            if success{
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func closeModalPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupView(){
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.closeTop(_:)))
        bgView.addGestureRecognizer(closeTouch)
        
        nameTxt.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedStringKey.foregroundColor:cinPurplePlaceholder])
        chanDesc.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedStringKey.foregroundColor:cinPurplePlaceholder])
    }
    
    @objc func closeTop(_ recognizer:UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
        
        
    }
}
