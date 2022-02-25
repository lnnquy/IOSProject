//
//  Location_Post_ViewController.swift
//  RaoVat
//
//  Created by Lê Nguyễn Ngọc Quý on 9/17/20.
//  Copyright © 2020 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import UIKit

protocol City_Delegate {
    func selectCity (idCity:String,nameCity:String)
}

class Location_Post_ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var delegate:City_Delegate?
    
    @IBOutlet weak var myTable: UITableView!
    var arrCity:[City] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.dataSource = self
        myTable.delegate = self
        LoadData()
        // Do any additional setup after loading the view.
    }
    func LoadData(){
        let url = URL(string: Config.URLConnect + "/city")
        var req = URLRequest(url: url!)
        req.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            guard error == nil else {print(error);return}
            guard let data = data else {return}
            do {
                let json = try JSONDecoder().decode(City_Route.self, from: data)
                self.arrCity = json.CityList
                DispatchQueue.main.async {
                    self.myTable.reloadData()
                }
            }catch let error {print(error.localizedDescription)}
        }.resume()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableCell(withIdentifier: "LOCATION_CELL") as! Location_TableViewCell
        cell.textLabel?.text = arrCity[indexPath.row].Name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectCity(idCity: arrCity[indexPath.row]._id, nameCity: arrCity[indexPath.row].Name)
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
