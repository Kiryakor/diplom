//
//  ViewController.swift
//  Diplom
//
//  Created by Кирилл on 18.11.2021.
//

import UIKit
import CoreML
import AVKit
import Vision
import SnapKit

class LiveCameraViewController: UIViewController {
    
    private enum Constants {
        static let scannerViewOffset: CGFloat = 8
    }
    
    private let answerPanelView: BottomPanelView = {
        let view = BottomPanelView()
        return view
    }()
    
    private let scannerView: ScannerView = {
        let view = ScannerView()
        return view
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = AppColor.backgroundColor
        
#if !targetEnvironment(simulator)
        setupLiveCamera()
#endif
        
        setupAnswerPanelView()
        setupScannerView()
    }
    
    private func setupLiveCamera() {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard
            let captureDevice = AVCaptureDevice.default(for: .video),
            let input = try? AVCaptureDeviceInput(device: captureDevice)
        else { return }
    
        
        captureSession.addInput(input)
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
    }
    
    private func setupAnswerPanelView() {
        view.addSubview(answerPanelView)
        
        self.answerPanelView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.height.equalTo(BottomPanelView.estimateHeight())
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        self.answerPanelView.doneAction = { [weak self] in
            guard let self = self else { return }
            
            let filterVC = InfoViewController(with: self.answerPanelView.title ?? "")
            filterVC.modalPresentationStyle = .custom
            filterVC.transitioningDelegate = self
            self.present(filterVC, animated: true, completion: nil)
        }
        
        self.answerPanelView.gallaryAction = { [weak self] in
            guard let self = self else { return }
            self.showImagePicker()
        }
    }
    
    private func setupScannerView() {
        view.addSubview(scannerView)
        
        let size = view.bounds.width - 2 * Constants.scannerViewOffset
        scannerView.snp.makeConstraints { make in
            make.width.height.equalTo(size)
            make.centerX.centerY.equalTo(view)
        }
        
        scannerView.title = "CAMERA".localized
        scannerView.image = AppImage.cameraIcon
    }
}

extension LiveCameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        DiplomMLService.request(with: .imageBuffer(pixelBuffer)) { [weak self] result in
            switch result {
            case .success(let value):
                self?.answerPanelView.title = value
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension LiveCameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[.editedImage] as? UIImage {
            picker.dismiss(animated: true, completion: nil)
            let view = PhotoViewerViewController(with: image)
            self.present(view, animated: true, completion: nil)
        } else {
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    private func showImagePicker() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true)
    }
}

extension LiveCameraViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        FilterPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
