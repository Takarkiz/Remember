//
//  PersonCollectionViewController.swift
//  ReMember
//
//  Created by k15046kk on 2019/06/16.
//  Copyright © 2019 澤田昂明. All rights reserved.
//

import UIKit
import Alamofire
import MaterialComponents.MaterialBottomAppBar
import MaterialComponents.MaterialBottomAppBar_ColorThemer
import MaterialComponents.MaterialButtons_ButtonThemer

class PersonCollectionViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var bottomBarView: MDCBottomAppBarView!
    private let colorScheme = MDCSemanticColorScheme()
    private let typgoraphyScheme = MDCTypographyScheme()
    private let buttonScheme = MDCButtonScheme()
    
    var id: String!
    var name: String = ""
    private var memoryList: [Memory] = []
    private var selectedMemoryId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeCollectionView()
        setupAppBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        readData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddNewMemory" {
            let personVC = segue.destination as! AddViewController
            personVC.userId = self.id
        }
        
    }
    
    @IBAction func createMovie() {
        if memoryList.count < 5 {
            print("少なスギィ")
            return
        }
        
        guard let personId = id else { return }
        
        // APIリクエストを叩いて，dataとして受け取る
        AF.request("https://spajan.herokuapp.com/api/v1/img/" + String(personId)).responseData { (responseObject) in
            switch responseObject.result {
            case .success(let val):
                print(String(data: val, encoding: .utf8))
            case .failure(let err):
                print("失敗\(err)")
            }
        }
    }
    
    
    @objc private func addImageButton(){
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toAddNewMemory", sender: nil)
        }
    }
    
    @IBAction func back(){
        self.dismiss(animated: true, completion: nil)
    }
    
    private func readData() {
        guard let id = id else { return }
        let firePost = FirestorePost(roomId: id)
        firePost.readMemory { (memoryArray) in
            self.memoryList = memoryArray
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private func initializeCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: 94, height: 94)
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionView.collectionViewLayout = collectionViewLayout
    }
    
    private func setupAppBar() {
        colorScheme.primaryColor = UIColor(hex: "F9796E")
        buttonScheme.colorScheme = colorScheme
        buttonScheme.typographyScheme = typgoraphyScheme
        MDCFloatingActionButtonThemer.applyScheme(buttonScheme, to: bottomBarView.floatingButton)
        MDCBottomAppBarColorThemer.applySurfaceVariant(withSemanticColorScheme: colorScheme,
                                                       to: bottomBarView)
        bottomBarView.floatingButton.setImage(UIImage(named: "add_icon"), for: .normal)
        bottomBarView.floatingButton.addTarget(nil, action: #selector(addImageButton), for: .touchUpInside)
    }
    
    
}

extension PersonCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.memoryImageView.image = memoryList[indexPath.item].image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //selectedMemoryContent = memoryList[indexPath.item].content
        
    }
}
