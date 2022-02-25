//
//  Welcome_ViewController.swift
//  RaoVat
//
//  Created by Lê Nguyễn Ngọc Quý on 9/13/20.
//  Copyright © 2020 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import UIKit

class Welcome_ViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var imgLogo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLogin()
        self.btnStart.alpha = 0
        
        self.imgLogo.alpha = 0
        lblTitle.alpha = 0
        UIView.animate(withDuration: 3, animations: {
            
            self.btnStart.alpha = 1
            self.lblTitle.alpha = 1
        }, completion: nil)
        imgLogo.frame.origin.x = self.view.frame.width + imgLogo.frame.width
        // Do any additional setup after loading the view.
        UIView.animate(withDuration: 2, animations: {
            self.imgLogo.frame.origin = CGPoint(
                x: self.view.frame.width/2 - self.imgLogo.frame.width/2,
                y: self.view.frame.height/2 - self.imgLogo.frame.height/2
            )
            self.imgLogo.alpha = 1
        }, completion: nil)
        btnStart.layer.cornerRadius = 20
    }
    
    @IBAction func GetStarted(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let tbar = sb.instantiateViewController(withIdentifier: "TABBAR")
        tbar.modalPresentationStyle = .fullScreen
        self.present(tbar, animated: true, completion: nil)
    }
    func checkLogin(){
        let defaults = UserDefaults.standard
        if let UserToken = defaults.string(forKey: "UserToken") {
            //Da co token
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
                        if json["kq"] as! Int == 0 {
                            let sb = UIStoryboard(name: "Main", bundle: nil)
                            let loginVC = sb.instantiateViewController(withIdentifier: "LOGIN") as! Login_ViewController
                            self.navigationController?.pushViewController(loginVC, animated: true)
                        }else {
                            let sb = UIStoryboard(name: "Main", bundle: nil)
                            let tbar = sb.instantiateViewController(withIdentifier: "TABBAR")
                            tbar.modalPresentationStyle = .fullScreen
                            self.present(tbar, animated: true, completion: nil)
                        }
                    }
                }catch let error {print(error.localizedDescription)}
            }
            task.resume()
        }else {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = sb.instantiateViewController(withIdentifier: "LOGIN") as! Login_ViewController
            self.navigationController?.pushViewController(loginVC, animated: true)
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
