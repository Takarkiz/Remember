//
//  AddTableViewCell.swift
//  ReMember
//
//  Created by k15046kk on 2019/06/16.
//  Copyright © 2019 澤田昂明. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_Theming

class HeaderView: UIView {
    
    var addPersonButton: MDCButton!
    var shareMemoryButton: MDCButton!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setButton()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    private func setButton() {
        addPersonButton = MDCButton(frame: CGRect(x: bounds.width / 2 - 7.5 - 143, y: 40, width: 143, height: 143))
        shareMemoryButton = MDCButton(frame: CGRect(x: bounds.width / 2 + 7.5, y: 40, width: 143, height: 143))
        let inputImage = UIImage(named: "input_button")
        let shareImage = UIImage(named: "share_button")
        addPersonButton.backgroundColor = .white
        shareMemoryButton.backgroundColor = .white
        addPersonButton.enableRippleBehavior = true
        shareMemoryButton.enableRippleBehavior = true
        addPersonButton.setImage(inputImage, for: .normal)
        shareMemoryButton.setImage(shareImage, for: .normal)
        addPersonButton.setElevation(ShadowElevation(rawValue: 6.0), for: .normal)
        shareMemoryButton.setElevation(ShadowElevation(rawValue: 6.0), for: .normal)
        self.addSubview(addPersonButton)
        self.addSubview(shareMemoryButton)
    }
    
        
    private func globalScheme(color: UIColor) -> MDCContainerScheme {
        let containerScheme = MDCContainerScheme()
        containerScheme.shapeScheme = MDCShapeScheme()
        containerScheme.colorScheme.primaryColor = color
        // Customize containerScheme here...
        return containerScheme
    }
    
}
