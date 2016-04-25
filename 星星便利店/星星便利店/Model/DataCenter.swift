//
//  DataCenter.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/3/19.
//  Copyright © 2016年 黄人煌. All rights reserved.
//

import Foundation
import SVProgressHUD
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
    
    func updateCanGetCoupons(callback: (() -> Void)?){
        GiftModel.getAllGiftList { (result, list) -> Void in
            if 0 == result {
                self.canGetCoupons = list!
                if callback != nil {
                    callback!()
                }
            }
            else {
                self.canGetCoupons = []
            }
        }
    }
    
    func updateAllCoupons(shopNo: String?,callBack:((couponList: [GiftModel]) -> Void)?){
        GiftModel.getUserGiftsListWithShopNo(shopNo) { (result, list) -> Void in
            if 0 == result {
                
                if shopNo == "" {
                    self.allCoupons = list!
                }
                    
                else {
                    
                    if callBack != nil {
                        callBack!(couponList: list!)
                    }
                }
            }
            else {
                self.allCoupons = []
            }
            self.user.coupon = self.allCoupons.filter({ (GiftModel) -> Bool in
                GiftModel.status == 4
            }).count
        }
    }
    
    func updateIntegral(){
        if UserAccountTool.userIsLogin() {
            HTTPManager.POST(ContentType.IntGet, params: ["custNo":"\(UserAccountTool.getUserCustNo()!)"]).responseJSON({ (json) -> Void in
                print(json)
                if "success" == json["message"] as! String {
                    self.user.integral = json["integral"] as! Int
                }
                }, error: { (error) -> Void in
                    SVProgressTool.showErrorSVProgress("出错了")
                    SVProgressHUD.dismiss()
                    print(error?.localizedDescription)
            })
        }
    }
    
}
