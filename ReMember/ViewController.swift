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
    
    var name: String = ""
    var date: String = ""
    var image: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    
        self.tableView.register(UINib(nibName: "AddTableViewCell", bundle: nil), forCellReuseIdentifier: "kojin")
        self.tableView.register(UINib(nibName: "PersonTableViewCell", bundle: nil), forCellReuseIdentifier: "PersonTableViewCell")

        fireRegistration.getPerson(id: "1E6ABD01-B50A-491A-B8C0-85689D484A27"){ (result) in
            switch result{
            case .success(let value):
                self.name = value.name
                var format = DateFormatter()
                format.dateFormat = "yyyy年MM月dd日"
                self.date = format.string(from: value.date)
                self.image = value.image
                self.tableView.reloadData()
                break
                
            case .failure( _):
                break
            }
            
        }

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
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "kojin", for: indexPath) as! AddTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonTableViewCell", for: indexPath) as! PersonTableViewCell
            cell.imagea.image = image
            cell.name.text = name
            cell.date.text = date
            return cell
            
        }

    }
    
    // TableViewが選択された時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30 // セルの上部のスペース
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30 // セルの下部のスペース
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clear // 透明にすることでスペースとする
    }
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clear// 透明にすることでスペースとする
    }

}

