//
//  PersonCollectionViewController.swift
//  ReMember
//
//  Created by k15046kk on 2019/06/16.
//  Copyright © 2019 澤田昂明. All rights reserved.
//

import UIKit
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
    private var memory: [Memory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeCollectionView()
        setupAppBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("ID\(id)")
        readData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddNewMemory" {
            let personVC = segue.destination as! AddViewController
            personVC.userId = self.id
        }

    }
    
    @IBAction func createMovie() {
        
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
            self.memory = memoryArray
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            //            self.memory.append(contentsOf: memoryArray)
            //            let dispatchGroup = DispatchGroup()
            //            for m in memoryArray{
            //                dispatchGroup.enter()
            //                DispatchQueue.global().async {
            //                    self.memory.append(m)
            //                    dispatchGroup.leave()
            //                }
            //            }
            //            dispatchGroup.notify(queue: .main) {
            
            //            }
            
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
        print("\(id)における配列の個数\(memory.count)")
        return memory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.memoryImageView.image = memory[indexPath.item - 1].image
        
        return cell
    }
}
