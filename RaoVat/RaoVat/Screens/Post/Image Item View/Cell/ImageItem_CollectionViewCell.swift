//
//  ImageItem_CollectionViewCell.swift
//  RaoVat
//
//  Created by Lê Nguyễn Ngọc Quý on 9/17/20.
//  Copyright © 2020 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import UIKit

class ImageItem_CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgItem: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgItem.layer.cornerRadius = 5
    }
}
