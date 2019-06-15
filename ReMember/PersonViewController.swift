//
//  PersonViewController.swift
//  ReMember
//
//  Created by 早川理々花 on 2019/06/15.
//  Copyright © 2019年 澤田昂明. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // UICollectionViewのアイテム数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    // UICollectionViewアイテム内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    

    @IBAction func toViewController(){
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
