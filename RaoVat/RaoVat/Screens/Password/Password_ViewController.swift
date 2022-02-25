//
//  Password_ViewController.swift
//  RaoVat
//
//  Created by Lê Nguyễn Ngọc Quý on 9/13/20.
//  Copyright © 2020 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import UIKit

class Password_ViewController: UIViewController {

    @IBOutlet weak var txtRenewPass: UITextField!
    @IBOutlet weak var txtNewPass: UITextField!
    @IBOutlet weak var txtCurrentPass: UITextField!
    var id:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func Save(_ sender: Any) {
        if txtNewPass.text != txtRenewPass.text {
            let alert = UIAlertController(title: "Error", message: "Xác nhận mật khẩu mới không đúng. ", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { action in
                self.txtRenewPass.text = ""
            }))
            self.present(alert, animated: true)
        }else {
            let defaults = UserDefaults.standard
            if let UserToken = defaults.string(forKey: "UserToken") {
                let url = URL(string: Config.URLConnect + "/changePassword")
                var req = URLRequest(url: url!)
                req.httpMethod = "POST"
                DispatchQueue.main.async {
                    let str:String = "id=\(self.id)&currentPass=\(self.txtCurrentPass.text!)&newPassword=\(self.txtNewPass.text!)"
                     let dt = str.data(using: .utf8)
                    req.httpBody = dt
                    let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
                        guard error == nil else {print(error!);return}
                        guard let data = data else {return}
                        do {
                            guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {return}
                            if json["kq"] as! Int == 1 {
                                
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
                                                    let alert = UIAlertController(title: "Thông báo", message: "Đổi password thành công. ", preferredStyle: UIAlertController.Style.alert)
                                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { (cancel) in
                                                        let sb = UIStoryboard(name: "Main", bundle: nil)
                                                        let loginVC = sb.instantiateViewController(withIdentifier: "LOGIN") as! Login_ViewController
                                                        self.navigationController?.pushViewController(loginVC, animated: true)
                                                    }))
                                                    self.present(alert, animated: true, completion: nil)
                                                    
                                                }else {
                                                      let alert = UIAlertController(title: "Error", message: json["errMsg"] as? String, preferredStyle: UIAlertController.Style.alert)
                                                      alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { (cancel) in
                                                          
                                                      }))
                                                      self.present(alert, animated: true, completion: nil)
                                                    
                                                }
                                            }
                                        }catch let error {print(error.localizedDescription)}
                                    }.resume()
                                
                            }else {
                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: "Error", message: "Password cũ không đúng. ", preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { (cancel) in
                                        self.txtCurrentPass.text = ""
                                    }))
                                    self.present(alert, animated: true, completion: nil)
                                }
                                
                            }
                        }catch let error {print(error.localizedDescription)}
                    }.resume()
                }
           }else {
                    let sb = UIStoryboard(name: "Main", bundle: nil)
                    let loginVC = sb.instantiateViewController(withIdentifier: "LOGIN") as! Login_ViewController
                    self.navigationController?.pushViewController(loginVC, animated: true)
            }
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
