//
//  ChooseImageViewController.swift
//  Diplom
//
//  Created by KIRILL on 07.03.2022.
//

import UIKit
import CoreML
import AVKit
import Vision
import SnapKit

class ChooseImageViewController: UIViewController {
    
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
    
    private let currentImage: UIImage
    
    init(with image: UIImage) {
        self.currentImage = image
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = AppColor.backgroundColor
        
        self.view.addSubviews([
            imageView,
            answerLabel
        ])
        
        imageView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalTo(self.view)
        }
        
        answerLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self.view)
        }
        
        imageView.image = currentImage
        
        guard let image = currentImage.cgImage else { return }
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
