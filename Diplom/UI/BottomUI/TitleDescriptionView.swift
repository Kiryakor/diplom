//
//  SimularView.swift
//  Diplom
//
//  Created by KIRILL on 11.03.2022.
//

import UIKit

class TitleDescriptionView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = AppFont.titleFont
        return label
    }()
    
    private let infoTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.font = AppFont.textFont
        return textView
    }()
    
    var title: String? {
        willSet {
            self.titleLabel.text = newValue
        }
    }
    
    var infoText: String? {
        willSet {
            self.infoTextView.text = newValue
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubviews([
            self.titleLabel,
            self.infoTextView,
        ])
        
        self.titleLabel.snp.makeConstraints { make in
            make.height.equalTo(titleLabel.font.lineHeight)
            make.top.equalTo(self).offset(8)
            make.left.right.equalTo(self).inset(8)
        }
        
        self.infoTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(8)
            make.left.bottom.right.equalTo(self).inset(8)
        }
    }
}
