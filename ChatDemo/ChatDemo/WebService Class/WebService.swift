//
//  WebService.swift
//  City Tour
//
//  Created by Ongraph2018 on 17/10/18.
//  Copyright © 2018 Ongraph. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class WebService: NSObject {
    
    
    func request(parameter:[String:String]?, callType:HTTPMethod,Url:String , isAnimated:Bool, extraVariable:String?,headerParam:[String:String]? ,completion: @escaping (_ result: DataResponse<Any>?,_ errorMessage:String?) -> Void){
        
        
        debugPrint(Url)
        
        let url:String?
        
        if let variaBleUrl = extraVariable{
            
            url = Url + variaBleUrl
        }
        else{
            
            url = Url
        }
        
        debugPrint(parameter)
        debugPrint(" URL : \(String(describing: url))")
        
        Alamofire.request(url!, method:callType, parameters: parameter, encoding: JSONEncoding.default, headers: headerParam).responseJSON {
            response in
            
            
            if let bytes = response.data {
                if let _ = String(bytes: bytes, encoding: .utf8) {
//                    print("openSession response Data is : \(response)")
                }
            }
            
            switch response.result {
            case .success:
                //            let json = response.data
                //            completion(json,nil)
                completion(response,nil)
                break
            case .failure(let error):
                completion(nil,error.localizedDescription)
            }
        }
    }
    
    
}
