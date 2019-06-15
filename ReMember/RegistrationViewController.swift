//
//  RegistrationViewController.swift
//  ReMember
//
//  Created by k15046kk on 2019/06/15.
//  Copyright © 2019 澤田昂明. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageButton: UIButton!
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            // デフォルトの画像を表示する
            imageView.image = UIImage(named: "no_image.png")
        }
    }
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var dateFiled: UITextField!

    
    let fsRegstration = FirestoreResistration()
    
    var profImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameField.delegate = self
        dateFiled.delegate = self
    }
    

    @IBAction func choosePicture(){
        // カメラロールが利用可能か？
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // 写真を選ぶビュー
            let pickerView = UIImagePickerController()
            // 写真の選択元をカメラロールにする
            // 「.camera」にすればカメラを起動できる
            pickerView.sourceType = .photoLibrary
            pickerView.allowsEditing = true
            // デリゲート
            pickerView.delegate = self
            // ビューに表示
            self.present(pickerView, animated: true)
        }
        
        
    }
    
    // 写真を選んだ後に呼ばれる処理
    func imagePickerController(_ imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        // 選択した写真を取得する
        if let pickedImage = info[.originalImage] as? UIImage {
            imageButton.setImage(pickedImage, for: .normal)
            profImage = pickedImage
        }
        
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
    }
    
    // 登録ボタン押した時
    @IBAction func store(){
        guard let name = nameField.text else {return}
        guard let date = dateFiled.text else {return}
        guard let img = profImage else {
            return
            
        }
        
        fsRegstration.resisterNewPerson(name: name, date: Date(), image: img) {
            self.toPersonView()
        }
    }
    
    private func toPersonView() {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
