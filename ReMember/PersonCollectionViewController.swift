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
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var nameLabel:UILabel!
    
    var name: String = ""
    var date: String = ""
    var image: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        
        nameLabel.text = "aiuto"
        
        let firePost = FirestorePost(roomId: id)
        firePost.readMemory { (memoryArray) in
            self.image = memoryArray[0].image
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagecell",
                                                      for: indexPath) as! ImageCollectionViewCell
        
        cell.imagea.image = self.image
 
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
