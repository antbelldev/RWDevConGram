//
//  Post.swift
//  DevConGram
//
//  Created by Antoine Bellanger on 06.04.18.
//  Copyright © 2018 Antoine Bellanger. All rights reserved.
//

import Foundation

class Post {
    var key: String!
    var email: String!
    var date: String!
    var image_url: String!
    var caption: String!
    var emojis: [String: Int]!
    
    init(key: String, email: String, date: String, image_url: String, caption: String, emojis: [String: Int]) {
        self.key = key
        self.email = email
        self.date = date
        self.image_url = image_url
        self.caption = caption
        self.emojis = emojis
    }
}
