//
//  Network.swift
//  IdeaVateNews
//
//  Created by Ashish Shukla on 03/11/20.
//  Copyright © 2020 Ashish. All rights reserved.
//

import Foundation
import Reachability

struct Network {
    
    static var reachability: Reachability?
    
    enum Status: String {
        case unreachable, wifi, wwan
    }
    
    enum Error: Swift.Error {
        case failedToSetCallout
        case failedToSetDispatchQueue
        case failedToCreateWith(String)
        case failedToInitializeWith(sockaddr_in)
    }
}
