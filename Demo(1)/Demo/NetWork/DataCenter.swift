//
//  DataCenter.swift
//  Demo
//
//  Created by 黄人煌 on 16/3/8.
//  Copyright © 2016年 Fjnu. All rights reserved.
//

import Foundation

class DataCenter {
    
    //单例
    class var shareDataCenter:DataCenter{
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance: DataCenter? = nil
        }
        
        dispatch_once(&Static.onceToken) { () -> Void in
            Static.instance = DataCenter()
        }
        return Static.instance!
    }
    
    
    var user = User()
    
    
    //优惠券
    var canGetCoupons: [GiftModel] = [GiftModel]()
    var allCoupons: [GiftModel] = [GiftModel]()
    
    func updateCanGetCoupons(callBack:((couponCount: Int) -> Void)?){
        GiftModel.getAllGiftList { (result, list) -> Void in
            if 0 == result {
                self.canGetCoupons = list!
                if callBack != nil {
                    (couponCount: self.canGetCoupons.filter({ (GiftModel) -> Bool in
                        GiftModel.status == 0
                    }).count)
                }
            }
            else {
                self.canGetCoupons = []
            }
        }
    }
    
    func updateAllCoupons(shopNo: String?,callBack:((couponCount: Int) -> Void)?){
        GiftModel.getUserGiftsListWithShopNo(shopNo) { (result, list) -> Void in
            if 0 == result {
                self.allCoupons = list!
                if callBack != nil {
                    (couponCount: self.allCoupons.filter({ (GiftModel) -> Bool in
                        GiftModel.status == 4
                    }).count)
                }
            }
            else {
                self.allCoupons = []
            }
        }
    }
    
    
    
}
