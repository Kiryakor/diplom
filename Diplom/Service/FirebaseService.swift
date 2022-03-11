//
//  FirebaseService.swift
//  Diplom
//
//  Created by KIRILL on 11.03.2022.
//

import FirebaseDatabase
import UIKit

final class FirebaseService: NSObject {

    static func request(with value: String, complition: @escaping (Result<DataSnapshot, Error>) -> Void) {
        let ref = Database.database().reference()
        ref.child(value).getData { error, snapshot in
            if let error = error {
                complition(.failure(error))
            }
            
            complition(.success(snapshot))
        }
    }
    
    private static func parse(with snapshot: DataSnapshot) {
    }
}
