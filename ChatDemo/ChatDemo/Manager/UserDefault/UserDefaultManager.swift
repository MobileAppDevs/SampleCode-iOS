//
//  UserDefaultManager.swift
//  Nibou
//
//  Created by Ongraph on 5/8/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation

class UserDefaultManager{
    
    static let sharedInstance = UserDefaultManager()
    
    let kProfileData            = "UserProfileData"
    let kUserID                 = "User_Id"

    //MARK: - Profile Data
    /**
     MARK: - Set Profile Data
     */
    func setUserProfileModel(model: UserProfileModel){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(model) {
            Constants.kUserDefault.set(encoded, forKey: kProfileData)
            Constants.kUserDefault.synchronize()
        }
    }

    /**
     MARK: - Get Profile Data
     - Returns: Profile Data
     */
    func getUserProfileModel() -> UserProfileModel?{

        if let data = Constants.kUserDefault.object(forKey: kProfileData) as? Data {
            let decoder = JSONDecoder()
            if let model = try? decoder.decode(UserProfileModel.self, from: data) {
                return model
            }else{
                return nil
            }
        }else{
            return nil
        }
    }

    
    func setuserID(id: String){
        Constants.kUserDefault.setValue(id, forKey: kUserID)
        Constants.kUserDefault.synchronize()
    }
    
    func getUserId() -> String{
        if let strToken = Constants.kUserDefault.object(forKey: kUserID) {
            return strToken as! String
        }
        return ""
    }

    
    //MARK: - Clear All Defaults
    func clearUserDefault(){
        Constants.kUserDefault.removeObject(forKey: kProfileData)
        Constants.kUserDefault.removeObject(forKey: kUserID)
        Constants.kUserDefault.synchronize()
    }

    
}

