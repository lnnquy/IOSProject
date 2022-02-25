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
        viewChat.layer.cornerRadius = 30
        myTable.dataSource = self
        myTable.delegate = self
        // Do any additional setup after loading the view.
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
            cell.lbPrice.text = post!.Price + " " + "đ"
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
