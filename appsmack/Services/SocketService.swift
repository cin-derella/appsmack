//
//  SocketService.swift
//  appsmack
//
//  Created by Dante on 2019/10/3.
//  Copyright © 2019 cinderella. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {

    static let instance = SocketService()
    
    let manager : SocketManager
    let socket : SocketIOClient
    
    override init() {
        self.manager = SocketManager(socketURL: URL(string:BASE_URL)!)
        self.socket = manager.defaultSocket
        super.init()
    }

    func establishConnetion(){
        socket.connect()
    }
    
    func closeConnetion(){
        socket.disconnect()
        
    }
    
    func addChannel(channelName:String,channelDescription:String,completion:@escaping CompletionHandler){
        socket.emit("newChannel", channelName,channelDescription)
        completion(true)

    }
    
    func getChannel(completion:@escaping (_ channel: Channel, _ creatorId: String) -> Void){
        socket.on("channelCreated") { (dataArray,ack) in
            guard let channelName = dataArray[0] as? String else { return }
            guard let channelDesc = dataArray[1] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }

            let newChannel = Channel(channelTitle: channelName, channelDescription: channelDesc, id: channelId)
            MessageService.instance.channels.append(newChannel)
            completion(newChannel, UserDataService.instance.id)
        }
    }
    
    func addMessage(messageBody: String, userId: String, channelId: String, completion: @escaping CompletionHandler) {
        let user = UserDataService.instance
        socket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true)
    }
    
    func getChatMessage(completion: @escaping (_ newMessage: Message) -> Void) {
        socket.on("messageCreated") { (dataArray, ack) in
            guard let messageBody = dataArray[0] as? String else { return }
            //guard let userId = dataArray[1] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            guard let userName = dataArray[3] as? String else { return }
            guard let userAvatar = dataArray[4] as? String else { return }
            guard let userAvatarColor = dataArray[5] as? String else { return }
            guard let id = dataArray[6] as? String else { return }
            guard let timeStamp = dataArray[7] as? String else { return }
            //msg.messageBody, msg.userId, msg.channelId, msg.userName, msg.userAvatar, msg.userAvatarColor, msg.id, msg.timeStamp
            let newMessage = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
            
            completion(newMessage)
        }
    }
    
    func getTypingUsers(_ completionHandler: @escaping (_ typingUsers: [String: String]) -> Void) {
        socket.on("userTypingUpdate") { (dataArray, ask) in
            guard let typeUsers = dataArray[0] as? [String: String] else { return }
            completionHandler(typeUsers)
        }
    }
}
