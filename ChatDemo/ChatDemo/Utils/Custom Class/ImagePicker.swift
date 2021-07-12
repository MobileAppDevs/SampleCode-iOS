//
//  ImagePicker.swift
//  SuperCarsMajlis
//
//  Created by Himanshu Goyal on 02/10/19.
//  Copyright © 2019 Ongraph Technologies Private Limited. All rights reserved.
//

import Foundation
import UIKit
import Photos

class ImagePicker: UIViewController {
    
    /*
     MARK: - Properties
     */
    var imagePicker                     : UIImagePickerController   = UIImagePickerController()
    private var imageCompletionBlock    : CompletionBlock!
    internal typealias CompletionBlock  = (_ image : UIImage, _ imageName: String) -> Void
    static let sharedInstance           : ImagePicker = ImagePicker()
    //end
    
    
    class func openImagePicker(completionHandler: @escaping CompletionBlock) {
        ImagePicker.sharedInstance.imageCompletionBlock = completionHandler
        ImagePicker.sharedInstance.openPicker(completionBlock: completionHandler)
    }
    
    private func openPicker(completionBlock: ((UIImage, String) -> Void)?){
        self.presentPicker()
    }
    
    
}

/*
 MARK: - ImagePicker- UIImagePickerControllerDelegate, UINavigationControllerDelegate
*/
extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func presentPicker(){
        self.checkPermission()
        let alert: UIAlertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "CAMERA", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "GALLERY", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        self.imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.view
        
        guard let rootVC = Constants.kAppDelegate.window?.rootViewController else {
            return
        }
        
//        guard let rootVC = UIApplication.shared.windows.first?.rootViewController else{
//            return
//        }
        rootVC.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Open Camera
    private func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
            
            guard let rootVC = Constants.kAppDelegate.window?.rootViewController else {
                return
            }
            
//            guard let rootVC = UIApplication.shared.windows.first?.rootViewController else{
//                return
//            }
            rootVC.present(self.imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            guard let rootVC = Constants.kAppDelegate.window?.rootViewController else {
                return
            }
            
//            guard let rootVC = UIApplication.shared.windows.first?.rootViewController else{
//                return
//            }
            rootVC.present(alert, animated: true, completion: nil)
        }
    }
    //end
    
    //MARK: - Open Gallary
    private func openGallary()
    {
        self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        guard let rootVC = Constants.kAppDelegate.window?.rootViewController else {
            return
        }
        
//        guard let rootVC = UIApplication.shared.windows.first?.rootViewController else{
//            return
//        }
        rootVC.present(self.imagePicker, animated: true, completion: nil)
    }
    //end
    
    
    private func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        default:
            print("")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        
        
        guard let image = info[.originalImage] as? UIImage else {
            return picker.dismiss(animated: true, completion: nil)
        }
        
        guard let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset else{
            picker.dismiss(animated: true) {
                self.imageCompletionBlock(image, "camera_image.png")
            }
            return
        }
        
        guard let imageName = asset.value(forKey: "filename") as? String else {
            return
        }
        
        picker.dismiss(animated: true) {
            self.imageCompletionBlock(image, imageName)
        }
    }
}
