//
//  UpImageModel.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/4/22.
//  Copyright © 2016年 黄人煌. All rights reserved.
//

import Foundation

class UpImageModel: NSObject {
    
    var itemName: String!
    var itemNo:String!
    var url: String?
    var topUrl: [String] = []
    var indexCount: Int!
    var roundCount: Int!
    
    convenience init(dict: NSDictionary) {
        self.init()
        self.itemName = dict["itemName"] as! String
        self.url = dict["url"] as? String
        self.topUrl = dict["topUrl"] as! Array
        self.indexCount = dict["indexCount"] as! Int
        self.roundCount = dict["roundCount"] as! Int
        self.itemNo = dict["itemNo"] as! String
    }
}