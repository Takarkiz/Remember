//
//  RegistrationViewController.swift
//  ReMember
//
//  Created by k15046kk on 2019/06/15.
//  Copyright © 2019 澤田昂明. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, UIImagePickerControllerDelegate {

    @IBOutlet var imageButton: UIButton!
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var dateFiled: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func choosePicture(){
        // カメラロールが利用可能か？
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // 写真を選ぶビュー
            let pickerView = UIImagePickerController()
            // 写真の選択元をカメラロールにする
            // 「.camera」にすればカメラを起動できる
            pickerView.sourceType = .photoLibrary
            // デリゲート
            pickerView.delegate = self
            // ビューに表示
            self.present(pickerView, animated: true)
        }
    }
    
    // 写真を選んだ後に呼ばれる処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 選択した写真を取得する
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        // ビューに表示する
        imageButton.setImage(image, for: .normal)
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
    }
    
    // 登録ボタン押した時
    @IBAction func store(){
        print(nameField.text)
        print(dateFiled.text)
        
        //まずは、同じstororyboard内であることをここで定義します
        let storyboard: UIStoryboard = self.storyboard!
        //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
        let second = storyboard.instantiateViewController(withIdentifier: "person")
        //ここが実際に移動するコードとなります
        self.present(second, animated: true, completion: nil)
    }
    
    @IBAction func back(){
        dismiss(animated: true, completion: nil)
    }

}
