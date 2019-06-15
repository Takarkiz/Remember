//
//  FirestoreRegistration.swift
//  ReMember
//
//  Created by 澤田昂明 on 2019/06/15.
//  Copyright © 2019 澤田昂明. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

// Firestoreでの故人の登録読み込み
class FirestoreResistration {
    
    let db = Firestore.firestore()
    
    init() {
        
    }
    
    // Firestoreに故人の基本情報を登録
    func resisterNewPerson(name: String, date: Date, image: UIImage?, completion: @escaping () -> Void) {
        let personId: String = UUID().uuidString
        profPhotoUpload(id: personId, image: image) {(imageUrl) in
            self.db.collection("Person").document(personId).setData([
                "name": name,
                "date": date,
                "image": imageUrl
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    completion()
                }
            }
        }
    }
    
    // IDから故人の情報を取得する
    func getPerson(id: String, completion: @escaping (Result<Person, Error>) -> Void){
        let docRef = db.collection("Person").document(id)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let docDic = document.data() else { return }
                self.dicToPerson(dic: docDic){ (result) in
                    switch result{
                    case .success(let value):
                        completion(Result.success(value))
                    case .failure(let error):
                        completion(Result.failure(error))
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    // Private
    /// 写真のfirestorageへのアップロード
    private func profPhotoUpload(id: String, image: UIImage?, completion: @escaping (String) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: "gs://remember-4ec53.appspot.com")
        guard let img = image else { return }
        if let data: Data = UIImage.pngData(img)() {
            let imageUrl = "image/" + id + "/profImage" + ".jpg"
            let reference = storageRef.child(imageUrl)
            reference.putData(data, metadata: nil, completion: { metaData, error in
                // ユーザー画像のurlを渡す
                completion(imageUrl)
            })
        }
    }
    
    // 画像の取得
    func getPhoto(imageUrl: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let storage = Storage.storage()
        
        // Create a reference from a Google Cloud Storage URI
        let storageRef = storage.reference(forURL: "gs://remember-4ec53.appspot.com")
        let profImageRef = storageRef.child(imageUrl)
        profImageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                completion(Result.failure(error))
            } else {
                // Data for "images/island.jpg" is returned
                if let image: UIImage = UIImage(data: data!){
                    completion(Result.success(image))
                }
            }
        }
    }
    
    private func dicToPerson(dic: [String: Any], completion: @escaping (Result<Person, Error>) -> Void){
        let userName: String = dic["name"] as! String
        let date: Date = (dic["date"] as! Timestamp).dateValue()
        let imageUrl: String = dic["image"] as! String
        
        getPhoto(imageUrl: imageUrl) { (result) in
            switch result{
            case .success(let value):
                let person = Person(name: userName, date: date, image: value)
                completion(Result.success(person))
                break
            case .failure(let error):
                completion(Result.failure(error))
                break
            }
        }
        
    }
}
