//
//  ContentPost_TableViewCell.swift
//  RaoVat
//
//  Created by Lê Nguyễn Ngọc Quý on 9/19/20.
//  Copyright © 2020 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import UIKit

class ContentPost_TableViewCell: UITableViewCell {

    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var viewPrice: UIView!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbTitlePost: UILabel!
    @IBOutlet weak var lbCategory: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        lbStatus.layer.cornerRadius = 10
        lbStatus.layer.masksToBounds = true
        lbCategory.layer.cornerRadius = 10
        lbCategory.layer.masksToBounds = true
        viewPrice.layer.cornerRadius = 15
        // Initialization code
    }
    func loadStatus(id:String) {
        let url = URL(string: Config.URLConnect + "/status/findID")
        var req = URLRequest(url: url!)
        req.httpMethod = "POST"
        let str:String = "ID=\(id)"
        let dt = str.data(using: .utf8)
        req.httpBody = dt
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            guard error == nil else {print(error!);return}
            guard let data = data else {return}
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {return}
                if(json["kq"] as! Int == 1) {
                    
                    var status = json["status"] as! [String:Any]
                    DispatchQueue.main.async {
                        self.lbStatus.text = status["Name"] as! String
                    }
                    
                }
                

            }catch let error {print(error.localizedDescription)}
        }.resume()
    }
    func loadCate(id:String) {
        let url = URL(string: Config.URLConnect + "/category/findID")
        var req = URLRequest(url: url!)
        req.httpMethod = "POST"
        let str:String = "ID=\(id)"
        let dt = str.data(using: .utf8)
        req.httpBody = dt
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            guard error == nil else {print(error!);return}
            guard let data = data else {return}
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {return}
                if(json["kq"] as! Int == 1) {
                    
                    var cate = json["cate"] as! [String:Any]
                    DispatchQueue.main.async {
                        self.lbCategory.text = cate["Name"] as! String
                    }
                    
                }
                

            }catch let error {print(error.localizedDescription)}
        }.resume()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
