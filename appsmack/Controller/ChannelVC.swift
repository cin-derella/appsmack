//
//  ChannelVC.swift
//  appsmack
//
//  Created by Dante on 2019/9/30.
//  Copyright © 2019 cinderella. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController, UITableViewDelegate, UITableViewDataSource{


    @IBOutlet weak var userImg: CircleImage!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func prepareForUnwind(segue:UIStoryboardSegue){}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.revealViewController().rearViewRevealWidth=self.view.frame.size.width-60
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.channelsLoaded(_:)), name: NOTIF_CHANNELS_LOADED, object: nil)
        
        SocketService.instance.getChannel { (newChannel, creatorId) in
            self.tableView.reloadData()
//            if UserDataService.instance.id == creatorId {
//                var index = 0
//                for channel in MessageService.instance.channels {
//                    if channel.id == newChannel.id {
//                        break
//                    }
//                    index += 1
//                }
//                MessageService.instance.selectedChannel = MessageService.instance.channels[index]
//                NotificationCenter.default.post(name: NOTIF_CHANNEL_SELECTED, object: nil)
//                self.revealViewController()?.revealToggle(animated: true)
//            }
        }
        
        SocketService.instance.getChatMessage { (newMessage) in
            debugPrint(newMessage)
            print(newMessage)
            if newMessage.channelId != MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn {
                MessageService.instance.unreadChannels.append(newMessage.channelId)
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
        setupUserInfo()
        
    }
    @IBAction func addChannelPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn{
            let addChannel = AddChannelVC()
            addChannel.modalPresentationStyle = .custom
            present(addChannel, animated: true, completion: nil)
            
        }  
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn{
            //show profile page
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile,animated: true,completion: nil)
        }
        else
        {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
    
    @objc func userDataDidChange(_ notif:Notification){
        print("userDataDidChange")
        setupUserInfo()
    }
    
    @objc func channelsLoaded(_ notif:Notification) {
        print("channelsLoaded")
        self.tableView.reloadData()
    }
    
    func setupUserInfo(){
        print("setupUserInfo")
        if AuthService.instance.isLoggedIn {
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            userImg.image = UIImage(named:UserDataService.instance.avatarName)
            userImg.backgroundColor = UserDataService.instance.returnUIColor(compoents: UserDataService.instance.avatarColor)
            tableView.reloadData()
        } else {
            loginBtn.setTitle("Login", for: .normal)
            userImg.image = UIImage(named:"menuProfileIcon")
            userImg.backgroundColor = UIColor.clear
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell",for:indexPath) as? ChannelCell{
            let channel = MessageService.instance.channels[indexPath.row]
            cell.configureCell(channel: channel)
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.selectedChannel = channel
        NotificationCenter.default.post(name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        if MessageService.instance.unreadChannels.count > 0 {
            MessageService.instance.unreadChannels = MessageService.instance.unreadChannels.filter{$0 != channel.id}
        }
        let index = IndexPath(row: indexPath.row, section: 0)
        tableView.reloadRows(at: [index], with: .none)
        tableView.selectRow(at: index, animated: false, scrollPosition: .none)
        self.revealViewController()?.revealToggle(animated: true)
    }
}
