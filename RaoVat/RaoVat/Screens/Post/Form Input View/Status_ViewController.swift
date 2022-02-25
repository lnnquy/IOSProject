//
//  Status_ViewController.swift
//  RaoVat
//
//  Created by Lê Nguyễn Ngọc Quý on 9/18/20.
//  Copyright © 2020 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import UIKit

protocol Status_Delegate {
    func SelectStatus(idStatus:String,nameStatus:String)
}

class Status_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var delegate:Status_Delegate?
    @IBOutlet weak var myTable: UITableView!
    var arrStatus:[Status] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate = self
        myTable.dataSource = self
        LoadData()
        // Do any additional setup after loading the view.
    }
    func LoadData(){
        let url = URL(string: Config.URLConnect + "/status/list")
        var req = URLRequest(url: url!)
        req.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            guard error == nil else {print(error);return}
            guard let data = data else {return}
            do {
                let json = try JSONDecoder().decode(Status_Route.self, from: data)
                self.arrStatus = json.StatusList
                DispatchQueue.main.async {
                    self.myTable.reloadData()
                }
            }catch let error {print(error.localizedDescription)}
        }.resume()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrStatus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableCell(withIdentifier: "STATUS_CELL") as! Status_TableViewCell
        cell.Title.text = arrStatus[indexPath.row].Name
        cell.Details.text = arrStatus[indexPath.row].Details
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.SelectStatus(idStatus: arrStatus[indexPath.row]._id, nameStatus: arrStatus[indexPath.row].Name)
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
