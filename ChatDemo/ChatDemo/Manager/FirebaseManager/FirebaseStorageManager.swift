//
//  FirebaseStorageManager.swift
//  Trippie
//
//  Created by Himanshu Goyal on 20/12/19.
//  Copyright © 2019 Ongraph Technologies Private Limited. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage


class FirebaseStorageManager {
    
    public func uploadFile(localFile: URL, uid: String, serverFileName: String, completionHandler: @escaping (_ isSuccess: Bool, _ url: String?) -> Void) {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        // Create a reference to the file you want to upload
        let directory = "\(uid)" + "/files" + "/"

//        let directory = "uploads/"
        let fileRef = storageRef.child(directory + serverFileName)

        _ = fileRef.putFile(from: localFile, metadata: nil) { metadata, error in
            fileRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    completionHandler(false, nil)
                    return
                }
                // File Uploaded Successfully
                completionHandler(true, downloadURL.absoluteString)
            }
        }
    }
    
    public func uploadImageDataonfirebaseStorage(data: Data, uid: String , serverFileName: String, completionHandler: @escaping (_ isSuccess: Bool, _ url: String?) -> Void) {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        // Create a reference to the file you want to upload

        let directory = "\(uid)" + "/images" + "/"
        let fileRef = storageRef.child(directory + serverFileName)
        
        let uploadTask = fileRef.putData(data, metadata: nil) { metadata, error in

            fileRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    completionHandler(false, nil)
                    return
                }
                // File Uploaded Successfully
                completionHandler(true, downloadURL.absoluteString)
            }
        }
    }
    
    public func uploadLocationImageDataonfirebaseStorage(data: Data, uid: String , serverFileName: String, completionHandler: @escaping (_ isSuccess: Bool, _ url: String?) -> Void) {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        // Create a reference to the file you want to upload

        let directory = "\(uid)" + "/locations" + "/"
        let fileRef = storageRef.child(directory + serverFileName)
        
        let uploadTask = fileRef.putData(data, metadata: nil) { metadata, error in

            fileRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    completionHandler(false, nil)
                    return
                }
                // File Uploaded Successfully
                completionHandler(true, downloadURL.absoluteString)
            }
        }
    }
    
    public func uploadVideoDataonFirebaseStorage(data: Data, uid: String, fileName: String, completionHandler: @escaping (_ isSuccess: Bool, _ url: String?) -> Void) {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        // Create a reference to the file you want to upload
//        let directory = "video/" + "/"
        let directory = "\(uid)" + "/videos" + "/"

        let fileRef = storageRef.child(directory + fileName)
        
        let uploadTask = fileRef.putData(data, metadata: nil) { metadata, error in

            fileRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    completionHandler(false, nil)
                    return
                }
                // File Uploaded Successfully
                completionHandler(true, downloadURL.absoluteString)
            }
        }
    }
    
    
    public func uploadcontactDataFirebaseStorage(data: Data, uid: String, fileName: String, completionHandler: @escaping (_ isSuccess: Bool, _ url: String?) -> Void) {
            
            let storage = Storage.storage()
            let storageRef = storage.reference()
            // Create a reference to the file you want to upload
    //        let directory = "video/" + "/"
            let directory = "\(uid)" + "/contacts" + "/"

            let fileRef = storageRef.child(directory + fileName)
            
            let uploadTask = fileRef.putData(data, metadata: nil) { metadata, error in

                fileRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        completionHandler(false, nil)
                        return
                    }
                    // File Uploaded Successfully
                    completionHandler(true, downloadURL.absoluteString)
                }
            }
        }

    
}
