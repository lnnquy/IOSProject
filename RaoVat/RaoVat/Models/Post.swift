//
//  Post.swift
//  RaoVat
//
//  Created by Lê Nguyễn Ngọc Quý on 9/19/20.
//  Copyright © 2020 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import Foundation

struct Post_Route:Decodable {
    var kq:Int
    var PostList:[Post]
}
struct Post:Decodable {
    var _id :String
    var Title:String
    var Price:String
    var Image:[String]
    var Description:String
    var User:String
    var Category:String
    var City:String
    var Status:String
    var Active:Bool
    var PostDate:String
    var View:Int
    
    init(id:String,title:String,price:String,image:[String],desscription:String,user:String,category:String,city:String,status:String,active:Bool,postDate:String,view:Int) {
        self._id = id
        self.Title = title
        self.Price = price
        self.Image = image
        self.Description = desscription
        self.User = user
        self.Category = category
        self.City = city
        self.Status = status
        self.Active = active
        self.PostDate = postDate
        self.View = view
    }
}
