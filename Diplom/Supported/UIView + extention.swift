//
//  UIView + extention.swift
//  Diplom
//
//  Created by Кирилл on 19.11.2021.
//

import UIKit

extension UIView {
    
    public func addSubviews(_ views: [UIView]) {
        views.forEach { view in
            addSubview(view)
        }
    }
}
