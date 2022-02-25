//
//  Status.swift
//  RaoVat
//
//  Created by Lê Nguyễn Ngọc Quý on 9/18/20.
//  Copyright © 2020 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import Foundation

struct Status_Route:Decodable {
    var kq:Int
    var StatusList:[Status]
}

struct Status:Decodable {
    var _id:String
    var Name:String
    var Details: String
}
