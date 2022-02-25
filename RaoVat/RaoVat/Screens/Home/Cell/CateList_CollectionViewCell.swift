//
//  CateList_CollectionViewCell.swift
//  RaoVat
//
//  Created by Lê Nguyễn Ngọc Quý on 9/20/20.
//  Copyright © 2020 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import UIKit

class CateList_CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lbNameCate: UILabel!
    @IBOutlet weak var imgCate: UIImageView!
    override func awakeFromNib() {
        imgCate.layer.cornerRadius = imgCate.frame.width/2
        
    }
}
