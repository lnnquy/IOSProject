//
//  Dashboard_ViewController.swift
//  RaoVat
//
//  Created by Lê Nguyễn Ngọc Quý on 9/13/20.
//  Copyright © 2020 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import UIKit



class Dashboard_ViewController: UIViewController {

    
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    
    var User:[String:Any]?
    override func viewDidLoad() {
        super.viewDidLoad()
        spinnerView.isHidden = true
        
        btnLogout.layer.cornerRadius = 5
        //Check Login
        self.navigationItem.hidesBackButton = true
        imgAvatar.layer.cornerRadius = imgAvatar.frame.width/2
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
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
                            let userToken = json["User"] as! [String:Any]
                            
                            //LOAD DATA FROM TABLE USER
                            let url = URL(string: Config.URLConnect + "/FindUser")
                            var req = URLRequest(url: url!)
                            req.httpMethod = "POST"
                            let str:String = "email=\(userToken["Email"] as! String)"
                            let dt = str.data(using: .utf8)
                            req.httpBody = dt
                            let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
                                guard error == nil else {print(error!);return}
                                guard let data = data else {return}
                                do {
                                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {return}
                                    if(json["kq"] as! Int == 2) {
                                        
                                        self.User = json["user"] as! [String:Any]
                                        DispatchQueue.main.async {
                                            guard let user = self.User else {return}
                                            self.lblName.text = user["Name"] as? String
                                            self.lblEmail.text = user["Email"] as? String
                                            let urlImage = Config.URLConnect + "/upload/" + (user["Image"] as! String)
                                            do {
                                                let imageData = try Data(contentsOf: URL(string: urlImage)!)
                                                self.imgAvatar.image = UIImage(data: imageData)
                                            }catch let error {
                                                print(error.localizedDescription)
                                                self.imgAvatar.image = UIImage(named: "profile")
                                            }
                                            self.spinnerView.isHidden = true
                                        }
                                        
                                    }
                                    

                                }catch let error {print(error.localizedDescription)}
                            }.resume()
                            
                            
                            



                        }else {
                            let sb = UIStoryboard(name: "Main", bundle: nil)
                            let loginVC = sb.instantiateViewController(withIdentifier: "LOGIN") as! Login_ViewController
                            
                            self.navigationController?.pushViewController(loginVC, animated: true)
                        }
                    }
                }catch let error {print(error.localizedDescription)}
            }.resume()
        }else {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = sb.instantiateViewController(withIdentifier: "LOGIN") as! Login_ViewController
            
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
        
    }

    @IBAction func Logout(_ sender: Any) {
        let defaults = UserDefaults.standard
        if let UserToken = defaults.string(forKey: "UserToken") {
            //Da co token
            let url = URL(string: Config.URLConnect + "/logout")
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
                            defaults.removeObject(forKey: "UserToken")
                            let sb = UIStoryboard(name: "Main", bundle: nil)
                            let loginVC = sb.instantiateViewController(withIdentifier: "LOGIN") as! Login_ViewController
                            self.navigationController?.pushViewController(loginVC, animated: true)
                        }else {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Error", message: json["errMsg"] as? String, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { (cancel) in
                                    
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }catch let error {print(error.localizedDescription)}
            }.resume()
        }else {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = sb.instantiateViewController(withIdentifier: "LOGIN") as! Login_ViewController
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }
    @IBAction func Profile(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let profileVC = sb.instantiateViewController(withIdentifier: "PROFILE") as! Profile_ViewController
        guard let user = User else {return}
        profileVC.email = user["Email"] as! String
        profileVC.name = user["Name"] as! String
        profileVC.id = user["_id"] as! String
        profileVC.phone = user["Phone"] as! String
        profileVC.image = user["Image"] as! String
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    @IBAction func Favorite(_ sender: Any) {
        print("FAVORITE")
    }
    @IBAction func Review(_ sender: Any) {
        print("REVIEW")
    }
    @IBAction func Setting(_ sender: Any) {
        print("SETTING")
    }
    @IBAction func Helper(_ sender: Any) {
        print("HELP")
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
