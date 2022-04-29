//
//  AnswerPanelView.swift
//  Diplom
//
//  Created by Кирилл on 19.11.2021.
//

import UIKit

class BottomPanelView: UIView {
    
    private enum Constants {
        static let buttonRadius: CGFloat = 5
        static let buttonSpacing: CGFloat = 16
        static let buttonWidth: CGFloat = 100
        static let titleSpacing: CGFloat = 8
        
        static let panelHeight: CGFloat = 100 // toDo высчитывать от контента
        
        static let gallarySize: CGFloat = 35
    }
    
    private let doneButton: UIButton = {
        let view = UIButton()
        view.setTitle("Инфо блок".localized, for: .normal)
        view.titleLabel?.textAlignment = .center
        view.titleLabel?.textColor = AppColor.textColor
        view.layer.cornerRadius = Constants.buttonRadius
        view.clipsToBounds = true
        view.backgroundColor = AppColor.greenColor
        view.addTarget(self, action: #selector(tapDoneButton), for: .touchUpInside)
        return view
    }()
    
    private let cancelButton: UIButton = {
        let view = UIButton()
        view.setTitle("Cancel".localized, for: .normal)
        view.titleLabel?.textAlignment = .center
        view.titleLabel?.textColor = AppColor.textColor
        view.layer.cornerRadius = Constants.buttonRadius
        view.backgroundColor = AppColor.redColor
        view.clipsToBounds = true
        view.addTarget(self, action: #selector(tapCancelButton), for: .touchUpInside)
        return view
    }()
    
    private let answerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = AppColor.textColor
        label.textAlignment = .center
        return label
    }()
    
    private let gallaryButton: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = Constants.gallarySize / 2
        view.clipsToBounds = true
        view.backgroundColor = .red
        view.addTarget(self, action: #selector(tapGallaryButton), for: .touchUpInside)
        return view
    }()
    
    // MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)

        self.setupUI()
        
        PHPhotosService.getFetchPhotos(count: 1) { [weak self] result in
            switch result {
            case .success(let images):
                guard let image = images.first else { return }
                self?.gallaryButton.setImage(image, for: .normal)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    var title: String? {
        get {
            return self.answerLabel.text
        }
        set {
            self.answerLabel.text = newValue
        }
    }
    
    var cancelAction: (() -> Void)?
    var doneAction: (() -> Void)?
    var gallaryAction: (() -> Void)?
    
    static func estimateHeight() -> CGFloat {
        return Constants.panelHeight
    }
    
    // MARK: - Private
    
    private func setupUI() {
        self.backgroundColor = AppColor.backgroundColor
        
        self.addSubviews([
            self.answerLabel,
            self.doneButton,
            self.cancelButton,
            self.gallaryButton,
        ])
        
        self.doneButton.snp.makeConstraints { make in
            make.bottom.equalTo(-Constants.buttonSpacing)
            make.width.equalTo(Constants.buttonWidth)
            make.right.equalTo(snp_centerXWithinMargins).offset(-Constants.buttonSpacing)
        }

        self.cancelButton.snp.makeConstraints { make in
            make.bottom.equalTo(-Constants.buttonSpacing)
            make.width.equalTo(Constants.buttonWidth)
            make.left.equalTo(snp_centerXWithinMargins).offset(Constants.buttonSpacing)
        }
        
        self.answerLabel.snp.makeConstraints { make in
            make.top.left.equalTo(self).offset(Constants.titleSpacing)
            make.right.equalTo(self).offset(-Constants.titleSpacing)
        }
        
        self.gallaryButton.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.gallarySize)
            make.right.bottom.equalTo(-Constants.buttonSpacing)
        }
    }
    
    @objc
    private func tapCancelButton() {
        self.cancelAction?()
    }
    
    @objc
    private func tapDoneButton() {
        self.doneAction?()
    }
    
    @objc
    private func tapGallaryButton() {
        self.gallaryAction?()
    }
    
    func hideGallatyButton() {
        self.gallaryButton.isHidden = true
    }
}
