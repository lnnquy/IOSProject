//
//  ListImage_CollectionViewCell.swift
//  RaoVat
//
//  Created by Lê Nguyễn Ngọc Quý on 9/19/20.
//  Copyright © 2020 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import UIKit

class ListImage_CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgList: UIImageView!
    override func awakeFromNib() {
        imgList.layer.cornerRadius = 10
    }
}
