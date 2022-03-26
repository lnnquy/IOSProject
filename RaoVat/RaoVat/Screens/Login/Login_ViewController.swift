//
//  Login_ViewController.swift
//  RaoVat
//
//  Created by Lê Nguyễn Ngọc Quý on 9/13/20.
//  Copyright © 2020 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import UIKit

class Login_ViewController: UIViewController {
    
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    @IBOutlet weak var imgBgLogin: UIImageView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLogin.layoutIfNeeded()
        viewLogin.roundCorners([.bottomLeft,.bottomRight], radius: 100)
        
        self.navigationController?.isNavigationBarHidden = true
        btnLogin.layer.cornerRadius = 10
        spinnerView.isHidden = true
        // Do any additional setup after loading the view.
    }
    

    @IBAction func Register(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let registerVC = sb.instantiateViewController(withIdentifier: "REGISTER") as! Register_ViewController
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    @IBAction func ForgotPassword(_ sender: Any) {
    }
    @IBAction func Login(_ sender: Any) {
        spinnerView.isHidden = false
        spinnerView.startAnimating()
        let url = URL(string: Config.URLConnect + "/Login")
        var req = URLRequest(url: url!)
        req.httpMethod = "POST"
        let str:String = "email=\(self.txtEmail.text!)&password=\(self.txtPassword.text!)"
        let dt = str.data(using: .utf8)
        req.httpBody = dt
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            guard error == nil else {print(error);return}
            guard let data = data else {return}
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {return}
                DispatchQueue.main.async {
                    if json["kq"] as! Int == 1 {
                        self.spinnerView.isHidden = true
                        //Save Token

                        let defaults = UserDefaults.standard
                        defaults.set(json["token"], forKey: "UserToken")
                        let sb = UIStoryboard(name: "Main", bundle: nil)
                        if self.tabBarController?.selectedIndex == 3 {

                            let dashboardVC = sb.instantiateViewController(withIdentifier: "DASHBOARD") as! Dashboard_ViewController
                            self.navigationController?.pushViewController(dashboardVC, animated: true)
                        }else if self.tabBarController?.selectedIndex == 1 {

                            let postVC = sb.instantiateViewController(withIdentifier: "POST") as! Post_ViewController
                            self.navigationController?.pushViewController(postVC, animated: true)
                        }else if self.tabBarController?.selectedIndex == 2 {

                            let managePostVC = sb.instantiateViewController(withIdentifier: "MANAGEPOST") as! ManagePost_ViewController
                            self.navigationController?.pushViewController(managePostVC, animated: true)
                        }

                    }else {
                        let alert = UIAlertController(title: "Error", message: "Email hoặc Password không chính xác. ", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { (cancel) in
                            self.spinnerView.isHidden = true
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }catch let error {print(error.localizedDescription)}
        }.resume()
    }
    
}



