//
//  ViewController.swift
//  ReMember
//
//  Created by 澤田昂明 on 2019/06/15.
//  Copyright © 2019 澤田昂明. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let fireRegistration = FirestoreResistration()
    
    private let userDefaults = UserDefaults.standard
    private var persons: [Person] = []
    private var personIdList: [String]? = []
    
    private var selectedCell: Int = 0
    private let formatter: DateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "AddTableViewCell", bundle: nil), forCellReuseIdentifier: "kojin")
        self.tableView.register(UINib(nibName: "PersonTableViewCell", bundle: nil), forCellReuseIdentifier: "PersonTableViewCell")
        
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        // 背景
        let bg = UIImage(named: "bg_image")
        let bgImageView = UIImageView(frame: CGRect(x: 0,y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height))
        bgImageView.image = bg
        self.tableView.backgroundView = bgImageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        startReadingData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    @objc private func toRegistration() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toAddPersonView", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPersonList" {
            let personVC = segue.destination as! PersonCollectionViewController
            personVC.id = personIdList![selectedCell]
            personVC.name = persons[selectedCell].name
            print("userID: \(personIdList![selectedCell])")
        }
    }
    
    // 端末に保存されたperson_idの取り出し
    private func personsId() -> [String]? {
        if let personIds = userDefaults.array(forKey: "personId") {
            return personIds as? [String]
        } else {
            return nil
        }
    }
    
    // firestoreからデータの取得
    private func startReadingData() {
        personIdList = personsId()
        guard let idList = personIdList else {
            print("データなし")
            return
        }
        
        for id in idList {
            fireRegistration.getPerson(id: id){ (result) in
                switch result{
                case .success(let value):
                    self.persons.append(value)
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    print("errorLog: \(error)")
                }
                
            }
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // TableViewのセルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    // TableViewのセルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonTableViewCell", for: indexPath) as! PersonTableViewCell
        cell.imagea.image = persons[indexPath.row].image
        cell.name.text = persons[indexPath.row].name
        cell.date.text = formatter.string(from: persons[indexPath.row].date)
        return cell
        
    }
    
    // TableViewが選択された時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = indexPath.row
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toPersonList", sender: nil)
        }
    }
    
    // セルの大きさ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 193
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clear // 透明にすることでスペースとする
    }
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clear// 透明にすることでスペースとする
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.bounds.width, height: 173))
        headerView.addPersonButton.addTarget(nil, action: #selector(toRegistration), for: .touchUpInside)
        return headerView
    }
    
}
