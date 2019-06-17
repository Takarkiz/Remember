//
//  CustomButton.swift
//  ReMember
//
//  Created by k15046kk on 2019/06/16.
//  Copyright © 2019 澤田昂明. All rights reserved.
//

import UIKit
@IBDesignable

class CustomButton: UIButton {

    @IBInspectable var cornerRadius : CGFloat = 5.0
    
    override func draw(_ rect: CGRect) {

        self.layer.cornerRadius = cornerRadius
    }

}
