//
//  HomeItemModel.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/3/19.
//  Copyright © 2016年 黄人煌. All rights reserved.
//

import Foundation


class HomeItemModel: NSObject {
    var bigclass: [bigClass]! = []
    var listhot: listHot!
    var adlist: adList!
    var listcx: listCx!
    convenience init(dict:[String:AnyObject]) {
        self.init()
        if let array = dict["listhot"] as? NSArray {
            var listHOT: [itemList] = []
            for x in array {
                listHOT.append(itemList(dict: x as! [String : AnyObject]))
            }
            self.listhot = listHot(itemlist: listHOT)
        }
        if let array = dict["adlist"] as? NSArray {
            self.adlist = adList(url: array as! [String])
        }
        if let array = dict["listcx"] as? NSArray {
            var listCX: [itemList] = []
            for x in array {
                listCX.append(itemList(dict: x as! [String : AnyObject]))
            }
            self.listcx = listCx(itemlist: listCX)
        }
        if let array = dict["bigclass"] as? NSArray {
            for x in array {
                
                let bg = bigClass(dict: x as! [String : AnyObject])
                if bg.itemlist.count >= 3 {
                    self.bigclass.append(bg)
                }
            }
        }
    }
}

class listHot: NSObject{
    var itemlist: [itemList] = []
    convenience init(itemlist: [itemList]){
        self.init()
        self.itemlist = itemlist
    }
}
class listCx: NSObject {
    var itemlist: [itemList] = []
    convenience init(itemlist: [itemList]){
        self.init()
        self.itemlist = itemlist
    }
}



class adList: NSObject {
    var adlist: [String]?
    convenience init(url:[String]){
        self.init()
        self.adlist = url
    }
}


class bigClass: NSObject {
    var itemclass:String!
    var classname:String!
    var itemlist:[itemList]! = []
    convenience init(dict:[String:AnyObject]){
        self.init()
        self.itemclass = dict["itemclass"] as! String
        self.classname = dict["classname"] as! String
        if let array = dict["itemlist"] as? NSArray {
            for x in array {
                self.itemlist.append(itemList(dict: x as! [String:AnyObject]))
            }
        }
    }
}


class itemList: NSObject {
    var itemNo:String!
    var itemName:String!
    var barcode:String!
    var itemBynum1:String!
    var itemSalePrice:String!
    var itemSize:String?
    var itemUnitNo:String?
    var eshopIntegral:String?
    var url:String!
    var itemUnits:String?
    var className:String?
    var discountPrice:String?
    convenience init(dict:[String:AnyObject]) {
        self.init()
        self.itemNo = dict["itemNo"] as! String
        self.itemName = dict["itemName"] as! String
        self.barcode = dict["barcode"] as! String
        self.itemBynum1 = dict["itemBynum1"] as? String
        self.itemSalePrice = dict["itemSalePrice"] as! String
        self.itemSize = dict["itemSize"] as? String
        self.itemUnitNo = dict["itemUnitNo"] as? String
        self.eshopIntegral = dict["eshopIntegral"] as? String
        self.url = dict["url"] as! String
        self.itemUnits = dict["itemUnits"] as? String
        self.className =  dict["className"] as? String
        self.discountPrice = dict["discountPrice"] as? String
    }
    //*************************商品模型辅助属性**********************************
    // 记录用户对商品添加次数
    var userBuyNumber: Int = 0
    var number: Int = 1
//    "itemName": "RIO西柚伏特加500ml",
//    "barcode": "6935145313026",
//    "itemBynum1": null,
//    "itemSalePrice": "10.000000",
//    "discountPrice": null,
//    "itemSize": null,
//    "itemUnitNo": null,
//    "eshopIntegral": null,
//    "images": null,
//    "url": "http://192.168.113.14:8080/BSMD/Android/image/index_img_i1.png",
//    "itemUnits": null,
//    "className": "果汁类酒"
}

class Activities: NSObject {
    var id: String? = "20575"
    var name: String? = "年货大集"
    var img: String? = "http://img01.bqstatic.com/upload/activity/activity_v4_20575_1452217080_block.jpg@90Q"
    var topimg: String? = "http://img01.bqstatic.com/upload/activity/activity_v4_20575_1452217080_top.jpg@90Q"
    var jptype: String? = "1"
    var trackid: String? = "icon1|20206"
    var mimg: String? = "http://img01.bqstatic.com/upload/activity/activity_v4_20575_1452217080_mblock.jpg@90Q"
    var customURL: String? = "https://github.com/ZhongTaoTian"

}