//
//  Home_CollectionViewCell.swift
//  RaoVat
//
//  Created by Lê Nguyễn Ngọc Quý on 9/19/20.
//  Copyright © 2020 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import UIKit

class Home_CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    override func awakeFromNib() {
        imgPost.layer.cornerRadius = 10

    }
}
