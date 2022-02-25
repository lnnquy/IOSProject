//
//  ManagePost_ViewController.swift
//  RaoVat
//
//  Created by Lê Nguyễn Ngọc Quý on 9/20/20.
//  Copyright © 2020 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import UIKit

extension ManagePost_ViewController:ManagePost_Delegate {
    func selectSelled(index: Int) {
        let alert = UIAlertController(title: "Cảnh báo", message: "Bạn có chắc chắn muốn chuyển sang trạng thái Đã bán?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Đồng ý", style: UIAlertAction.Style.destructive, handler: { (okay) in
            print("test")
            let active = false
            let url = URL(string: Config.URLConnect + "/post/updateActive")
            var req = URLRequest(url: url!)
            req.httpMethod = "POST"
            let str:String = "ID=\(self.arrPost[index]._id)&Active=\(active)"
            let dt = str.data(using: .utf8)
            req.httpBody = dt
            let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
                guard error == nil else {print(error!);return}
                guard let data = data else {return}
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {return}
                    if(json["kq"] as! Int == 1) {
                        DispatchQueue.main.async {
                            self.loadData(active: true)
                        }
                        
                    }
                }catch let error {print(error.localizedDescription)}
                    
               
            }.resume()
        }))
        alert.addAction(UIAlertAction(title: "Hủy bỏ", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

class ManagePost_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var btnDangBan: UIButton!
    @IBOutlet weak var btnDaBan: UIButton!
    var active = true
    var arrPost:[Post] = []
    var idUser:String = ""
    @IBOutlet weak var ViewDaBan: UIView!
    @IBOutlet weak var ViewDangBan: UIView!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    @IBOutlet weak var myTable: UITableView!
    override func viewDidLoad() {
        ViewDaBan.isHidden = true
        spinnerView.isHidden = true
        btnDaBan.setTitleColor(.lightGray, for: .normal)
        myTable.dataSource = self
        myTable.delegate = self
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        checkLogin()
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    func checkLogin(){
        spinnerView.isHidden = false
        spinnerView.startAnimating()
        let defaults = UserDefaults.standard
        
        if let UserToken = defaults.string(forKey: "UserToken") {
            
            //Da co token, check token tren server
            let url = URL(string: Config.URLConnect + "/verifyToken")
            var req = URLRequest(url: url!)
            req.httpMethod = "POST"
            let str:String = "token=\(UserToken)"
            let dt = str.data(using: .utf8)
            req.httpBody = dt
            let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
                guard error == nil else {print(error!);return}
                guard let data = data else {return}
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {return}
                    DispatchQueue.main.async {
                        if json["kq"] as! Int == 1 {
                            self.spinnerView.isHidden = true
                            let userToken = json["User"] as! [String:Any]
                            self.idUser = userToken["IdUser"] as! String
                            self.loadData(active: true)
                        }else {
                            self.spinnerView.isHidden = true
                            self.tabBarController?.selectedIndex = 3
                            let sb = UIStoryboard(name: "Main", bundle: nil)
                            let loginVC = sb.instantiateViewController(withIdentifier: "LOGIN") as! Login_ViewController

                            self.navigationController?.pushViewController(loginVC, animated: true)
                        }
                    }
                }catch let error {print(error.localizedDescription)}
            }.resume()
        }else {
            self.spinnerView.isHidden = true
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = sb.instantiateViewController(withIdentifier: "LOGIN") as! Login_ViewController
            
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
        
    }
    func loadData(active:Bool){
        spinnerView.isHidden = false
        spinnerView.startAnimating()
        let url = URL(string: Config.URLConnect + "/post/findWUser")
        var req = URLRequest(url: url!)
        req.httpMethod = "POST"
        let str:String = "User=\(idUser)&Active=\(active)"
        let dt = str.data(using: .utf8)
        req.httpBody = dt
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            guard error == nil else {print(error!);return}
            guard let data = data else {return}
            do {
                let json = try JSONDecoder().decode(Post_Route.self, from: data)
                if(json.kq == 1) {
                    self.arrPost = json.PostList
                    DispatchQueue.main.async {
                        self.myTable.reloadData()
                        self.spinnerView.isHidden = true
                    }
                    
                }
                
            }catch let error {print(error.localizedDescription)}
        }.resume()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPost.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableCell(withIdentifier: "MANAGEPOST_CELL") as! ManagePost_TableViewCell
        cell.lbTitle.text = arrPost[indexPath.row].Title
        cell.lbPrice.text = arrPost[indexPath.row].Price + " " + "đ"
        cell.lbView.text = String(arrPost[indexPath.row].View)
        cell.btnSelled.isHidden = !self.active
        cell.btnSelled.tag = indexPath.row
        cell.delegate = self
        let urlImage = Config.URLConnect + "/upload/" + self.arrPost[indexPath.row].Image[0]
        do {
            let imageData = try Data(contentsOf: URL(string: urlImage)!)
            cell.imgItem.image = UIImage(data: imageData)
        }catch let error {print(error.localizedDescription)}
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let postDetailVC = sb.instantiateViewController(withIdentifier: "POSTDETAIL") as! PostDetail_ViewController
        postDetailVC.post = self.arrPost[indexPath.item]
        self.navigationController?.pushViewController(postDetailVC, animated: true)
    }
    @IBAction func DangBan(_ sender: Any) {
        btnDangBan.setTitleColor(.black, for: .normal)
        btnDaBan.setTitleColor(.lightGray, for: .normal)
        self.active = true
        ViewDaBan.isHidden = true
        ViewDangBan.isHidden = false
        loadData(active: true)
    }
    @IBAction func DaBan(_ sender: Any) {
        btnDaBan.setTitleColor(.black, for: .normal)
        btnDangBan.setTitleColor(.lightGray, for: .normal)
        self.active = false
        ViewDaBan.isHidden = false
        ViewDangBan.isHidden = true
        loadData(active: false)
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
