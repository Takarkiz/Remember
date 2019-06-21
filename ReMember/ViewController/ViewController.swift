//
//  ViewController.swift
//  ReMember
//
//  Created by 澤田昂明 on 2019/06/15.
//  Copyright © 2019 澤田昂明. All rights reserved.
//

import UIKit
import SCLAlertView
import Lottie
import MaterialComponents.MaterialSnackbar

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var loadingAnimationView = AnimationView()
    let fireRegistration = FirestoreResistration()
    var headerView: HeaderView!
    private let message = MDCSnackbarMessage()
    
    
    private let userDefaults = UserDefaults.standard
    private var persons: [Person] = []
    private var personIdList: [String] = []
    
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc private func toRegistration() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toAddPersonView", sender: nil)
        }
    }
    
    @objc private func inputSharingCode() {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        let txt = alertView.addTextField("コードを入力してください")
        alertView.addButton("決定") {
            self.loadId(id: txt.text)
        }
        alertView.addButton("キャンセル", backgroundColor: UIColor(hex: "4480C7"), textColor: UIColor(hex: "FFFFFF"), showTimeout: nil) {
            
        }
        alertView.showCustom("共有",
                             subTitle: "友達が作成したMemberを追加することができます",
                             color: UIColor(hex: "F9796E"),
                             icon: UIImage(named: "鉛筆の無料アイコン7")!)
        
    }
    
    private func loadId(id: String?) {
        guard let personId = id else { return }
        
        // 重複している場合はここで処理を終える
        if willAddDoplicatePerson(inputId: personId) {
            message.text = "すでに登録済みのMemberです"
            MDCSnackbarManager.show(message)
            return
        }
        
        startLoading()
        
        fireRegistration.getPerson(id: personId) { (result) in
            switch result {
            case .success(let value):
                self.loadingAnimationView.stop()
                self.persons.append(value)
                self.saveIdList(id: value.id)
                
                // テーブルビューの更新はメインスレッドで行う
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let err):
                self.loadingAnimationView.stop()
                self.message.text = "追加に失敗しました"
                MDCSnackbarManager.show(self.message)
                print(err)
            }
        }
    }
    
    private func startLoading() {
        loadingAnimationView = AnimationView(frame: CGRect(x: self.view.bounds.width/2-50 , y: self.view.bounds.height/2-50, width: 100, height: 100))
        loadingAnimationView.animation = Animation.named("animation-w400-h300")
        loadingAnimationView.loopMode = .loop
        loadingAnimationView.play()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPersonList" {
            let personVC = segue.destination as! PersonCollectionViewController
            personVC.id = personIdList[selectedCell]
            personVC.name = persons[selectedCell].name
            print("userID: \(personIdList[selectedCell])")
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
    
    private func saveIdList(id: String?) {
        guard let personId = id else { return }
        personIdList.append(personId)
        userDefaults.set(personIdList, forKey: "personId")
    }
    
    private func willAddDoplicatePerson(inputId: String) -> Bool{
        for id in personIdList {
            if id == inputId {
                return true
            }
        }
        
        return false
    }
    
    // firestoreからデータの取得
    private func startReadingData() {
        guard let idList = personsId() else {
            print("データなし")
            return
        }
        personIdList = idList
        
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
        headerView = HeaderView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.bounds.width, height: 173))
        headerView.addPersonButton.addTarget(self, action: #selector(toRegistration), for: .touchUpInside)
        headerView.shareMemoryButton.addTarget(self, action: #selector(inputSharingCode), for: .touchUpInside)
        return headerView
    }
    
}
