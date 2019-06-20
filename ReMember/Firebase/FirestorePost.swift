//
//  FirestorePost.swift
//  ReMember
//
//  Created by 澤田昂明 on 2019/06/16.
//  Copyright © 2019 澤田昂明. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

// 投稿関連の投稿
class FirestorePost {
    
    private let id: String
    private let personRef: CollectionReference
    private let db = Firestore.firestore()
    private let photoDownload = FirestoreResistration()
    
    init(roomId: String) {
        self.id = roomId
        personRef = db.collection("Person").document(roomId).collection("Memory")
    }
    
    /// 思い出の投稿
    func postMemory(content: String, image: UIImage?, completion: @escaping () -> Void) {
        getMemoryCount { (count) in
            self.uploadMemoryPhoto(image: image, counter: count) { (fileName, url) in
                self.personRef.document(fileName).setData([
                    "content": content,
                    "image": url]) { error in
                        if let err = error {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                            completion()
                        }
                }
            }
        }
    }
    
    /// 思い出の読み込み
    func readMemory(completion: @escaping ([Memory]) -> Void) {
        personRef.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                return
            }
            let dispatchGroup = DispatchGroup()
            let dispatchQueue = DispatchQueue(label: "queue", attributes: .concurrent)
            var memoryList: [Memory] = []
            documents.forEach { doc in
                dispatchGroup.enter()
                dispatchQueue.async {
                    let contentText = doc["content"] as! String
                    let imageUrl = doc["image"] as! String
                    self.photoDownload.getPhoto(imageUrl: imageUrl) { result in
                        switch result {
                        case .success(let value):
                            
                            let memory = Memory(content: contentText, image: value)
                            memoryList.append(memory)
                            dispatchGroup.leave()
                            
                        case .failure(let err):
                            print("Error fetching document: \(err)")
                            dispatchGroup.leave()
                        }
                    }
                }
            }
            dispatchGroup.notify(queue: .main) {
                completion(memoryList)
            }
        }
    }
    
    // Private
    /// 思い出画像のアップロード
    private func uploadMemoryPhoto(image: UIImage?, counter: Int, completion: @escaping (String, String) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: "gs://remember-4ec53.appspot.com")
        guard let img = image?.reSizeImage(reSize: CGSize(width: 100, height: 100)) else { return }
        if let data: Data = UIImage.pngData(img)() {
            let fileName = "memory" + String(counter)
            let imageUrl = "image/" + id + "/" + fileName + ".jpg"
            let reference = storageRef.child(imageUrl)
            reference.putData(data, metadata: nil, completion: { metaData, error in
                // ユーザー画像のurlを渡す
                completion(fileName, imageUrl)
            })
        }
    }
    
    /// 思い出がいくつ目なのかを取得してくる
    private func getMemoryCount(completion: @escaping (Int) -> Void) {
        let dispatchGroup = DispatchGroup()
        var highestCounter: Int = 0
        personRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for _ in querySnapshot!.documents {
                    dispatchGroup.enter()
                    DispatchQueue.global().async {
                        highestCounter+=1
                        dispatchGroup.leave()
                    }
                }
                
                dispatchGroup.notify(queue: .global()) {
                    completion(highestCounter)
                }
            }
        }
        
    }
    
}
