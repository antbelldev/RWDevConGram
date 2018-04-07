//
//  PostCollectionViewCell.swift
//  DevConGram
//
//  Created by Antoine Bellanger on 06.04.18.
//  Copyright © 2018 Antoine Bellanger. All rights reserved.
//

import UIKit
import Tags
import Firebase
import FirebaseDatabase

class PostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var captionLabel: UILabel!
    @IBOutlet var emojiView: TagsView!
    @IBOutlet var emojiButton: UIButton!
    
}
