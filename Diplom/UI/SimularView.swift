//
//  SimularView.swift
//  Diplom
//
//  Created by KIRILL on 11.03.2022.
//

import UIKit

class SimularView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private let infoTextView: UITextView = {
        let label = UITextView()
        label.isEditable = false
        return label
    }()
    
    var title: String? {
        willSet {
            self.titleLabel.text = newValue
            
            guard let newValue = newValue else {
                self.infoTextView.text = nil
                return
            }
            
            guard !newValue.isEmpty else { return }
            
            FirebaseService.request(with: newValue) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let description):
                    self.infoTextView.text = "\t\(description?.capitalized ?? "")"
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
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
