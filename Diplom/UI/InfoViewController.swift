//
//  InfoViewController.swift
//  Diplom
//
//  Created by KIRILL on 08.03.2022.
//

import UIKit

class InfoViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    let topView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        return view
    }()
    
    let topDarkLine: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 3
        return view
    }()
    
    let infoView: InfoView = {
        let view = InfoView()
        return view
    }()
    
    let simularView: SimularView = {
        let view = SimularView()
        view.isHidden = true
        return view
    }()
    
    let segmentControl: UISegmentedControl = {
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
        self.simularView.title = request
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.backgroundColor
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    func setupViews() {
        view.addSubviews([
            topView,
            segmentControl,
            infoView,
            simularView,
        ])
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        topView.addSubview(topDarkLine)
        topDarkLine.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.height.equalTo(6)
            make.width.equalToSuperview().multipliedBy(0.15)
            make.centerX.equalToSuperview()
        }
        
        segmentControl.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.topView.snp_bottomMargin).offset(-8)
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        topView.addGestureRecognizer(panGesture)
        
        infoView.snp.makeConstraints { make in
            make.left.bottom.right.equalTo(self.view)
            make.top.equalTo(segmentControl.snp_bottomMargin).offset(16)
        }
        
        simularView.snp.makeConstraints { make in
            make.left.bottom.right.equalTo(self.view)
            make.top.equalTo(segmentControl.snp_bottomMargin).offset(16)
        }
    }
    
    @objc
    func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)

        guard translation.y >= 0 else { return }

        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)

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
    func segmentControlAction() {
        let index = self.segmentControl.selectedSegmentIndex
        
        if index == 0 {
            self.infoView.isHidden = false
            self.simularView.isHidden = true
        } else if index == 1 {
            self.simularView.isHidden = false
            self.infoView.isHidden = true
        }
    }
}
