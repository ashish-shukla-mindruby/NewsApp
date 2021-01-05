//
//  SourceModel.swift
//  IdeaVateNews
//
//  Created by Ashish Shukla on 03/11/20.
//  Copyright © 2020 Ashish. All rights reserved.
//

import UIKit

class SourceModel: NSObject, Encodable {
    var id: String
    var name: String
    
    init(with dictionary: [String:Any]) {
        let constant = APPConstant.APIResponseConstant.self
        
        self.id = dictionary[constant.id] as? String ?? ""
        self.name = dictionary[constant.name] as? String ?? ""
        
        super.init()
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }
}
