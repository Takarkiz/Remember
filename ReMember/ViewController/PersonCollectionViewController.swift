//
//  PersonCollectionViewController.swift
//  ReMember
//
//  Created by k15046kk on 2019/06/16.
//  Copyright © 2019 澤田昂明. All rights reserved.
//

import UIKit

class PersonCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var id:String!
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var nameLabel:UILabel!
    
    var name: String = ""
    var date: String = ""
    var memory: [Memory] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        
        nameLabel.text = "きな粉"
        
        UITabBar.appearance().tintColor =
            UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
        
         UITabBar.appearance().barTintColor =
            UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        let firePost = FirestorePost(roomId: "1E6ABD01-B50A-491A-B8C0-85689D484A27")
//        firePost.readMemory { (memoryArray) in
//            self.memory.append(contentsOf: memoryArray)
//            let dispatchGroup = DispatchGroup()
//            for m in memoryArray{
//                dispatchGroup.enter()
//                DispatchQueue.global().async {
//                    self.memory.append(m)
//                    dispatchGroup.leave()
//                }
//            }
//            dispatchGroup.notify(queue: .global()) {
//                self.collectionView.reloadData()
//            }
//
//        }
    }
    
    @IBAction func createMovie() {
        performSegue(withIdentifier: "toWebView", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(memory.count)
        //return memory.count
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath)
        //cell.imagea.image = memory[indexPath.item].image
        cell.backgroundColor = .red
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
    
    @IBAction func back(){
        //まずは、同じstororyboard内であることをここで定義します
        let storyboard: UIStoryboard = self.storyboard!
        //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
        let second = storyboard.instantiateViewController(withIdentifier: "first")
        //ここが実際に移動するコードとなります
        self.present(second, animated: true, completion: nil)
    }

}
