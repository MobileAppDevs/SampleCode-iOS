//
//  SaveService.swift
//  InstaSave
//
//  Created by Vladyslav Yakovlev on 3/1/19.
//  Copyright © 2019 Vladyslav Yakovlev. All rights reserved.
//

import Photos
import UIKit
import Foundation

extension SaveService {
    
    enum Error: LocalizedError {
        
        case accessDenied
        
        case unknown
    }
}

final class SaveService {
    
    static func saveImage(_ image: UIImage, completion: @escaping (Error?) -> ()) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                return DispatchQueue.main.async {
                    completion(.accessDenied)
                }
            }
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { saved, error in
                DispatchQueue.main.async {
                    if saved, error == nil {
                        completion(nil)
                    } else {
                        completion(.unknown)
                    }
                }
            }
        }
    }
    
    static func saveVideo(_ remoteUrl: URL, completion: @escaping (Error?) -> ()) {
        print("remote url >>", remoteUrl)
        
        downloadVideo(with: remoteUrl) { videoUrl in
            guard let videoUrl = videoUrl else {
                return DispatchQueue.main.async {
                    completion(.unknown)
                }
            }
            print("video url >>", videoUrl)

            writeVideoToLibrary(videoUrl) { error in
                completion(error)
            }
        }
    }
        
    private static func writeVideoToLibrary(_ videoUrl: URL, completion: @escaping (Error?) -> ()) {
        PHPhotoLibrary.requestAuthorization { status in
            print("status  >>", status)
            guard status == .authorized else {
                return DispatchQueue.main.async {
                    completion(.accessDenied)
                }
            }
            
            PHPhotoLibrary.shared().performChanges({
                print("videoFileUrl creation path url >>", videoUrl.path)

                print("videoFileUrl creation url >>", videoUrl.absoluteURL)

                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoUrl)

//                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: videoUrl.path))
            }) { saved, error in
                try? FileManager.default.removeItem(at: videoUrl)
                DispatchQueue.main.async {
                    if saved, error == nil {
                        completion(nil)
                    } else {
                        completion(.unknown)
                    }
                }
            }
        }
    }
    
    private static func downloadVideo(with url: URL, completion: @escaping (URL?) -> ()) {
        URLSession.shared.downloadTask(with: url) { url, response, error in
            guard let tempUrl = url, error == nil else {
                return completion(nil)
            }
            let fileManager = FileManager.default
            let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let videoFileUrl = documentsUrl.appendingPathComponent("videoTest.mp4")
            if fileManager.fileExists(atPath: videoFileUrl.path) {
                try? fileManager.removeItem(at: videoFileUrl)
            }
            do {
                try fileManager.moveItem(at: tempUrl, to: videoFileUrl)
                print("videoFileUrl url >>", videoFileUrl)

                completion(videoFileUrl)
            } catch {
                completion(nil)
            }
        }.resume()
    }
}
