//
//  FirebaseService.swift
//  Diplom
//
//  Created by KIRILL on 11.03.2022.
//

import FirebaseDatabase
import UIKit

final class FirebaseService: NSObject {

    static func request(with value: String, complition: @escaping (Result<String?, Error>) -> Void) {
        let ref = Database.database().reference()
        
//        ref.setValue([value: "является крупнейшим православным храмом города Санкт-Петербурга, которому присвоен статус музея. При этом церковная община, которая была зарегистрирована летом 1991 года, имеет право совершать богослужение по определенным дням с разрешения дирекции музея."])
        
        ref.child(value).getData { error, snapshot in
            if let error = error {
                complition(.failure(error))
            }
            
            let description = Self.parse(with: snapshot)
            complition(.success(description))
        }
    }
    
    private static func parse(with snapshot: DataSnapshot) -> String? {
        return snapshot.value as? String
    }
}
