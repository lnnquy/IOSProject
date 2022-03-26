//
//  PostDetail_ViewController.swift
//  RaoVat
//
//  Created by Lê Nguyễn Ngọc Quý on 9/19/20.
//  Copyright © 2020 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import UIKit

class PostDetail_ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    var post:Post?
    @IBOutlet weak var viewChat: UIView!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    @IBOutlet weak var myTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        btnChat.layer.cornerRadius = 20
        
        myTable.dataSource = self
        myTable.delegate = self
        self.view.backgroundColor = .systemYellow
        // Do any additional setup after loading the view.
    }
    func abbreviateNumber(num:Int) -> String {
        let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 2
        
        if num < 1000 {
            return "\(num)"
        }
            
        if num < 1000000 {
            var n = Double(num);
            n = Double( floor(n/100)/10 )
            return "\(n.description) Nghìn"
        }
        if num < 1000000000 {
            var n = Double(num)
            n = Double( floor(n/100000)/10 )
            let number = NSNumber(value: n)
            return "\(formatter.string(from: number)!) Triệu"
        }
        var n = Double(num)
        n = Double( floor(n/100000000)/10 )
        let number = NSNumber(value: n)
        return "\(formatter.string(from: number)!) Tỷ"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = myTable.dequeueReusableCell(withIdentifier: "LISTIMAGE_CELL") as! ListImage_TableViewCell
            cell.loadData(id: post!._id)
            
            return cell
            
        case 1:
            let cell = myTable.dequeueReusableCell(withIdentifier: "CONTENTPOST_CELL") as! ContentPost_TableViewCell
            cell.lbTitlePost.text = post!.Title
//            //format number currency
//            let formatter = NumberFormatter()
//            formatter.numberStyle = .decimal
//            formatter.maximumFractionDigits = 2
//            formatter.decimalSeparator = "."
//            let number = NSNumber(value: Int(self.post!.Price)!)
            cell.lbPrice.text = abbreviateNumber(num: Int(self.post!.Price)!)
            
            cell.loadCate(id: post!.Category)
            cell.loadStatus(id: post!.Status)
            return cell
            
        case 2:
            let cell = myTable.dequeueReusableCell(withIdentifier: "STATUSPD_CELL") as! StatusPD_TableViewCell
            cell.lbView.text = String(post!.View)
            cell.loadCity(id: post!.City)
            return cell
            
        case 3:
            let cell = myTable.dequeueReusableCell(withIdentifier: "DESCRIPTION_CELL") as! Description_TableViewCell
            cell.tvDescription.text = post!.Description
            return cell
            
        default:
            let cell = myTable.dequeueReusableCell(withIdentifier: "USERPD_CELL") as! UserPD_TableViewCell
            cell.loadUser(id: post!.User)
            return cell
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 300
            
        case 1:
            return 200
            
        case 2:
            return 100
            
        case 3:
            return 300
            
        default:
            return 150
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
