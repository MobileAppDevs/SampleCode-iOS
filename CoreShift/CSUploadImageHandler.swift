
import UIKit
import Alamofire
import SDWebImage

class CSUploadImageHandler: NSObject {
    
    var completionHandler: ((String) -> ())?
    var chooseViewImageHandler: (() -> ())?

    
    let picker = UIImagePickerController()

    var controller : UIViewController!

    func performImageUploadingOnController(controller : UIViewController, viewImageOption : Bool) {
        
            // when done, call the completion handler
        self.controller = controller
        
        openOptionPickerOn(viewImageOption: viewImageOption)

    }
    
    
    func openOptionPickerOn(viewImageOption : Bool)
    {
        let alert: UIAlertController = UIAlertController(title: Bundle.main.infoDictionary!["CFBundleName"] as? String, message:"Choose Image option", preferredStyle: .actionSheet)
        
        if(viewImageOption){
            
            //Create and add first option action
            let viewAction: UIAlertAction = UIAlertAction(title: "View Image", style: .default) { action -> Void in
                //Code for action here
                //self.viewImage(imageview: imageview)
                self.chooseViewImageHandler!()
            }
            alert.addAction(viewAction)

        }
        
        //Create and add first option action
        let cameraAction: UIAlertAction = UIAlertAction(title: "Camera", style: .default) { action -> Void in
            //Code for action here
            self.openCamera()
        }
        alert.addAction(cameraAction)
        
        //Create and add first option action
        let galleryAction: UIAlertAction = UIAlertAction(title: "Photo Gallery", style: .default) { action -> Void in
            //Code for action here
            self.openGallery()
        }
        alert.addAction(galleryAction)
        
        //Create and add first option action
        let CancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Code for action here
        }
        alert.addAction(CancelAction)
        
        controller.present(alert, animated: true, completion: nil)
        
    }
    
    
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.delegate = self

            picker.modalPresentationStyle = .fullScreen
            controller.present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }
    
    func openGallery()
    {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.delegate = self

        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        controller.present(picker, animated: true, completion: nil)
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        controller.present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    
    
    func uploadImageToServer(image : UIImage)
    {
        let hud = CSUtility().startProgressIndicator(sender: self.controller, andMessage: "Uploading...")
        
        let URL = "http://demo2.ongraph.com/demo/coreshift/api/uploadimage"
        
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData!, withName: "upload_image", fileName: "file.jpeg", mimeType: "image/jpeg")
        }, to: URL)
        { (result) in
            //
            
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress { progress in
                    
                    print("completed : \(progress.fractionCompleted) ")
                    hud.progress = Float(progress.fractionCompleted)
                }
                
                upload.responseJSON { response in
                    debugPrint(response)
                    
                    if let responseData  = response.result.value as? NSDictionary
                    {
                        print(responseData)
                        print(responseData.object(forKey: "success")!)
                        
                        
                        if(responseData.object(forKey: "success") as! Int == 1)
                        {
                            let fileData = responseData.object(forKey: "data") as! NSDictionary
                            
                            SDImageCache.shared().store(image, forKey: fileData.object(forKey: "file_url") as! String)
                           
                            
                            CSUtility().stopActivityIndicator(sender: self.controller)
                            
                            self.completionHandler?(fileData.object(forKey: "file_url") as! String)

                            
                        }
                        
                    }
                    
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
        
    }

}

extension CSUploadImageHandler : UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        
        self.uploadImageToServer(image: chosenImage)
        controller.dismiss(animated:true, completion: nil) //5
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        controller.dismiss(animated: true, completion: nil)
        
    }
}

