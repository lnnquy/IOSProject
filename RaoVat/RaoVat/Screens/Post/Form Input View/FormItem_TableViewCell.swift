//
//  FormItem_TableViewCell.swift
//  RaoVat
//
//  Created by Lê Nguyễn Ngọc Quý on 9/19/20.
//  Copyright © 2020 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import UIKit

protocol FormItem_Delegate {
    func selectViewLabel(index:Int)
    func pushTitle(Title:String)
    func pushPrice(Price:String)
    func pushDescription(Des:String)
}

class FormItem_TableViewCell: UITableViewCell,UITextViewDelegate {

    var delegate:FormItem_Delegate?
    
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var lbLocationValue: UILabel!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var viewLocation: UIView!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbStatusValue: UILabel!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var lbCateValue: UILabel!
    @IBOutlet weak var viewCate: UIView!
    
    @IBOutlet weak var txtPriceItem: UITextField!
    @IBOutlet weak var txtNameItem: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        tvDescription.layer.borderWidth = 1
        tvDescription.layer.borderColor = UIColor.lightGray.cgColor
        tvDescription.layer.cornerRadius = 5
        tvDescription.delegate = self
        let tapCate = UITapGestureRecognizer(target: self, action: #selector(openCategory))
        viewCate.addGestureRecognizer(tapCate)
        viewCate.isUserInteractionEnabled = true
        
        let tapCity = UITapGestureRecognizer(target: self, action: #selector(openCity))
        viewLocation.addGestureRecognizer(tapCity)
        viewLocation.isUserInteractionEnabled = true
        
        let tapStatus = UITapGestureRecognizer(target: self, action: #selector(openStatus))
        viewStatus.addGestureRecognizer(tapStatus)
        viewStatus.isUserInteractionEnabled = true
    }
    
    @objc func openStatus(){
        delegate?.selectViewLabel(index: 2)
        
    }
    @objc func openCity(){
        delegate?.selectViewLabel(index: 3)
    }
    @objc func openCategory(){
        delegate?.selectViewLabel(index: 1)
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        delegate?.pushDescription(Des: tvDescription.text!)
    }
    
    @IBAction func PostPrice(_ sender: Any) {
        delegate?.pushPrice(Price: txtPriceItem.text!)
    }
    @IBAction func PostTitle(_ sender: Any) {
        delegate?.pushTitle(Title: txtNameItem.text!)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
