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
    var headerView: HeaderView!
    
    private let userDefaults = UserDefaults.standard
    private var persons: [Person] = []
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
        
        headerView = HeaderView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.bounds.width, height: 173))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    @objc private func toRegistration() {
        //まずは、同じstororyboard内であることをここで定義します
        let storyboard: UIStoryboard = self.storyboard!
        //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
        let second = storyboard.instantiateViewController(withIdentifier: "registration")
        //ここが実際に移動するコードとなります
        self.present(second, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "person"{
            let personVC = segue.destination as! PersonCollectionViewController
            personVC.id = "1E6ABD01-B50A-491A-B8C0-85689D484A27"
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
        guard let idList = personsId() else { return }
        
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 下に引っ張ったときは、ヘッダー位置を計算して動かないようにする（★ここがポイント..）
        if scrollView.contentOffset.y < -100 {
            headerView.frame = CGRect(x: 0, y: scrollView.contentOffset.y, width: self.view.frame.width, height: 173)
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
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        //まずは、同じstororyboard内であることをここで定義します
        let storyboard: UIStoryboard = self.storyboard!
        //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
        let second = storyboard.instantiateViewController(withIdentifier: "person")
        
        //ここが実際に移動するコードとなります
        self.present(second, animated: true, completion: nil)
        
    }
    
    // セルの大きさ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 173
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
        
        return headerView
    }
    
}
