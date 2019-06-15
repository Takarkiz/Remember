//
//  AddViewController.swift
//  ReMember
//
//  Created by 吉川莉央 on 2019/06/16.
//  Copyright © 2019 澤田昂明. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNmaeLabel: UILabel!
    @IBOutlet var userDeathDateLabel: UILabel!
    @IBOutlet var contentTextView: UITextView!
    
    let userId = "1E6ABD01-B50A-491A-B8C0-85689D484A27"
    let registration = FirestoreResistration()
    //let firePost =
    
    private var memoryImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        setUserProf()
    }
    
    @IBAction func willPhotoPick() {
        // カメラロールが利用可能か？
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // 写真を選ぶビュー
            let pickerView = UIImagePickerController()
            // 写真の選択元をカメラロールにする
            // 「.camera」にすればカメラを起動できる
            pickerView.sourceType = .photoLibrary
            // デリゲート
            pickerView.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            // ビューに表示
            self.present(pickerView, animated: true)
        }
    }
    
    @IBAction func willPostMemoery() {
        guard let img = memoryImage else { return }
        if contentTextView.text != "" {
            let text = contentTextView.text
            
        }
    }
    
    private func setUserProf() {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        print(formatter.string(from: Date()))
        
        registration.getPerson(id: userId) { (result) in
            switch result{
            case .success(let value):
                self.userImageView.image = value.image
                self.userNmaeLabel.text = value.name
                self.userDeathDateLabel.text = formatter.string(from: value.date)
                
            case .failure(let error):
                print("can not fetch user prof \(error)")
            }
            
        }
    }
}

extension AddViewController: UIImagePickerControllerDelegate {
    // 写真を選んだ後に呼ばれる処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 選択した写真を取得する
        let image = info[.originalImage] as! UIImage
        // ビューに表示する
        memoryImage = image
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
    }
}

extension AddViewController: UITextViewDelegate {
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == "" {
            // TODO: - ボタンの色を変えたい
        } else {
            
        }
        return true
    }
}
