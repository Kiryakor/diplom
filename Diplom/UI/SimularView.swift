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
    
    private let infoLabel: UITextView = {
        let label = UITextView()
        return label
    }()
    
    var title: String? {
        willSet {
            self.titleLabel.text = newValue
            
            guard let newValue = newValue else {
                self.infoLabel.text = nil
                return
            }
            
            guard !newValue.isEmpty else { return }
            
            FirebaseService.request(with: newValue) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let snapshot):
                    self.infoLabel.text = snapshot.value as? String
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        self.addSubviews([
            titleLabel,
            infoLabel,
        ])
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(titleLabel.font.lineHeight)
            make.top.equalTo(self).offset(8)
            make.left.right.equalTo(self).inset(8)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(8)
            make.left.bottom.right.equalTo(self).inset(8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
