//
//  AddViewController.swift
//  ReMember
//
//  Created by 吉川莉央 on 2019/06/16.
//  Copyright © 2019 澤田昂明. All rights reserved.
//

import UIKit
import Lottie
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_Theming

class AddViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNmaeLabel: UILabel!
    @IBOutlet var userDeathDateLabel: UILabel!
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var photoUplocadButton: MDCButton!
    @IBOutlet var comformButton: MDCButton!
    @IBOutlet var memoryImageView: UIImageView!
    @IBOutlet var loadingAnimationView: AnimationView!
    
    var userId: String!
    let registration = FirestoreResistration()
    
    private var memoryImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupButton()
        contentTextView.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.contentTextView.isFirstResponder {
            self.contentTextView.resignFirstResponder()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
            pickerView.delegate = self
            // ビューに表示
            self.present(pickerView, animated: true)
        }
    }
    
    @IBAction func willPostMemoery() {
        guard let img = memoryImage else { return }
        startLoadingAnimation()
        if contentTextView.text != "" {
            guard let text = contentTextView.text else { return  }
            let storePost = FirestorePost(roomId: userId)
            storePost.postMemory(content: text, image: img) {
                self.loadingAnimationView.stop()
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    private func globalScheme(color: UIColor) -> MDCContainerScheme {
        let containerScheme = MDCContainerScheme()
        containerScheme.shapeScheme = MDCShapeScheme()
        containerScheme.colorScheme.primaryColor = color
        // Customize containerScheme here...
        return containerScheme
    }
    
    private func setupButton() {
        photoUplocadButton.setElevation(ShadowElevation(rawValue: 6), for: .normal)
        comformButton.setElevation(ShadowElevation(rawValue: 6), for: .normal)
        
        photoUplocadButton.applyContainedTheme(withScheme: globalScheme(color: UIColor(hex: "6A6A6A")))
        comformButton.applyContainedTheme(withScheme: globalScheme(color: UIColor(hex: "B2B2B2")))
    }
    
    @IBAction func back(){
        dismiss(animated: true, completion: nil)
    }
    
    private func setUserProf() {
        guard let userId = userId else { return }
        
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
    
    private func startLoadingAnimation() {
        loadingAnimationView.animation = Animation.named("animation-w400-h300")
        loadingAnimationView.loopMode = .loop
        loadingAnimationView.play()
    }
}

extension AddViewController: UIImagePickerControllerDelegate {
    // 写真を選んだ後に呼ばれる処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 選択した写真を取得する
        let image = info[.editedImage] as! UIImage
        // ビューに表示する
        memoryImage = image
        photoUplocadButton.isHidden = true
        memoryImageView.image = memoryImage
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
    }
}

extension AddViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == "" {
            comformButton.applyContainedTheme(withScheme: globalScheme(color: UIColor(hex: "B2B2B2")))
        } else {
            comformButton.applyContainedTheme(withScheme: globalScheme(color: UIColor(hex: "F9796E")))
        }
        return true
    }
}
