//
//  AnswerPanelView.swift
//  Diplom
//
//  Created by Кирилл on 19.11.2021.
//

import UIKit

class AnswerPanelView: UIView {
    
    private enum Constants {
        static let buttonRadius: CGFloat = 5
        static let buttonSpacing: CGFloat = 16
        static let buttonWidth: CGFloat = 100
        static let titleSpacing: CGFloat = 8
        
        static let panelHeight: CGFloat = 100 // toDo высчитывать от контента
    }
    
    private let doneButton: UIButton = {
        let view = UIButton()
        view.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
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
        view.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
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
    
    // MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = AppColor.backgroundColorColor
        self.setupUI()
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
    
    static func estimateHeight() -> CGFloat {
        return Constants.panelHeight
    }
    
    // MARK: - Private
    
    private func setupUI() {
        
        addSubviews([
            answerLabel,
            doneButton,
            cancelButton,
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
            make.top.left.right.equalTo(self).offset(Constants.titleSpacing)
            make.right.equalTo(self).offset(-Constants.titleSpacing)
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
}
