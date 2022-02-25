//
//  StatusPD_TableViewCell.swift
//  RaoVat
//
//  Created by Lê Nguyễn Ngọc Quý on 9/19/20.
//  Copyright © 2020 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import UIKit

class StatusPD_TableViewCell: UITableViewCell {

    @IBOutlet weak var lbView: UILabel!
    @IBOutlet weak var lbLocation: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func loadCity(id:String) {
        let url = URL(string: Config.URLConnect + "/city/findID")
        var req = URLRequest(url: url!)
        req.httpMethod = "POST"
        let str:String = "id=\(id)"
        let dt = str.data(using: .utf8)
        req.httpBody = dt
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            guard error == nil else {print(error!);return}
            guard let data = data else {return}
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {return}
                if(json["kq"] as! Int == 1) {
                    
                    var city = json["city"] as! [String:Any]
                    DispatchQueue.main.async {
                        self.lbLocation.text = city["Name"] as! String
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
