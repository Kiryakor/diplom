//
//  FirebaseService.swift
//  Diplom
//
//  Created by KIRILL on 11.03.2022.
//

import FirebaseDatabase
import FirebaseStorage
import UIKit

final class FirebaseService: NSObject {

    enum Errors: Error {
        case data
        case error
    }
    
    static func request(with value: String, complition: @escaping (Result<String?, Errors>) -> Void) {
        let ref = Database.database().reference()
        
//        ref.setValue([value: "является крупнейшим православным храмом города Санкт-Петербурга, которому присвоен статус музея. При этом церковная община, которая была зарегистрирована летом 1991 года, имеет право совершать богослужение по определенным дням с разрешения дирекции музея."])
        
        ref.child(value).getData { error, snapshot in
            if error != nil {
                complition(.failure(.error))
                return
            }
            
            let description = Self.parse(with: snapshot)
            complition(.success(description))
        }
    }
    
    private static func parse(with snapshot: DataSnapshot) -> String? {
        return snapshot.value as? String
    }
    
    static func requestImage(with value: String, complition: @escaping (Result<Data, Errors>) -> Void) {
        let storage = Storage.storage().reference()
        storage.child(value).getData(maxSize: 1 * 1024 * 1024) { snapshot, error in
            if error != nil {
                complition(.failure(.error))
                return
            }
            
            guard let data = snapshot else {
                complition(.failure(.data))
                return
            }
            
            complition(.success(data))
        }
    }
}
