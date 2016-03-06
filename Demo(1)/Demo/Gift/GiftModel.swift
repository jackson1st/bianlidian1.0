//
//  Model.swift
//  Demo
//
//  Created by Jason on 3/4/16.
//  Copyright © 2016 Fjnu. All rights reserved.
//

import UIKit

class GiftModel: NSObject {
    var name:String!
    var no:String!
    var type:String!//礼券的类别
    var shopName:String?//商店名称
    var shopNo:String?//商店编号
    var amt:Double!//礼券面额
    var minMoney:Double!//礼券最少使用金额
    var start:String!//开始时间
    var end:String!//结束时间
    var state:Int?//使用状态 0、未领取 1、可使用  2、已使用 3 已过期
    
    static var formatter:NSDateFormatter = {
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        return format
    }()
    
    var startTime:NSDate {
        return GiftModel.formatter.dateFromString(start)!
    }
    var endTime:NSDate {
        return GiftModel.formatter.dateFromString(end)!
    }
    
    
    convenience init(name:String,no:String,type:String,shopName:String? = nil,shopNo:String? = nil,amt:Double,minMoney:Double,start:String,end:String,state:Int?){
        self.init()
        self.name = name
        self.no = no
        self.type = type
        self.shopName = shopName
        self.shopNo = shopNo
        self.amt = amt
        self.minMoney = minMoney
        self.start = start
        self.end = end
        self.state = state
    }
    
    convenience init(dict:[String:AnyObject]){
        self.init()
        self.name = dict["stampTypeName"] as! String
        self.no = dict["shopNo"] as! String
        self.shopName = dict["shopName"] as? String
        self.shopNo = dict["shopNo"] as? String
        self.type = dict["stampTypeNo"] as! String
        self.amt = dict["stampAmt"] as! Double
        self.minMoney = dict["minOrderAmt"] as! Double
        self.start = dict["startValidDate_String"] as! String
        self.end = dict["endValidDate_String"] as! String
        self.state = dict["status"] as? Int
    }
    
    /**
     类方法来可领取礼券的一个集合
     
     - parameter shopNo: 商店的编号
     
     - returns: 返回一个二元组
     result 表示返回的情况
     0 正常成功 1 未登录 2 其他
     */
    class func getAllGiftList(callback:(result:Int,list:[GiftModel]?) -> Void){
        HTTPManager.POST(.StampList, params:["custNo":"","shopNo":""]).responseJSON({ (json) -> Void in
            if(json["message"] as! String == "success"){
                let array = json["stamps"] as! NSArray
                var objects = [GiftModel]()
                for x in array{
                    objects.append(GiftModel(dict: x as! [String:AnyObject]))
                }
                callback(result: 0, list: objects)
            }else{
                callback(result: 2, list: nil)
            }
            }) { (error) -> Void in
                callback(result: 2, list: nil)
        }
    }
    
    class func getUserGiftsListWithShopNo(shopNo:String,callback:(result:Int,list:[GiftModel]?) -> Void) {
        let userNo = UserAccountTool.getUserCustNo()
        if(userNo == nil){
            callback(result: 1,list:nil)
        }
        HTTPManager.POST(.StampList, params: ["custNo":userNo!,"shopNo":shopNo]).responseJSON({ (json) -> Void in
            if(json["message"] as! String == "success"){
                let array = json["stamps"] as! NSArray
                var objects = [GiftModel]()
                for x in array{
                    objects.append(GiftModel(dict: x as! [String:AnyObject]))
                }
                callback(result: 0, list: objects)
            }else{
                callback(result: 2, list: nil)
            }
            }) { (error) -> Void in
                callback(result: 2, list: nil)
        }
    }
    
//    class func usedGift(
    
    class func getGift(stampNo:String,callback:(result:String) -> Void){
        let userNo = UserAccountTool.getUserCustNo()!
        HTTPManager.POST(.GetStamp, params: ["custNo":userNo,"stampNo":stampNo]).responseJSON({ (json) -> Void in
            callback(result: json["message"] as! String)
            }) { (error) -> Void in
                print("发生了错误" + (error?.localizedDescription)!)
        }
    }
    
}
