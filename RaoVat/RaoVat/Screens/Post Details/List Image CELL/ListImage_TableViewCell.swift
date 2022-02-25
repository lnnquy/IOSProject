//
//  ListImage_TableViewCell.swift
//  RaoVat
//
//  Created by Lê Nguyễn Ngọc Quý on 9/19/20.
//  Copyright © 2020 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import UIKit

class ListImage_TableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var idPost:String = ""
    var arrImage:[String] = []
    @IBOutlet weak var myCView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        myCView.dataSource = self
        myCView.delegate = self
        
        // Initialization code
    }
    
    func loadData(id:String){
        
        let url = URL(string: Config.URLConnect + "/post/findID")
        var req = URLRequest(url: url!)
        req.httpMethod = "POST"
        let str:String = "ID=\(id)"
        let dt = str.data(using: .utf8)
        req.httpBody = dt
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            guard error == nil else {print(error!);return}
            guard let data = data else {return}
            do {
                let json = try JSONDecoder().decode(Post_Route.self, from: data)
                
                if(json.kq == 1) {
                    for post in json.PostList {
                        self.arrImage.append(contentsOf: post.Image) 
                    }
                    DispatchQueue.main.async {
                        self.myCView.reloadData()
                    }
                    
                }
                
            }catch let error {print(error.localizedDescription)}
        }.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCView.dequeueReusableCell(withReuseIdentifier: "LISTIMAGE_CV", for: indexPath) as! ListImage_CollectionViewCell
        let urlImage = Config.URLConnect + "/upload/" + self.arrImage[indexPath.row]
        do {
            let imageData = try Data(contentsOf: URL(string: urlImage)!)
            cell.imgList.image = UIImage(data: imageData)
        }catch let error {print(error.localizedDescription)}
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.contentView.frame.width - 50, height: 250)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
