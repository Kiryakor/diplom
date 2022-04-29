//
//  String + extension.swift
//  Diplom
//
//  Created by Кирилл on 20.11.2021.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
