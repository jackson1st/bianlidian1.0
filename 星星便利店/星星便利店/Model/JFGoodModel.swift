//
//  JFGoodModel.swift
//  shoppingCart
//  Created by 黄人煌 on 15/12/28.
//  Copyright © 2015年 Fjnu. All rights reserved.


import UIKit

class Shop:NSObject, NSCoding{
    var shopName: String?
    var shopNo: String?

    override init(){
        super.init()
    }
    
    convenience init(shopName: String,shopNo: String = "NULL"){
        self.init()
        self.shopName = shopName
        self.shopNo = shopNo
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        shopName = aDecoder.decodeObjectForKey("shopName") as? String
        shopNo = aDecoder.decodeObjectForKey("shopNo") as? String
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(shopName, forKey: "shopName")
        aCoder.encodeObject(shopNo, forKey: "shopNo")
    }
    
}


//@objc(JFGoodModel)
class JFGoodModel: NSObject,NSCoding {
    var addDate: Int?
    var barcode: String?
    var custNo: String?
    var itemNo: String?
    var itemPack: Int?
    var shopNameList: [Shop]!
    
    var needUp: Bool = true
    // 是否可以选择
    var canChange: Bool = false
    
    // 是否已经加入购物车
    var alreadyAddShoppingCart: Bool = false
    
    // 商品图片名称
    var url: String?
    
    // 商品标题
    var itemName: String?
    
    // 商品描述
    var itemSize: String?
    
    // 商品购买个数,默认0
    var num: Int = 1
    
    // 新价格
    var  itemSalePrice: String?
    
    // 老价格
    var itemDistPrice: String?
    var totalPrice: Double?
    // 是否选中，默认没有选中
    var selected: Bool = true
    
    
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        addDate = aDecoder.decodeIntegerForKey("addDate")
        barcode = aDecoder.decodeObjectForKey("barcode") as? String
        custNo = aDecoder.decodeObjectForKey("custNo") as? String
        itemPack = aDecoder.decodeObjectForKey("itemPack") as? Int
        shopNameList = aDecoder.decodeObjectForKey("shopNameList") as! [Shop]
        canChange = aDecoder.decodeBoolForKey("canChange")
        alreadyAddShoppingCart = aDecoder.decodeBoolForKey("alreadyAddShoppingCart")
        url = aDecoder.decodeObjectForKey("url") as? String
        itemName = aDecoder.decodeObjectForKey("itemName") as? String
        itemSize = aDecoder.decodeObjectForKey("itemSize") as? String
        itemSalePrice = aDecoder.decodeObjectForKey("itemSalePrice") as? String
        itemDistPrice = aDecoder.decodeObjectForKey("itemDistPrice") as? String
        totalPrice = aDecoder.decodeDoubleForKey("totalPrice")
        selected = aDecoder.decodeBoolForKey("selected")
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger((addDate ?? 0), forKey: "addDate")
        aCoder.encodeObject((barcode ?? "无"), forKey: "barcode")
        aCoder.encodeObject((custNo ?? "无"), forKey: "custNo")
        aCoder.encodeObject((itemPack ?? 0), forKey: "itemPack")
        aCoder.encodeObject(shopNameList, forKey: "shopNameList")
        aCoder.encodeBool(canChange, forKey: "canChange")
        aCoder.encodeBool(alreadyAddShoppingCart, forKey: "alreadyAddShoppingCart")
        aCoder.encodeObject((url ?? "无"), forKey: "url")
        aCoder.encodeObject((itemName ?? "无"), forKey: "itemName")
        aCoder.encodeObject((itemSize ?? "无"), forKey: "itemSize")
        aCoder.encodeObject((itemSalePrice ?? "无"), forKey: "itemSalePrice")
        aCoder.encodeObject((itemDistPrice ?? "无"), forKey: "itemDistPrice")
        aCoder.encodeDouble(totalPrice!, forKey: "totalPrice")
        aCoder.encodeBool(selected, forKey: "selected")
    }

    
}
class ShopName: NSObject,NSCoding{
    var stockQty: Int?
    var shopName: String?
    var onArea: Bool?
    
    convenience init (stockQty: Int?,shopName: String?,onArea: Bool = true){
        self.init()
        self.stockQty = stockQty
        self.shopName = shopName
        self.onArea = onArea
    }
    
    override init() {
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger((stockQty ?? 0), forKey: "stockQty")
        aCoder.encodeBool(onArea!, forKey: "onArea")
        aCoder.encodeObject(shopName, forKey: "shopName")
    }
    required init?(coder aDecoder: NSCoder) {
        
        stockQty = aDecoder.decodeIntegerForKey("stockQty")
        shopName = aDecoder.decodeObjectForKey("onArea") as? String
        onArea = aDecoder.decodeBoolForKey("shopName")
    }
}