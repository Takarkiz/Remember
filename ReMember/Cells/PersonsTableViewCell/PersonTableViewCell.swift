//
//  PersonTableViewCell.swift
//  ReMember
//
//  Created by k15046kk on 2019/06/15.
//  Copyright © 2019 澤田昂明. All rights reserved.
//

import UIKit
import MaterialComponents

class PersonTableViewCell: UITableViewCell {
    
    @IBOutlet var imagea:UIImageView!
    @IBOutlet var name:UILabel!
    @IBOutlet var date:UILabel!
    @IBOutlet var background: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        background.elevate(elevation: 6.0)
    }
    
    func setCell(image:UIImage, name:String, date:String) {
        //self.imagea.image = image
        self.name.text = name
        self.date.text = date
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}

extension UIView: MaterialView {
    func elevate(elevation: Double) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: elevation)
        self.layer.shadowRadius = CGFloat(elevation)
        self.layer.shadowOpacity = 0.24
    }
}
protocol MaterialView {
    func elevate(elevation: Double)
}
