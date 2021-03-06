//
//  Model.swift
//  Demo
//
//  Created by Jason on 3/4/16.
//  Copyright © 2016 Fjnu. All rights reserved.
//

import UIKit
import SVProgressHUD
class GiftModel: NSObject {
    var name:String!
    var no:String!
    var type:String!//礼券的类别
    var shopName:String?//商店名称
    var shopNo:String?//商店编号
    var amt:Int!//礼券面额
    var minMoney:Int!//礼券最少使用金额
    var start:String!//开始时间
    var end:String!//结束时间
    var status:Int!//使用状态 0、未领取 1、可使用  2、已使用 3 已过期
    var stampNo:String!//礼券编号
    var stampFlowNo: Int?//流水号
    
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
    
    
    convenience init(name:String,no:String,type:String,shopName:String? = nil,shopNo:String? = nil,amt:Int,minMoney:Int,start:String,end:String,status:Int!,stampNo:String!,stampFlowNo: Int){
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
        self.status = status
        self.stampNo = stampNo
        self.stampFlowNo = stampFlowNo
    }
    
    convenience init(dict:[String:AnyObject]){
        self.init()
        self.name = dict["stampTypeName"] as! String
        self.no = dict["shopNo"] as! String
        self.shopName = dict["shopName"] as? String
        self.shopNo = dict["shopNo"] as? String
        self.type = dict["stampTypeNo"] as! String
        self.amt = dict["stampAmt"] as! Int
        self.minMoney = dict["minOrderAmt"] as! Int
        self.start = dict["startValidDate_String"] as! String
        self.end = dict["endValidDate_String"] as! String
        self.status = Int((dict["status"] as! String))
        self.stampNo = dict["stampNo"] as! String
    }
    
    /**
     类方法来可领取礼券的一个集合
     
     - parameter shopNo: 商店的编号
     
     - returns: 返回一个二元组
     result 表示返回的情况
     0 正常成功 1 未登录 2 其他
     */
    class func getAllGiftList(callback:(result:Int,list:[GiftModel]?) -> Void){
        let userNo = UserAccountTool.getUserCustNo()
        HTTPManager.POST(.StampList, params:["custNo":userNo == nil ? "":userNo!,"shopNo":""]).responseJSON({ (json) -> Void in
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
                SVProgressTool.showErrorSVProgress("出错了")
                callback(result: 2, list: nil)
        }
    }
    
    class func getUserGiftsListWithShopNo(shopNo:String?,callback:(result:Int,list:[GiftModel]?) -> Void) {
        let userNo = UserAccountTool.getUserCustNo()
        if(userNo == nil){
            callback(result: 1,list:nil)
        }
        else {
        HTTPManager.POST(.UserStamp, params: ["custNo":userNo!,"shopNo":shopNo == nil ? "" : shopNo!]).responseJSON({ (json) -> Void in
            if(json["message"] as! String == "success"){
                let array = json["stamps"] as! NSArray
                var objects = [GiftModel]()
                for x in array{
                    let item = GiftModel(dict: x as! [String:AnyObject])
                    item.stampFlowNo = x["stampFlowNo"] as? Int
                    objects.append(item)
                }
                callback(result: 0, list: objects)
            }else{
                callback(result: 2, list: nil)
            }
            }) { (error) -> Void in
                SVProgressTool.showErrorSVProgress("出错了")
                callback(result: 2, list: nil)
        }
        } 
    }
    
//    class func usedGift(
    
    func getGift(stampNo:String,callback:(result:String) -> Void){
        let userNo = UserAccountTool.getUserCustNo()!
        HTTPManager.POST(.GetStamp, params: ["custNo":userNo,"stampNo":stampNo]).responseJSON({ (json) -> Void in
            callback(result: json["message"] as! String)
            }) { (error) -> Void in
                SVProgressTool.showErrorSVProgress("出错了")
                SVProgressHUD.dismiss()
                print("发生了错误" + (error?.localizedDescription)!)
        }
    }
    
}
