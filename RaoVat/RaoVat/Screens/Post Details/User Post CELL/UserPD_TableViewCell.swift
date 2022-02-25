//
//  UserPD_TableViewCell.swift
//  RaoVat
//
//  Created by Lê Nguyễn Ngọc Quý on 9/19/20.
//  Copyright © 2020 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import UIKit

class UserPD_TableViewCell: UITableViewCell {

    @IBOutlet weak var lbNameUser: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
 
        imgAvatar.layer.cornerRadius = imgAvatar.frame.width/2
        // Initialization code
    }
    func loadUser(id:String) {
        let url = URL(string: Config.URLConnect + "/account/findID")
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
                    
                    var user = json["user"] as! [String:Any]
                    DispatchQueue.main.async {
                        self.lbNameUser.text = user["Name"] as! String
                        let urlImage = Config.URLConnect + "/upload/" + (user["Image"] as! String)
                        do {
                            let imageData = try Data(contentsOf: URL(string: urlImage)!)
                            self.imgAvatar.image = UIImage(data: imageData)
                        }catch let error {print(error.localizedDescription)}
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
