//
//  PersonCollectionViewController.swift
//  ReMember
//
//  Created by k15046kk on 2019/06/16.
//  Copyright © 2019 澤田昂明. All rights reserved.
//

import UIKit

class PersonCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var id:String!
    var name:String!
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var nameLabel:UILabel!
    
    var name: String = ""
    var date: String = ""
    var memory: [Memory]

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        
        nameLabel.text = name
        
        UITabBar.appearance().tintColor =
            UIColor(red: 255/255, green: 233/255, blue: 51/255, alpha: 1.0)
        
         UITabBar.appearance().barTintColor =
            UIColor(red: 66/255, green: 74/255, blue: 93/255, alpha: 1.0)
        
        let firePost = FirestorePost(roomId: id)
        firePost.readMemory { (memoryArray) in
            self.memory = memoryArray
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagecell",
                                                      for: indexPath) as! ImageCollectionViewCell
        
        cell.imagea.image = memory[indexPath.row].image
        
        return cell
    }
    
    @IBAction func addImageButton(){
        //まずは、同じstororyboard内であることをここで定義します
        let storyboard: UIStoryboard = self.storyboard!
        //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
        let second = storyboard.instantiateViewController(withIdentifier: "add")
        //ここが実際に移動するコードとなります
        self.present(second, animated: true, completion: nil)
    }
    
    @IBAction func createMovie(){
        
    }
    
    @IBAction func back(){
        //まずは、同じstororyboard内であることをここで定義します
        let storyboard: UIStoryboard = self.storyboard!
        //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
        let second = storyboard.instantiateViewController(withIdentifier: "first")
        //ここが実際に移動するコードとなります
        self.present(second, animated: true, completion: nil)
    }

}
