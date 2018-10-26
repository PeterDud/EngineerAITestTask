//
//  PostModel.swift
//  EngineerAITestTask
//
//  Created by Peter Dudar  on 26/10/2018.
//  Copyright © 2018 CHI. All rights reserved.
//

import Foundation

class Post: Decodable {
    var createdAt: String?
    var title: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case createdAt = "created_at"
    }
}
