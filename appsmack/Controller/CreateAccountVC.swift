//
//  CreateAccountVC.swift
//  appsmack
//
//  Created by Dante on 2019/10/1.
//  Copyright © 2019 cinderella. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

  
    }
    
    
    
    @IBAction func closePreessed(_ sender: Any) {
      performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
  
}
