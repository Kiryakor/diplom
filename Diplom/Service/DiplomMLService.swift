//
//  CoreMLService.swift
//  Diplom
//
//  Created by KIRILL on 07.03.2022.
//

import CoreML
import AVKit
import Vision

final class DiplomMLService: NSObject {
    
    enum Errors: Error {
        case model
        case parse
    }
    
    enum ContentType {
        case image(CGImage)
        case imageBuffer(CVImageBuffer)
    }
    
    static func request(with contentType: ContentType,
                        complition: @escaping (Result<String, Errors>) -> Void) {
        let config = MLModelConfiguration()
        guard let model = try? VNCoreMLModel(for: DiplomML(configuration: config).model) else {
            complition(.failure(.model))
            return
        }
        
        let reques = VNCoreMLRequest(model: model) { request, _ in
            guard
                let results = request.results as? [VNClassificationObservation],
                let resultItem = results.first,
                let result = resultItem.identifier.split(separator: ",").first
            else {
                complition(.failure(.parse))
                return
            }
            
            DispatchQueue.main.async {
                complition(.success(String(result)))
            }
        }
        
        switch contentType {
        case .image(let image):
            try? VNImageRequestHandler(cgImage: image, options: [:]).perform([reques])
        case .imageBuffer(let imageBuffer):
            try? VNImageRequestHandler(cvPixelBuffer: imageBuffer, options: [:]).perform([reques])
        }
    }
}

