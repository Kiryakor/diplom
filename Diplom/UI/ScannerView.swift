//
//  ScannerView.swift
//  Diplom
//
//  Created by Кирилл on 25.12.2021.
//

import UIKit

class ScannerView: UIView {
    
    private enum Constants {
        static let imageSize: CGFloat = 24
        static let contentOffset: CGFloat = 12
    }

    private let imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    var image: UIImage? {
        set {
            self.imageView.image = newValue
        }
        get {
            return self.imageView.image
        }
    }
    
    var title: String? {
        set {
            self.titleLabel.text = newValue
        }
        get {
            return self.titleLabel.text
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.saveGState()
        defer { context.restoreGState() }
        
//        let rectTopLeft = CGRect(x: 0, y: 0, width: 32, height: 32)
//        let path = UIBezierPath(
//            roundedRect: rectTopLeft,
//            byRoundingCorners: [.topLeft, .topRight],
//            cornerRadii: CGSize(width: 4, height: 4)
//        )
        
//        context.addPath(path.cgPath)
//        context.closePath()
    
//        context.setLineWidth(5)
//        context.setStrokeColor(AppColor.white)
        context.strokePath()
    }
    
    // MARK: - Private
    
    private func setupLayout() {
        self.addSubviews([
            self.imageView,
            self.titleLabel,
        ])
        
        self.imageView.snp.makeConstraints { make in
            make.centerY.equalTo(self).offset(-Constants.contentOffset)
            make.height.width.equalTo(Constants.imageSize)
            make.centerX.equalTo(self)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self).offset(Constants.contentOffset)
            make.centerX.equalTo(self)
            make.left.right.equalTo(self).inset(Constants.contentOffset)
        }
    }
}
