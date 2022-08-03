//
//  UserDetail.swift
//  GoogleLoginDemo
//
//  Created by Sumendra on 18/05/22.
//

import Foundation

struct UserDetail:Codable{
    var id: String
    var name: String
    var email: String
    var image: URL
}
extension UserDetail{
    func saveUserDetails(){
        do {
            let jsonData = try JSONEncoder().encode(self)
            UserDefaults.standard.set(jsonData, forKey: userDetailKey)
            UserDefaults.standard.synchronize()
            debugPrint("User saved successfully")
        }catch {
            debugPrint(error)
            
        }
    }
}

func getUserDetail()->UserDetail?{
    do{
        guard let jsondata = UserDefaults.standard.value(forKey: userDetailKey) else{
            return nil
        }
        let user = try JSONDecoder().decode(UserDetail.self, from: jsondata as! Data)
        return user
    }catch{
        debugPrint(error)
    }
    return nil
}

let userDetailKey = "userDetailKey"

//do {
//    let jsonData = try JSONEncoder().encode(sentences)
//    let jsonString = String(data: jsonData, encoding: .utf8)!
//    print(jsonString) // [{"sentence":"Hello world","lang":"en"},{"sentence":"Hallo Welt","lang":"de"}]
//
//    // and decode it back
//    let decodedSentences = try JSONDecoder().decode([Sentence].self, from: jsonData)
//    print(decodedSentences)
//} catch { print(error) }
