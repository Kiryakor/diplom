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
    
    private let answerPanelView: AnswerPanelView = {
        let view = AnswerPanelView()
        return view
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppColor.backgroundColorColor
        setupLiveCamera()
        setupAnswerPanelView()
    }
    
    // MARK: - Private
    
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
        
        answerPanelView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.height.equalTo(AnswerPanelView.estimateHeight())
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        answerPanelView.cancelAction = {
            print("cancelAction")
        }
        
        answerPanelView.doneAction = {
            print("doneAction")
        }
    }
}

extension LiveCameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let config = MLModelConfiguration()
        guard let model = try? VNCoreMLModel(for: SqueezeNet(configuration: config).model) else { return }
        
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
                
                self.answerPanelView.title = "\(result)"
            }
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([reques])
    }
}
