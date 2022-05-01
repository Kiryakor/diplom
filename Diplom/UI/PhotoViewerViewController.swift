//
//  PhotoViewerViewController.swift
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
    
    private let answerPanelView: BottomPanelView = {
        let view = BottomPanelView()
        return view
    }()
    
    var currentImage: UIImage? {
        willSet {
            self.imageView.image = newValue
            
            guard let image = newValue?.cgImage else { return }
            DiplomMLService.request(with: .image(image)) { [weak self] result in
                switch result {
                case .success(let value):
                    self?.answerPanelView.title = value
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
            self.answerPanelView,
        ])
        
        self.imageView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalTo(self.view)
        }
        
        self.answerPanelView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.height.equalTo(BottomPanelView.estimateHeight())
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        self.answerPanelView.hideGallatyButton()
        
        self.answerPanelView.doneAction = { [weak self] in
            guard let self = self else { return }
            
            let filterVC = InfoViewController(with: self.answerPanelView.title ?? "")
            filterVC.modalPresentationStyle = .custom
            filterVC.transitioningDelegate = self
            self.present(filterVC, animated: true, completion: nil)
        }
    }
}

extension PhotoViewerViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        FilterPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
