//
//  Home_ViewController.swift
//  RaoVat
//
//  Created by Lê Nguyễn Ngọc Quý on 9/19/20.
//  Copyright © 2020 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import UIKit

class Home_ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var ViewTop: UIView!
    @IBOutlet weak var cateCV: UICollectionView!
    @IBOutlet weak var myCView: UICollectionView!
    @IBOutlet weak var spinerView: UIActivityIndicatorView!
    
    var arrPost:[Post] = []
    var arrCate:[Category] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ViewTop.layoutIfNeeded()
        ViewTop.roundCorners([.bottomLeft,.bottomRight], radius: 50)
        
        myCView.dataSource = self
        myCView.delegate = self
        cateCV.dataSource = self
        cateCV.delegate = self
        spinerView.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        self.tabBarController?.tabBar.isHidden = false
        
    }
    func loadData(){
        spinerView.isHidden = false
        spinerView.startAnimating()
        let url = URL(string: Config.URLConnect + "/post/list")
        var req = URLRequest(url: url!)
        req.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            guard error == nil else {print(error);return}
            guard let data = data else {return}
            
            do {
                let json = try JSONDecoder().decode(Post_Route.self, from: data)
                if(json.kq == 1) {
                    self.arrPost = json.PostList
                    //Load Category list
                    let url = URL(string: Config.URLConnect + "/category/list")
                    var req = URLRequest(url: url!)
                    req.httpMethod = "POST"
                    let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
                        guard error == nil else {print(error);return}
                        guard let data = data else {return}
                        
                        do {
                            let json = try JSONDecoder().decode(CategoryPostRoute.self, from: data)
                            if(json.kq == 1) {
                                self.arrCate = json.CateList
                                DispatchQueue.main.async {
                                    self.spinerView.isHidden = true
                                    self.myCView.reloadData()
                                    self.cateCV.reloadData()
                                }
                            }
                            
                        }catch let error {print(error.localizedDescription)}
                    }.resume()
                }
                
            }catch let error {print(error.localizedDescription)}
        }.resume()
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == myCView) {
            return arrPost.count
        }else {
            return arrCate.count
        }
        
    }
    
    var selectedIndex:Int?
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == myCView {
            let cell = myCView.dequeueReusableCell(withReuseIdentifier: "HOME_CELL", for: indexPath) as! Home_CollectionViewCell
            cell.lbTitle.text = arrPost[indexPath.row].Title
            cell.lbPrice.text = arrPost[indexPath.row].Price + " " + "đ"
            let urlImage = Config.URLConnect + "/upload/" + self.arrPost[indexPath.row].Image[0]
            do {
                let imageData = try Data(contentsOf: URL(string: urlImage)!)
                cell.imgPost.image = UIImage(data: imageData)
            }catch let error {print(error.localizedDescription)}
            return cell
        }else {
            let cell = cateCV.dequeueReusableCell(withReuseIdentifier: "CATELIST_CV", for: indexPath) as! CateList_CollectionViewCell
            cell.lbNameCate.text = arrCate[indexPath.row].Name
            if selectedIndex == indexPath.row
            {
                cell.lbNameCate.textColor = .white
                cell.imgCate.layer.borderColor = UIColor.white.cgColor
                cell.imgCate.layer.borderWidth = 5
                }
            else
            {
                cell.lbNameCate.textColor = .black
                cell.imgCate.layer.borderWidth = 0
                    
            }
            
            let urlImage = Config.URLConnect + "/upload/" + self.arrCate[indexPath.row].Image
            do {
                let imageData = try Data(contentsOf: URL(string: urlImage)!)
                cell.imgCate.image = UIImage(data: imageData)
            }catch let error {print(error.localizedDescription)}
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView == myCView) {
            return CGSize(width: self.view.frame.width/2 - 16, height: (self.view.frame.width/2)+8)
        }else {
            return CGSize(width: 120 , height: 120)
        }
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView == myCView) {
            let View = arrPost[indexPath.item].View + 1
            let url = URL(string: Config.URLConnect + "/post/updateView")
            var req = URLRequest(url: url!)
            req.httpMethod = "POST"
            let str:String = "ID=\(arrPost[indexPath.item]._id)&VIEW=\(String(View))"
            let dt = str.data(using: .utf8)
            req.httpBody = dt
            let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
                guard error == nil else {print(error!);return}
                guard let data = data else {return}
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {return}
                    if(json["kq"] as! Int == 1) {
                        DispatchQueue.main.async {
                            let sb = UIStoryboard(name: "Main", bundle: nil)
                            let postDetailVC = sb.instantiateViewController(withIdentifier: "POSTDETAIL") as! PostDetail_ViewController
                            postDetailVC.post = self.arrPost[indexPath.item]
                            self.navigationController?.pushViewController(postDetailVC, animated: true)
                        }
                        
                    }
                }catch let error {print(error.localizedDescription)}
                    
               
            }.resume()
        }else {
            spinerView.isHidden = false
            spinerView.startAnimating()
            selectedIndex = indexPath.row
            cateCV.reloadData()
            let url = URL(string: Config.URLConnect + "/post/findIdCate")
            var req = URLRequest(url: url!)
            req.httpMethod = "POST"
            let str:String = "idCate=\(arrCate[indexPath.item]._id)"
            let dt = str.data(using: .utf8)
            req.httpBody = dt
            let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
                guard error == nil else {print(error);return}
                guard let data = data else {return}
                do {
                    let json = try JSONDecoder().decode(Post_Route.self, from: data)
                    if(json.kq == 1) {
                        self.arrPost = json.PostList
                        //Load Category list
                        DispatchQueue.main.async {
                            self.spinerView.isHidden = true
                            self.myCView.reloadData()
                        }
                    }
                    
                }catch let error {print(error.localizedDescription)}
            }.resume()
            
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

