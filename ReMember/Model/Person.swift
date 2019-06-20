//
//  Person.swift
//  ReMember
//
//  Created by 澤田昂明 on 2019/06/15.
//  Copyright © 2019 澤田昂明. All rights reserved.
//

import UIKit

class Person {
    
    let id: String
    let name: String
    let date: Date
    let image: UIImage
    
    init(id: String, name: String, date: Date, image: UIImage) {
        self.id = id
        self.name = name
        self.date = date
        self.image = image
    }
}
