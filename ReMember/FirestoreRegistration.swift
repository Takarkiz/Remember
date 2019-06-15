//
//  FirestoreRegistration.swift
//  ReMember
//
//  Created by 澤田昂明 on 2019/06/15.
//  Copyright © 2019 澤田昂明. All rights reserved.
//

import UIKit
import Firebase

// Firestoreでの故人の登録読み込み
class FirestoreResistration {
    
    private var personId: String
    
    init() {
        personId = ""
    }
    
    // Firestoreに個人の基本情報を登録
    func resisterNewPerson(name: String, date: Date, image: UIImage, completion: () -> Void) {
        
    }
    
    // IDから故人の情報を取得する
    func getPerson() -> Person{
        
    }
}
