//
//  InfoViewController.swift
//  Diplom
//
//  Created by KIRILL on 08.03.2022.
//

import UIKit
import ScrollableSegmentedControl

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
    
    private let segmentsScrollView: ScrollableSegmentedControl = {
        let segmentsScrollView = ScrollableSegmentedControl(frame: .zero)
        segmentsScrollView.segmentStyle = .textOnly
        segmentsScrollView.insertSegment(withTitle: "IMAGE_INFO".localized, at: 0)
        segmentsScrollView.insertSegment(withTitle: "SIMULAR_PHOTO".localized, at: 1)
        segmentsScrollView.insertSegment(withTitle: "AUDIO_INFO".localized, at: 2)
        segmentsScrollView.selectedSegmentIndex = 0
        segmentsScrollView.underlineSelected = true
        segmentsScrollView.fixedSegmentWidth = false
        segmentsScrollView.addTarget(self, action: #selector(segmentControlAction), for: .valueChanged)
        return segmentsScrollView
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
            self.segmentsScrollView,
            self.infoView,
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
        
        self.segmentsScrollView.snp.makeConstraints { make in
            make.top.equalTo(self.topView.snp_bottomMargin).offset(-8)
            make.height.equalTo(44)
            make.left.right.equalTo(self.view)
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureRecognizerAction))
        self.topView.addGestureRecognizer(panGesture)
        
        self.simularView.snp.makeConstraints { make in
            make.left.bottom.right.equalTo(self.view)
            make.top.equalTo(segmentsScrollView.snp_bottomMargin).offset(16)
        }
        
        self.infoView.snp.makeConstraints { make in
            make.left.bottom.right.equalTo(self.view)
            make.top.equalTo(segmentsScrollView.snp_bottomMargin).offset(16)
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
        let index = self.segmentsScrollView.selectedSegmentIndex
        
        if index == 0 {
            self.simularView.isHidden = false
            self.infoView.isHidden = true
        } else if index == 2 {
            self.simularView.isHidden = true
            self.infoView.isHidden = true
            
            let alert = UIAlertController(title: nil, message: "В процессе разработки", preferredStyle: .actionSheet)
            let cancelAction =  UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
//            toDo запилить
//            import AVKit
//            let synthesizer = AVSpeechSynthesizer()
//            let utterance = AVSpeechUtterance(string: "Привет. Это пример.")
//            utterance.voice = AVSpeechSynthesisVoice(language: "ru-RU")
//            synthesizer.speak(utterance)
        }
    }
}
