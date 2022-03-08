//
//  ChooseImageViewController.swift
//  Diplom
//
//  Created by KIRILL on 07.03.2022.
//

import UIKit
import SnapKit

class PhotoViewerViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let answerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = AppColor.textColor
        label.textAlignment = .center
        return label
    }()
    
    var currentImage: UIImage? {
        willSet {
            self.imageView.image = newValue
            
            guard let image = newValue?.cgImage else { return }
            DiplomMLService.request(with: .image(image)) { [weak self] result in
                switch result {
                case .success(let value):
                    self?.answerLabel.text = value
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    init(with image: UIImage) {
        defer {
            self.currentImage = image
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    private func setupUI() {
        self.view.backgroundColor = AppColor.backgroundColor
        
        self.view.addSubviews([
            self.imageView,
            self.answerLabel,
        ])
        
        self.imageView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalTo(self.view)
        }
        
        self.answerLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottomMargin).offset(-8)
        }
    }
}
