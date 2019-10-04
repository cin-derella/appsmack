//
//  UserDataService.swift
//  appsmack
//
//  Created by Dante on 2019/10/2.
//  Copyright © 2019 cinderella. All rights reserved.
//

import Foundation
class UserDataService {
    static let instance = UserDataService()
    public private(set) var id = ""
    public private(set) var avatarColor = ""
    public private(set) var avatarName = ""
    public private(set) var email = ""
    public private(set) var name = ""
    
    func setUserData(id: String, color: String, avatarName: String, email: String, name: String) {
        self.id = id
        self.avatarColor = color
        self.avatarName = avatarName
        self.email = email
        self.name = name
    }
    
    func setAvatarName(avatarName: String) {
        self.avatarName = avatarName
    }
    
    
    func returnUIColor(compoents:String) -> UIColor{
   //     [0.8,0.8666666666666667,0.7098039215686275,1]
        
        let scanner = Scanner(string: compoents)
        let skipped = CharacterSet(charactersIn: "[], ")
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skipped
        
        var r,g,b,a : NSString?
        
 
        
        scanner.scanUpToCharacters(from: comma,into:&r)
        scanner.scanUpToCharacters(from: comma,into:&g)
        scanner.scanUpToCharacters(from: comma,into:&b)
        scanner.scanUpToCharacters(from: comma,into:&a)
        
        let defaultColor = UIColor.lightGray
        guard let rUnwrapped = r else{ return defaultColor }
        guard let gUnwrapped = g else{ return defaultColor }
        guard let bUnwrapped = b else{ return defaultColor }
        guard let aUnwrapped = a else{ return defaultColor }
        
        let rfloat  = CGFloat(rUnwrapped.doubleValue)
        let gfloat  = CGFloat(gUnwrapped.doubleValue)
        let bfloat  = CGFloat(bUnwrapped.doubleValue)
        let afloat  = CGFloat(aUnwrapped.doubleValue)
        
        let newUIColor = UIColor(red: rfloat, green: gfloat, blue: bfloat, alpha: afloat)
        return newUIColor
    }
    

    func logoutUser(){
        id = ""
        avatarName = ""
        avatarColor = ""
        email = ""
        name = ""
        AuthService.instance.isLoggedIn = false
        AuthService.instance.userEmail = ""
        AuthService.instance.authToken = ""
        MessageService.instance.clearChannels()
    }
    
    
}
