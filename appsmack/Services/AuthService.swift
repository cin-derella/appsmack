//
//  AuthService.swift
//  appsmack
//
//  Created by Dante on 2019/10/2.
//  Copyright © 2019 cinderella. All rights reserved.
//

import Foundation
import Alamofire

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
        let header = [
            "Content-Type": "application/json"
        ]
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        func responseHandler(response: DataResponse<String>) -> Void {
            if response.result.error == nil {
                //completion(true)
            }
        }
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseString { (resp) in
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

}



