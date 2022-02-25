//
//  Category_Post_ViewController.swift
//  RaoVat
//
//  Created by Lê Nguyễn Ngọc Quý on 9/17/20.
//  Copyright © 2020 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import UIKit

protocol Category_Delegate {
    func selectCate(idCate:String,nameCate:String)
}

class Category_Post_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var delegate:Category_Delegate?
    
    var arrCate:[Category] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        LoadData()
        // Do any additional setup after loading the view.
    }
    func LoadData(){
        let url = URL(string: Config.URLConnect + "/category/list")
        var req = URLRequest(url: url!)
        req.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            guard error == nil else {print(error);return}
            guard let data = data else {return}
            do {
                let json = try JSONDecoder().decode(CategoryPostRoute.self, from: data)
                self.arrCate = json.CateList
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }catch let error {print(error.localizedDescription)}
        }.resume()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrCate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CateCell = self.tableView.dequeueReusableCell(withIdentifier: "CATEGORY_CELL") as! Category_TableViewCell
        let urlImage = Config.URLConnect + "/upload/" + self.arrCate[indexPath.row].Image
        do {
            let imageData = try Data(contentsOf: URL(string: urlImage)!)
            CateCell.imgCategory.image = UIImage(data: imageData)
            CateCell.lbName.text = arrCate[indexPath.row].Name
        }catch let error {print(error.localizedDescription)}
        return CateCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height/4
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectCate(idCate: arrCate[indexPath.item]._id, nameCate: arrCate[indexPath.item].Name)
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
