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

class AddTableViewCell: UITableViewCell {
    
    @IBOutlet var addPersonButton: MDCButton!
    @IBOutlet var shareMemoryButton: MDCButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        addPersonButton.setElevation(ShadowElevation(rawValue: 6.0), for: .normal)
        shareMemoryButton.setElevation(ShadowElevation(rawValue: 6.0), for: .normal)
        
        addPersonButton.applyTextTheme(withScheme: globalScheme(color: UIColor(hex: "6A6A6A")))
        shareMemoryButton.applyTextTheme(withScheme: globalScheme(color: UIColor(hex: "6A6A6A")))
        
        addPersonButton.backgroundColor = UIColor(hex: "FFFFFF")
        shareMemoryButton.backgroundColor = UIColor(hex: "FFFFFF")
    }
    
    private func globalScheme(color: UIColor) -> MDCContainerScheme {
        let containerScheme = MDCContainerScheme()
        containerScheme.shapeScheme = MDCShapeScheme()
        containerScheme.colorScheme.primaryColor = color
        // Customize containerScheme here...
        return containerScheme
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
