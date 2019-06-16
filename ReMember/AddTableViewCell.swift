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
        
        addPersonButton.setImage(UIImage(named: "input_button"), for: .normal)
        shareMemoryButton.setImage(UIImage(named: "share_button"), for: .normal)
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
