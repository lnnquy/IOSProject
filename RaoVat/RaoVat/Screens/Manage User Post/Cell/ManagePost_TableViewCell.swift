//
//  ManagePost_TableViewCell.swift
//  RaoVat
//
//  Created by Lê Nguyễn Ngọc Quý on 9/20/20.
//  Copyright © 2020 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import UIKit

protocol ManagePost_Delegate {
    func selectSelled(index:Int)
}
class ManagePost_TableViewCell: UITableViewCell {

    var delegate:ManagePost_Delegate?
    @IBOutlet weak var btnSelled: UIButton!
    @IBOutlet weak var lbView: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var imgItem: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnSelled.layer.cornerRadius = 15
        imgItem.layer.cornerRadius = 20
        // Initialization code
    }

    @IBAction func Selled(_ sender: Any) {
        let button = sender as! UIButton
        self.delegate?.selectSelled(index: button.tag)

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
