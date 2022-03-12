//
//  InfoViewController.swift
//  Diplom
//
//  Created by KIRILL on 08.03.2022.
//

import UIKit

class InfoViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    private let topView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        return view
    }()
    
    private let topDarkLine: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 3
        return view
    }()
    
    private let simularView: SimularView = {
        let view = SimularView()
        return view
    }()
    
    private let infoView: TitleDescriptionView = {
        let view = TitleDescriptionView()
        view.isHidden = true
        return view
    }()
    
    private let segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["IMAGE_INFO".localized, "SIMULAR_PHOTO".localized])
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(segmentControlAction), for: .valueChanged)
        return segment
    }()
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    var request: String
    
    init(with request: String) {
        self.request = request
        self.infoView.title = request
        
        super.init(nibName: nil, bundle: nil)
        
        FirebaseService.request(with: request) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let content):
                self.infoView.infoText = "\t\(content.description?.capitalized ?? "")"
                self.simularView.images = content.images
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppColor.backgroundColor
        self.setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        if !self.hasSetPointOrigin {
            self.hasSetPointOrigin = true
            self.pointOrigin = self.view.frame.origin
        }
    }
    
    private func setupViews() {
        self.view.addSubviews([
            self.topView,
            self.segmentControl,
            self.simularView,
            self.infoView,
        ])
        
        self.topView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        self.topView.addSubview(topDarkLine)
        
        self.topDarkLine.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.height.equalTo(6)
            make.width.equalToSuperview().multipliedBy(0.15)
            make.centerX.equalToSuperview()
        }
        
        self.segmentControl.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.topView.snp_bottomMargin).offset(-8)
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureRecognizerAction))
        self.topView.addGestureRecognizer(panGesture)
        
        self.simularView.snp.makeConstraints { make in
            make.left.bottom.right.equalTo(self.view)
            make.top.equalTo(segmentControl.snp_bottomMargin).offset(16)
        }
        
        self.infoView.snp.makeConstraints { make in
            make.left.bottom.right.equalTo(self.view)
            make.top.equalTo(segmentControl.snp_bottomMargin).offset(16)
        }
    }
    
    @objc
    private func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)

        guard translation.y >= 0 else { return }

        self.view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)

        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
    
    @objc
    private func segmentControlAction() {
        let index = self.segmentControl.selectedSegmentIndex
        
        if index == 0 {
            self.simularView.isHidden = false
            self.infoView.isHidden = true
        } else if index == 1 {
            self.infoView.isHidden = false
            self.simularView.isHidden = true
        }
    }
}
