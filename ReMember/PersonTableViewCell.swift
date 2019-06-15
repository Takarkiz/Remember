//
//  PersonTableViewCell.swift
//  ReMember
//
//  Created by k15046kk on 2019/06/15.
//  Copyright © 2019 澤田昂明. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
    
    @IBOutlet var imagea:UIImageView!
    @IBOutlet var name:UILabel!
    @IBOutlet var date:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
