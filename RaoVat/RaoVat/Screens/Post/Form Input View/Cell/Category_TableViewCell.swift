//
//  Category_TableViewCell.swift
//  RaoVat
//
//  Created by Lê Nguyễn Ngọc Quý on 9/17/20.
//  Copyright © 2020 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import UIKit

class Category_TableViewCell: UITableViewCell {

    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgCategory.layer.cornerRadius = 10
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
