
//
//  Channel.swift
//  appsmack
//
//  Created by Dante on 2019/10/3.
//  Copyright © 2019 cinderella. All rights reserved.
//

import Foundation

struct Channel : Decodable {
    public private(set) var channelTitle :String!
    public private(set) var channelDescription: String!
    public private(set) var id: String!
}
