//
//  AnswerPanelView.swift
//  Diplom
//
//  Created by Кирилл on 19.11.2021.
//

import UIKit
import Photos

class AnswerPanelView: UIView {
    
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
        view.setTitle("Done".localized, for: .normal)
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

        setupUI()
        self.fetchPhotos()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    var title: String? {
        get {
            return answerLabel.text
        }
        set {
            answerLabel.text = newValue
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
        backgroundColor = AppColor.backgroundColor
        
        addSubviews([
            answerLabel,
            doneButton,
            cancelButton,
            gallaryButton,
        ])
        
        doneButton.snp.makeConstraints { make in
            make.bottom.equalTo(-Constants.buttonSpacing)
            make.width.equalTo(Constants.buttonWidth)
            make.right.equalTo(snp_centerXWithinMargins).offset(-Constants.buttonSpacing)
        }

        cancelButton.snp.makeConstraints { make in
            make.bottom.equalTo(-Constants.buttonSpacing)
            make.width.equalTo(Constants.buttonWidth)
            make.left.equalTo(snp_centerXWithinMargins).offset(Constants.buttonSpacing)
        }
        
        answerLabel.snp.makeConstraints { make in
            make.top.left.equalTo(self).offset(Constants.titleSpacing)
            make.right.equalTo(self).offset(-Constants.titleSpacing)
        }
        
        gallaryButton.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.gallarySize)
            make.right.bottom.equalTo(-Constants.buttonSpacing)
        }
    }
    
    @objc
    private func tapCancelButton() {
        cancelAction?()
    }
    
    @objc
    private func tapDoneButton() {
        doneAction?()
    }
    
    @objc
    private func tapGallaryButton() {
        gallaryAction?()
    }
}

private extension AnswerPanelView {
    // toDo вынесли отдельно и запращивать нужное кол-во фото или всё
    func fetchPhotos () {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1
        
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        
        if fetchResult.count > 0 {
            let totalImageCountNeeded = 1
            fetchPhotoAtIndex(0, totalImageCountNeeded, fetchResult)
        }
    }
    
    func fetchPhotoAtIndex(_ index:Int,
                           _ totalImageCountNeeded: Int,
                           _ fetchResult: PHFetchResult<PHAsset>) {
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        PHImageManager.default().requestImage(for: fetchResult.object(at: index) as PHAsset,
                                                 targetSize: self.frame.size,
                                                 contentMode: PHImageContentMode.aspectFill,
                                                 options: requestOptions,
                                                 resultHandler: { (image, _) in
            if let image = image {
                // Add the returned image to your array
                self.gallaryButton.setImage(image, for: .normal)
            }
        })
    }
}
