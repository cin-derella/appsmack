
//
//  MessageService.swift
//  appsmack
//
//  Created by Dante on 2019/10/3.
//  Copyright © 2019 cinderella. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class  MessageService {
    static let instance = MessageService()
    
    var channels = [Channel]() //[Channel](arrayLiteral:Channel(channelTitle: "title", channelDescription: "desc", id: "id"))
    var messages = [Message]()
    var selectedChannel: Channel?
    
    func findAllChannel(completion: @escaping CompletionHandler) {
        //MessageService.instance.clearChannels()
        Alamofire.request(URL_GET_CHANNEL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil{
                guard let data  = response.data else{ return }
                do{
                    if let json = try JSON(data:data).array{
                        for item in json{
                            let name = item["name"].stringValue
                            let channelDescription = item["description"].stringValue
                            let id  = item["_id"].stringValue
                            let channel = Channel(channelTitle: name, channelDescription: channelDescription, id: id)
                            self.channels.append(channel)
                            print("channel append: \(self.channels.count) \(channel.channelTitle)")
                        }
                        //print(self.channels[0].channelTitle)
                        print("channel count: \(self.channels.count)")
                        NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                        completion(true)
                    }
                } catch {
                    //debugPrint(error)
                }
            }else{
                completion(false)
                //debugPrint(response.result.error as Any)
                
            }
            
        }
        
    }
    
    func findAllMessagesForChannel(channelId: String, completion: @escaping CompletionHandler) {
        Alamofire.request("\(URL_GET_MESSAGES)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.response?.statusCode == 200 {
                self.clearMessages()
                guard let data = response.data else { return }
                do {
                    if let json = try JSON(data: data).array {
                        for item in json {
                            let messageBody = item["messageBody"].stringValue
                            let channelId = item["channelId"].stringValue
                            let id = item["id"].stringValue
                            let userName = item["userName"].stringValue
                            let userAvatar = item["userAvatar"].stringValue
                            let userAvatarColor = item["userAvatarColor"].stringValue
                            let timeStamp = item["timeStamp"].stringValue
                            
                            let message = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                            
                            self.messages.append(message)


                        }
                        completion(true)
                        print(self.messages)
                    }
                }
                catch {
                    debugPrint(response.response?.statusCode as Any)
                    debugPrint(response.result)
                }
            }
            else {
                debugPrint(response.response?.statusCode as Any)
                debugPrint(response)
                completion(false)
            }
        }
    }
    
    func clearMessages() {
        messages.removeAll()
    }
    
    func clearChannels() {
        channels.removeAll()
    }
    
}


