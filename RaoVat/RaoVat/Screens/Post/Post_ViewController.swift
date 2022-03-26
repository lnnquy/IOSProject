//
//  Post_ViewController.swift
//  RaoVat
//
//  Created by Lê Nguyễn Ngọc Quý on 9/17/20.
//  Copyright © 2020 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import UIKit

extension Post_ViewController:Category_Delegate,City_Delegate,Status_Delegate,ImageItem_Delegate,FormItem_Delegate {
    func pushDescription(Des: String) {
        self.textDes = Des
    }
    
    func pushTitle(Title: String) {
        self.textTitle = Title
    }
    
    func pushPrice(Price: String) {
        self.textPrice = Price
    }

    func selectViewLabel(index: Int) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        switch index {
        case 1:
            let cateVC = sb.instantiateViewController(withIdentifier: "CATEGORY_POST") as! Category_Post_ViewController
            cateVC.delegate = self
            self.navigationController?.pushViewController(cateVC, animated: true)
            break
        case 2 :
            let statusVC = sb.instantiateViewController(withIdentifier: "STATUS") as! Status_ViewController
            statusVC.delegate = self
            self.navigationController?.pushViewController(statusVC, animated: true)
            break
        case 3 :
            let cityVC = sb.instantiateViewController(withIdentifier: "LOCATION") as! Location_Post_ViewController
            cityVC.delegate = self
            self.navigationController?.pushViewController(cityVC, animated: true)
            break
        default:
            return
        }
    }
    
    func selectImage(index: Int) {
        if index == 0 {
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerController.SourceType.photoLibrary
            image.allowsEditing = false
            self.present(image,animated: true)
        }
    }

    func SelectStatus(idStatus: String, nameStatus: String) {
        self.navigationController?.popViewController(animated: true)
        self.idStatus = idStatus
        valueStatus = nameStatus
        self.myTable.reloadData()
    }
    
    func selectCity(idCity: String, nameCity: String) {
        self.navigationController?.popViewController(animated: true)
        self.idCity = idCity
        valueCity = nameCity
        self.myTable.reloadData()
    }
    
    func selectCate(idCate: String, nameCate: String) {
        self.navigationController?.popViewController(animated: true)
        self.idCate = idCate
        valueCate = nameCate
        self.myTable.reloadData()
    }
}

class Post_ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate {
    
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var myTable: UITableView!
    var textPrice:String = ""
    var textTitle:String = ""
    var textDes:String = ""
    var valueStatus = ">"
    var valueCate = ">"
    var valueCity = ">"
    var idCate : String = ""
    var idCity:String = ""
    var idStatus:String = ""
    var idUser:String = ""
    var listImage:[UIImage] = [UIImage(named: "img_item")!]
    override func viewDidLoad() {
        super.viewDidLoad()
        spinnerView.isHidden = true
        self.navigationItem.hidesBackButton = true
        myTable.dataSource = self
        myTable.delegate = self
        btnPost.layer.cornerRadius = 8
        self.view.backgroundColor = .systemYellow
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        checkLogin()
        self.navigationController?.isNavigationBarHidden = false
    }
    func clearField(){
        self.textPrice = ""
        self.textTitle = ""
        self.textDes = ""
        self.valueStatus = ">"
        self.valueCate = ">"
        self.valueCity = ">"
        self.idCate = ""
        self.idCity = ""
        self.idStatus = ""
        self.idUser = ""
        self.listImage = [UIImage(named: "img_item")!]
        self.myTable.reloadData()
        self.tabBarController?.selectedIndex = 2
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
                        }else {
                            self.spinnerView.isHidden = true
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = myTable.dequeueReusableCell(withIdentifier: "IMAGEITEM_CELL") as! ImageItem_TableViewCell
            cell.arrImage = listImage
            cell.myCview.reloadData()
            cell.delegate = self
            return cell
        }else {
            let cell = myTable.dequeueReusableCell(withIdentifier: "FORMITEM_CELL") as! FormItem_TableViewCell
            cell.lbStatusValue.text = valueStatus
            cell.lbLocationValue.text = valueCity
            cell.lbCateValue.text = valueCate
            cell.txtNameItem.text = textTitle
            cell.txtPriceItem.text = textPrice
            cell.tvDescription.text = textDes
            cell.delegate = self
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 120
        }else {
            return 500
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue:
            UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            
            listImage.append(image)
            self.myTable.reloadData()
        }else { return }
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func Post(_ sender: Any) {
        spinnerView.isHidden = false
        spinnerView.startAnimating()
        var arrNameImg:[String] = []
        if (listImage.count == 1) {
            let alert = UIAlertController(title: "Thông báo", message: "Vui lòng chọn ít nhất 1 hình. ", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { (cancel) in

            }))
            self.present(alert, animated: true, completion: nil)
        }else {
            for i in 1 ..< listImage.count {
                DispatchQueue(label: "upload").sync {
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
                    data.append((self.listImage[i].pngData())!)
                    data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
                    //Upload Task
                    session.uploadTask(with: urlRequest, from: data) { (data, response, err) in
                        guard err == nil else {print(err!);return}
                        guard let data = data else {return}
                        let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        if let json = jsonData as? [String:Any] {
                            
                            guard json["kq"] as! Int == 1 else {
                                print(json["errMsg"] ?? "Error upload task!!")
                                return
                            }
                            let urlFile = json["urlFile"] as? [String:Any]
                            let filename = urlFile!["filename"] as! String
                            arrNameImg.append(filename)
                            if(i == self.listImage.count - 1) {
                                
                                let url = URL(string: Config.URLConnect + "/post/add")
                                var req = URLRequest(url: url!)
                                req.httpMethod = "POST"
                                var str:String = "Title=\(self.textTitle)&Price=\(self.textPrice)&Description=\(self.textDes)&UserID=\(self.idUser)&CateID=\(self.idCate)&CityID=\(self.idCity)&StatusID=\(self.idStatus)"
                                for i in 0...arrNameImg.count - 1 {
                                    str += "&Image=\(arrNameImg[i])"
                                }
                                
                                let dt = str.data(using: .utf8)
                                req.httpBody = dt
                                let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
                                    guard error == nil else {print(error ?? "ERROR POST TASK");return}
                                    guard let data = data else {return}
                                    do {
                                        guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {return}
                                        if json["kq"] as! Int == 1 {
                                            DispatchQueue.main.async {
                                                let alert = UIAlertController(title: "Thông báo", message: "Post bài thành công. ", preferredStyle: UIAlertController.Style.alert)
                                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { (cancel) in
                                                    self.spinnerView.isHidden = true
                                                    self.clearField()
                                                }))
                                                self.present(alert, animated: true, completion: nil)
                                            }
                                        }
                                    }catch let error {print(error.localizedDescription)}
                                }
                                task.resume()
                            }
                            
                        }
                    }.resume()
                }
            }
        }
    }
    

}
