//
//  OrderManageModel.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/3/31.
//  Copyright © 2016年 黄人煌. All rights reserved.
//

import Foundation

class  orderMageeModel:NSObject {
    
    var orderNo:String!
    var shopName:String!
    var totalAmt:Double!
    var createDateString:String!
    var arriveTimeString:String?
    var orderStatu:String!
    var address:String!
    var tel:String!
    var userName:String!
    var memo:String?
    var orderList:[orderDetailCust]! = []
    
    convenience init(dict:[String:AnyObject]){
        self.init()
        self.orderNo = dict["orderNo"] as! String
        self.shopName = dict["shopName"] as! String
        self.totalAmt = dict["totalAmt"] as! Double
        self.createDateString = dict["createDateString"] as! String
        self.arriveTimeString = dict["arriveTimeString"] as? String
        self.orderStatu = dict["orderStatu"] as! String
        self.address = dict["address"] as! String
        self.tel = dict["tel"] as! String
        self.userName = dict["userName"] as! String
        self.memo = dict["memo"] as? String
        let array = dict["orderDetailCust"]! as! NSArray
        for x in array {
            self.orderList.append(orderDetailCust(dict: x as! [String : AnyObject]))
        }
    }
}

struct orderDetailCust {
    var orderSn:Int!
    var orderNo:String?
    var itemName:String!
    var discount:Double?
    var realPrice:Double!
    var subQty:Int!
    init(dict:[String:AnyObject]){
        self.orderSn = dict["orderSn"] as! Int
        self.orderNo = dict["orderNo"] as? String
        self.itemName = dict["itemName"] as! String
        self.discount = dict["discount"] as? Double
        self.realPrice = dict["realPrice"] as! Double
        self.subQty = dict["subQty"] as! Int
    }
}

class afterApplyModel: NSObject {
    var applyNo:String!
    var orderNo:String!
    var orderSn:Int!
    var applyNum:Int!
    var applyReason:String!
    var applyTime:Int!
    var applyTimeString:String!
    var applyType:String!
    var appFlag:String!
    var shopNo:String!
    var custNo:String!
    var itemName:String!
    var nowPack:String!
    var username:String!
    var shopName:String!
    convenience init(dict:[String:AnyObject]){
        self.init()
        self.applyNo = dict["applyNo"] as! String
        self.orderNo = dict["orderNo"] as! String
        self.orderSn = dict["orderSn"] as! Int
        self.applyNum = dict["applyNum"] as! Int
        self.applyReason = dict["applyReason"] as! String
        self.applyTimeString = dict["applyTimeString"] as! String
        self.applyTime = dict["applyTime"] as! Int
        self.applyType = dict["applyType"] as! String
        self.appFlag = dict["appFlag"] as! String
        self.shopNo = dict["shopNo"] as! String
        self.custNo = dict["custNo"] as! String
        self.itemName = dict["itemName"] as! String
        self.nowPack = dict["nowPack"] as! String
        self.username = dict["username"] as! String
        self.shopName = dict["shopName"] as! String
    }
}