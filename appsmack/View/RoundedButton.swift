//
//  RoundedButton.swift
//  appsmack
//
//  Created by Dante on 2019/10/2.
//  Copyright © 2019 cinderella. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBInspectable var cRadius: CGFloat = 3.0 {
        didSet {
            self.layer.cornerRadius = cRadius
        }
    }
    
    override func awakeFromNib() {
        self.setupView()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = cRadius
    }
}
