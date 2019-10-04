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
    
    func getChannel(completion:@escaping CompletionHandler){
        socket.on("channelCreated") { (dataArray,ack) in
            guard let channelName = dataArray[0] as? String else { return }
            guard let channelDesc = dataArray[1] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }

            let newChannel = Channel(channelTitle: channelName, channelDescription: channelDesc, id: channelId)
            MessageService.instance.channels.append(newChannel)
            completion(true)
        }
    }
}
