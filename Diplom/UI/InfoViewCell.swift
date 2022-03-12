//
//  InfoViewCell.swift
//  Diplom
//
//  Created by KIRILL on 12.03.2022.
//

import UIKit

class InfoViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    var imageName: String? {
        willSet {
            
            guard let imageName = newValue else {
                self.imageView.image = nil
                return
            }
            
            FirebaseService.requestImage(with: imageName) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.imageView.image = UIImage(data: data)
                case .failure:
                    self?.imageView.image = nil
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.addSubviews([imageView])
        
        self.imageView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
