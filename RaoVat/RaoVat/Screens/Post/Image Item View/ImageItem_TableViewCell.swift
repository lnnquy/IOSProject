//
//  ImageItem_TableViewCell.swift
//  RaoVat
//
//  Created by Lê Nguyễn Ngọc Quý on 9/19/20.
//  Copyright © 2020 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import UIKit

protocol ImageItem_Delegate {
    func selectImage(index:Int)
}
class ImageItem_TableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    var delegate:ImageItem_Delegate?
    @IBOutlet weak var myCview: UICollectionView!
    var arrImage:[UIImage] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myCview.dataSource = self
        myCview.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImage.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCview.dequeueReusableCell(withReuseIdentifier: "IMAGE_CELL", for: indexPath) as! ImageItem_CollectionViewCell
        cell.imgItem.image = arrImage[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectImage(index: indexPath.row)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.myCview.frame.height, height: self.myCview.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -10
    }

}
