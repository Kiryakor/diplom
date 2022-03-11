//
//  PHPhotosService.swift
//  Diplom
//
//  Created by KIRILL on 08.03.2022.
//

import Photos
import UIKit

final class PHPhotosService: NSObject {
    
    static func getFetchPhotos(count: Int, complition: @escaping (Result<[UIImage], Error>) -> Void) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        fetchOptions.fetchLimit = count
        
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        
        if fetchResult.count > 0 {
            let totalImageCountNeeded = count
            fetchPhotoAtIndex(0, totalImageCountNeeded, fetchResult, complition: { result in
                switch result {
                case .success(let image):
                    complition(.success([image]))
                case .failure(let error):
                    complition(.failure(error))
                }
            })
        }
    }
    
    // когда-нибудь переделать, чтобы работало при запросе больше 1 фотке !
    static private func fetchPhotoAtIndex(_ index:Int,
                                          _ totalImageCountNeeded: Int,
                                          _ fetchResult: PHFetchResult<PHAsset>,
                                          complition: @escaping (Result<UIImage, Error>) -> Void) {
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        PHImageManager.default().requestImage(for: fetchResult.object(at: index) as PHAsset,
                                                 targetSize: CGSize(width: 250, height: 250),
                                                 contentMode: .aspectFill,
                                                 options: requestOptions,
                                                 resultHandler: { (image, _) in
            if let image = image {
                complition(.success(image))
            }
        })
    }
}
