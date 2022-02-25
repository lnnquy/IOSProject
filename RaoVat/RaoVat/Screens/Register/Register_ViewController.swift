//
//  Register_ViewController.swift
//  RaoVat
//
//  Created by Lê Nguyễn Ngọc Quý on 9/12/20.
//  Copyright © 2020 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import UIKit

class Register_ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnRegister.layer.cornerRadius = 8
        imgAvatar.layer.cornerRadius = imgAvatar.frame.width/2
        let tap = UITapGestureRecognizer(target: self, action: #selector(openGalery))
        imgAvatar.addGestureRecognizer(tap)
        imgAvatar.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
//        txtName.text = "Ngoc Quy"
//        txtEmail.text = "lnnquy1993@gmail.com"
//        txtPhone.text = "0935333354"
//        txtPassword.text = "12345678"
        txtPassword.textContentType = .oneTimeCode
        spinnerView.isHidden = true
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
    @IBAction func Register(_ sender: Any) {
        spinnerView.isHidden = false
        spinnerView.startAnimating()
        //Check User Task
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
                    if json["kq"] as! Int == 1 {
                        let url = URL(string: Config.URLConnect + "/uploadFile")
                        let boundary = UUID().uuidString
                        let session = URLSession.shared
                        var urlRequest = URLRequest(url: url!)
                        urlRequest.httpMethod = "POST"
                        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                        var data = Data()
                        DispatchQueue.main.sync {
                            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                            data.append("Content-Disposition: form-data; name=\"avatar\"; filename=\"avatar.png\"\r\n".data(using: .utf8)!)
                            data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
                            data.append((self.imgAvatar.image?.pngData())!)
                            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
                        }

                        //Upload Task
                        session.uploadTask(with: urlRequest, from: data) { (data, response, err) in
                            if err == nil {
                                let jsonData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                                if let json = jsonData as? [String:Any] {
                                    if json["kq"] as! Int == 1 {
                                        
                                        //Register Task
                                        let urlFile = json["urlFile"] as? [String:Any]
                                        let url = URL(string: Config.URLConnect + "/register")
                                        var req = URLRequest(url: url!)
                                        req.httpMethod = "POST"
                                        let filename = urlFile!["filename"] as! String
                                        DispatchQueue.main.sync {
                                            let str:String = "name=\(self.txtName.text!)&email=\(self.txtEmail.text!)&phone=\(self.txtPhone.text!)&password=\(self.txtPassword.text!)&image=\(filename)"
                                            let dt = str.data(using: .utf8)
                                            req.httpBody = dt
                                            let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
                                                guard error == nil else {print(error);return}
                                                guard let data = data else {return}
                                                do {
                                                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {return}
                                                    if json["kq"] as! Int == 1 {
                                                        DispatchQueue.main.async {
                                                            let alert = UIAlertController(title: "Thông báo", message: "Đăng kí thành công. ", preferredStyle: UIAlertController.Style.alert)
                                                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { (cancel) in
                                                                let sb = UIStoryboard(name: "Main", bundle: nil)
                                                                let loginVC = sb.instantiateViewController(withIdentifier: "LOGIN") as! Login_ViewController
                                                                self.navigationController?.pushViewController(loginVC, animated: true)
                                                            }))
                                                            self.present(alert, animated: true, completion: nil)
                                                        }
                                                    }
                                                }catch let error {print(error.localizedDescription)}
                                            }.resume()
                                        }
                                    }
                                }
                            }
                        }.resume()
                    }else {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Error", message: "Email or Phone Number is available", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { (cancel) in
                                self.spinnerView.isHidden = true
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }.resume()
        
        
    }
    @IBAction func SignIn(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = sb.instantiateViewController(withIdentifier: "LOGIN") as! Login_ViewController
        self.navigationController?.pushViewController(loginVC, animated: true)
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
