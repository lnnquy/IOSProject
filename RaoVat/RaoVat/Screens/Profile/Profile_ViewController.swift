//
//  Profile_ViewController.swift
//  RaoVat
//
//  Created by Lê Nguyễn Ngọc Quý on 9/13/20.
//  Copyright © 2020 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import UIKit

class Profile_ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var viewTop: UIView!
    
    var name:String = ""
    var email:String = ""
    var phone:String = ""
    var id:String = ""
    var image:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTop.layer.cornerRadius = 10
        txtEmail.isEnabled = false
        imgAvatar.layer.cornerRadius = imgAvatar.frame.width/2
        let tap = UITapGestureRecognizer(target: self, action: #selector(openGalery))
        imgAvatar.addGestureRecognizer(tap)
        imgAvatar.isUserInteractionEnabled = true
        txtName.text = name
        txtEmail.text = email
        txtPhone.text = phone
        let urlImage = Config.URLConnect + "/upload/" + image
        do {
            let imageData = try Data(contentsOf: URL(string: urlImage)!)
            self.imgAvatar.image = UIImage(data: imageData)
        }catch let error {print(error.localizedDescription)}
        //self.navigationItem.hidesBackButton = true
        checkLogin()
        // Do any additional setup after loading the view.
    }
    @objc func openGalery(){
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image,animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue:
            UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            imgAvatar.image = image
        }else { return }
        self.dismiss(animated: true, completion: nil)
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
    
    @IBAction func Save(_ sender: Any) {
        let url = URL(string: Config.URLConnect + "/FindUser")
        var req = URLRequest(url: url!)
        req.httpMethod = "POST"
        let str:String = "email=\(txtEmail.text!)"
        let dt = str.data(using: .utf8)
        req.httpBody = dt
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                if let json = jsonData as? [String:Any] {
                    if json["kq"] as! Int == 2 {
                        let urlImage = Config.URLConnect + "/upload/" + self.image
                        do {
                            let imageData = try Data(contentsOf: URL(string: urlImage)!)
                            DispatchQueue.main.async {
                                if (self.imgAvatar.image?.pngData() == imageData) {
                                    
                                    //Update Profile Task
                                    self.updateTask(img: self.image)
                                }else {
                                    let url = URL(string: Config.URLConnect + "/uploadFile")
                                    let boundary = UUID().uuidString
                                    let session = URLSession.shared
                                    var urlRequest = URLRequest(url: url!)
                                    urlRequest.httpMethod = "POST"
                                    urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                                    var data = Data()
                                    data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                                    data.append("Content-Disposition: form-data; name=\"avatar\"; filename=\"avatar.png\"\r\n".data(using: .utf8)!)
                                    data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
                                    data.append((self.imgAvatar.image?.pngData())!)
                                    data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
                                    //Upload Task
                                    session.uploadTask(with: urlRequest, from: data) { (data, response, err) in
                                        if err == nil {
                                            let jsonData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                                            if let json = jsonData as? [String:Any] {
                                                if json["kq"] as! Int == 1 {
                                                    let urlFile = json["urlFile"] as? [String:Any]
                                                    let filename = urlFile!["filename"] as! String
                                                    //Update Profile Task
                                                    self.updateTask(img: filename)
                                                }
                                            }
                                        }
                                    }.resume()
                                }
                            }
                            
                        }catch let error {print(error.localizedDescription)}
                        
                    }else {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Error", message: "User Error", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { (cancel) in
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                    }
                }
            }
        }.resume()
    }
    func updateTask(img:String){
        let url = URL(string: Config.URLConnect + "/updateUser")
        var req = URLRequest(url: url!)
        req.httpMethod = "POST"
        DispatchQueue.main.async {
             let str:String = "id=\(self.id)&name=\(self.txtName.text!)&email=\(self.txtEmail.text!)&phone=\(self.txtPhone.text!)&image=\(img)"
             let dt = str.data(using: .utf8)
            req.httpBody = dt
            let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
                guard error == nil else {print(error!);return}
                guard let data = data else {return}
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {return}
                    if json["kq"] as! Int == 1 {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Thông báo", message: "Thay đổi thông tin thành công. ", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { (cancel) in
                                let sb = UIStoryboard(name: "Main", bundle: nil)
                                let dashVC = sb.instantiateViewController(withIdentifier: "DASHBOARD") as! Dashboard_ViewController
                                self.navigationController?.pushViewController(dashVC, animated: true)
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                    }
                }catch let error {print(error.localizedDescription)}
            }.resume()
        }
           
            
            
            
        
    }
    @IBAction func ChangePassword(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let passVC = sb.instantiateViewController(withIdentifier: "PASSWORD") as! Password_ViewController
        passVC.id = self.id
        self.navigationController?.pushViewController(passVC, animated: true)
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
