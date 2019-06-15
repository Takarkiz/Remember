//
//  PersonViewController.swift
//  ReMember
//
//  Created by 早川理々花 on 2019/06/15.
//  Copyright © 2019年 澤田昂明. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    

    @IBAction func toViewController(){
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
