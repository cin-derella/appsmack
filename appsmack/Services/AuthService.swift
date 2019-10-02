//
//  AuthService.swift
//  appsmack
//
//  Created by Dante on 2019/10/2.
//  Copyright © 2019 cinderella. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService {
    
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken: String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    struct Login: Encodable {
        let email: String
        let password: String
    }
    
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()

        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        func responseHandler(response: DataResponse<String>) -> Void {
            if response.result.error == nil {
                //completion(true)
            }
        }
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (resp) in
            //ßdebugPrint(resp)
            let sCode:Int = resp.response!.statusCode
            if sCode == 200 {
                completion(true)
                debugPrint(resp.result as Any)
            }
            else {
                completion(false)
                debugPrint(resp.result as Any)
            }
            //debugPrint(resp.response?.allHeaderFields)
            //ßdebugPrint(resp.response?.statusCode)
            //ßdebugPrint(resp.response?.allHeaderFields.values)
            let contentKey = AnyHashable("Content-Type")
            let contentType = resp.response!.allHeaderFields[contentKey] as! String
            
            debugPrint("statusCode is: \(sCode)")
            debugPrint("contentType is: \(contentType)")
        }
    }
    
    //(completionHandler: <#T##(DataResponse<String>) -> Void#>)

    func stringToJSON(from: String) -> [String: Any]? {
        if let data = from.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                return json
            }
            catch {
                debugPrint(error)
            }
        }
        return nil
    }
    
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
            if response.response?.statusCode == 200 {
                //debugPrint(response)
                debugPrint(response.result.value)
                //var result: Result<String> = response.result
                
//                if let json = self.stringToJSON(from: response.result.value!) {
//                    if let email = json["user"] as? String {
//                        self.userEmail = email
//                    }
//                    if let token = json["token"] as? String {
//                        self.authToken = token
//                    }
//                    self.isLoggedIn = true
//                }
                debugPrint(response.data)
                guard let data = response.data else { return }
                do {
                    let json = try JSON(data: data)
                    self.userEmail = json["user"].stringValue
                    self.authToken = json["token"].stringValue
                    self.isLoggedIn = true
                }
                catch {
                    debugPrint(error)
                }
                
                completion(true)
            }
            else {
                completion(false)
                debugPrint(response.response?.statusCode as Any)
            }
        }
    }
    
    func createUser(name: String, email: String, avatarName: String, avatarColor: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "name": name,
            "email": lowerCaseEmail,
            "avatarName": avatarName,
            "avatarColor": avatarColor
        ]
        
        let header = [
            "Authorization": "Bearer \(AuthService.instance.authToken)",
            "Content-Type": "application/json; chatset=utf-8"
        ]
        
        Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON { (resp) in
            if resp.response?.statusCode == 200 {
               
                guard let data = resp.data else { return }
                do {
                    let json = try JSON(data: data)
                    let id = json["_id"].stringValue
                    let color = json["avatarColor"].stringValue
                    let avatarName = json["avatarName"].stringValue
                    let email = json["email"].stringValue
                    let name = json["name"].stringValue
                    
                    UserDataService.instance.setUserData(id: id, color: color, avatarName: avatarName, email: email, name: name)
                    completion(true)
                }
                catch {
                    debugPrint(error)
                }
            }
            else {
                completion(false)
                debugPrint(resp.response?.statusCode)
            }
        }
    }
}



