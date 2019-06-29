//
//  RegistrationViewController.swift
//  ReMember
//
//  Created by k15046kk on 2019/06/15.
//  Copyright © 2019 澤田昂明. All rights reserved.
//

import UIKit
import Lottie
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_Theming

class RegistrationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var loadingAnimationView: AnimationView!
    @IBOutlet var imagePickButton: UIButton!
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            // デフォルトの画像を表示する
            imageView.image = UIImage(named: "no_image.png")
        }
    }
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var dateFiled: UITextField!
    @IBOutlet var comformButton: MDCButton!
    
    private let alertMessage = MDCSnackbarMessage()
    let fsRegstration = FirestoreResistration()
    
    private var profImage: UIImage?
    //UIDatePickerを定義するための変数
    private var datePicker: UIDatePicker = UIDatePicker()
    private var inputDate: Date!
    
    private let userDefaults = UserDefaults.standard
    private var idList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        dateFiled.delegate = self
        
        setButton(elevationValue: 0, color: UIColor(hex: "B2B2B2"))
        setDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        idList = loadPersonsId()
        
    }
    
    // バックボタンの処理
    @IBAction func back(){
        dismiss(animated: true, completion: nil)
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
        if let pickedImage = info[.editedImage] as? UIImage {
            profImage = pickedImage
            imageView.image = profImage
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = self.imageView.frame.height / 2.0
            imagePickButton.isHidden = true
        }
        
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
    }
    
    // 登録ボタン押した時
    @IBAction func store(){
        guard let name = nameField.text else {
            alertMessage.text = "名前が入力されていません"
            MDCSnackbarManager.show(alertMessage)
            return
        }
        guard let date = inputDate else {
            alertMessage.text = "命日が入力されていません"
            MDCSnackbarManager.show(alertMessage)
            return
        }
        guard let img = profImage else {
            alertMessage.text = "写真を登録してください"
            MDCSnackbarManager.show(alertMessage)
            return
        }
        
        loadingAnimationView.animation = Animation.named("animation-w400-h300")
        loadingAnimationView.loopMode = .loop
        loadingAnimationView.play()
        
        fsRegstration.resisterNewPerson(name: name, date: date, image: img) { (id) in
            self.idList.append(id)
            self.userDefaults.setValue(self.idList, forKey: "personId")
            self.loadingAnimationView.stop()
            self.toPersonView()
        }
    }
    
    private func toPersonView() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func setButton(elevationValue: Int, color: UIColor) {
        comformButton.setElevation(ShadowElevation(rawValue: 6), for: .normal)
        comformButton.applyContainedTheme(withScheme: globalScheme(color: color))
    }
    
    private func globalScheme(color: UIColor) -> MDCContainerScheme {
        let containerScheme = MDCContainerScheme()
        containerScheme.shapeScheme = MDCShapeScheme()
        containerScheme.colorScheme.primaryColor = color
        // Customize containerScheme here...
        return containerScheme
    }
    
    private func setDatePicker() {
        
        // ピッカー設定
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        dateFiled.inputView = datePicker
        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        // インプットビュー設定(紐づいているUITextfieldへ代入)
        dateFiled.inputView = datePicker
        dateFiled.inputAccessoryView = toolbar
    }
    
    @objc private func done() {
        dateFiled.endEditing(true)
        
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        print(formatter.string(from: Date()))
        
        //(from: datePicker.date))を指定してあげることで
        //datePickerで指定した日付が表示される
        inputDate = datePicker.date
        dateFiled.text = "\(formatter.string(from: datePicker.date))"
        
    }
    
    /// 故人のidリストの取得
    private func loadPersonsId () -> [String] {
        if let personIds = userDefaults.array(forKey: "personId") {
            return personIds as! [String]
        } else {
            return []
        }
    }
    
}

extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if nameField.text == "" {
            return true
        }
        
        setButton(elevationValue: 6, color: UIColor(hex: "F9796E"))
        return true
    }
    
}
