//
//  ViewController.swift
//  ReMember
//
//  Created by 澤田昂明 on 2019/06/15.
//  Copyright © 2019 澤田昂明. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var save = UserDefaults.standard
    let fireRegistration = FirestoreResistration()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    
        self.tableView.register(UINib(nibName: "AddTableViewCell", bundle: nil),
                                forHeaderFooterViewReuseIdentifier: "kojin")
        self.tableView.register(UINib(nibName: "PersonTableViewCell", bundle: nil),
                                forHeaderFooterViewReuseIdentifier: "person")
//
//
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    // TableViewのセルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    // TableViewのセルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "person", for: indexPath) as! PersonTableViewCell
//        var cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "kojin", for: indexPath) as! AddTableViewCell
        if indexPath.item == 0{
            
        }else{
            //let cell = tableView.dequeueReusableCell(withIdentifier: "person", for: indexPath) as! PersonTableViewCell

            //　他のやつ
        }
        
        return cell
    }
    
    // TableViewが選択された時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.item == 0 {
            //まずは、同じstororyboard内であることをここで定義します
            let storyboard: UIStoryboard = self.storyboard!
            //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
            let second = storyboard.instantiateViewController(withIdentifier: "registration")
            //ここが実際に移動するコードとなります
            self.present(second, animated: true, completion: nil)
        }else{
            //まずは、同じstororyboard内であることをここで定義します
            let storyboard: UIStoryboard = self.storyboard!
            //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
            let second = storyboard.instantiateViewController(withIdentifier: "person")
            //ここが実際に移動するコードとなります
            self.present(second, animated: true, completion: nil)
        }

    }

}

