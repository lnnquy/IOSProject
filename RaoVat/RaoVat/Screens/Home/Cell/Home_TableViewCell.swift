//
//  Home_TableViewCell.swift
//  RaoVat
//
//  Created by Lê Nguyễn Ngọc Quý on 9/19/20.
//  Copyright © 2020 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import UIKit

class Home_TableViewCell: UITableViewCell {

    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbNameUser: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var imgPost: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgPost.layer.cornerRadius = 10
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
