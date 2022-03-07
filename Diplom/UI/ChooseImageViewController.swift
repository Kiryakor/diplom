//
//  ChooseImageViewController.swift
//  Diplom
//
//  Created by KIRILL on 07.03.2022.
//

import Foundation
import UIKit
import Vision

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
        
        let config = MLModelConfiguration()
        guard let model = try? VNCoreMLModel(for: DiplomML(configuration: config).model) else { return }
        
        let reques = VNCoreMLRequest(model: model) { request, error in
            guard
                let results = request.results as? [VNClassificationObservation],
                let result = results.first
            else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard
                    let self = self,
                    let result = result.identifier.split(separator: ",").first
                else { return }
                
                self.answerLabel.text = "\(result)"
            }
        }
        
        try? VNImageRequestHandler(cgImage: self.currentImage.cgImage!, options: [:]).perform([reques])
    }
}
