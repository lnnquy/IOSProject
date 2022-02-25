//
//  City.swift
//  RaoVat
//
//  Created by Lê Nguyễn Ngọc Quý on 9/18/20.
//  Copyright © 2020 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import Foundation

struct City_Route:Decodable {
    var kq:Int
    var CityList:[City]
}
struct City :Decodable {
    var _id : String
    var Name : String
}
