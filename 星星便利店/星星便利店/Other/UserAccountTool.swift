//
//  UserAccountTool.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/3/19.
//  Copyright © 2016年 黄人煌. All rights reserved.
//

import UIKit

class UserAccountTool: NSObject {
    
    let user = NSUserDefaults.standardUserDefaults()
    /// 判断当前用户是否登录
    class func userIsLogin() -> Bool {
        let user = NSUserDefaults.standardUserDefaults()
        let account = user.objectForKey("UserDefaults_Account") as? String
        let password = user.objectForKey("UserDefaults_Password") as? String
        
        if account != nil && password != nil {
            if !account!.isEmpty && !password!.isEmpty {
                return true
            }
        }
        return false
    }
    
    class func setUserInfo(phoneNomber: String,passWord: String, custNo: String,userName: String, imageUrl: String, integral: Int, shopNo: String?) {
        NSUserDefaults.standardUserDefaults().setObject(phoneNomber, forKey: "UserDefaults_Account")
        NSUserDefaults.standardUserDefaults().setObject(passWord, forKey: "UserDefaults_Password")
        NSUserDefaults.standardUserDefaults().setObject(custNo, forKey: "UserDefaults_CustNo")
        NSUserDefaults.standardUserDefaults().setObject(userName, forKey: "UserDefaults_UserName")
        NSUserDefaults.standardUserDefaults().setObject(imageUrl, forKey: "UserDefaults_ImageUrl")
        NSUserDefaults.standardUserDefaults().setObject(integral, forKey: "UserDefaults_Integral")
        if shopNo != nil {
            NSUserDefaults.standardUserDefaults().setObject("1", forKey: "UserDefaults_Role")
            NSUserDefaults.standardUserDefaults().setObject(shopNo!, forKey: "UserDefaults_ShopNo")
        }
        else {
            NSUserDefaults.standardUserDefaults().setObject("0", forKey: "UserDefaults_Role")
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "UserDefaults_ShopNo")
        }
    }
    
    class func setUserName(newUserName: String) -> Void {
        NSUserDefaults.standardUserDefaults().setObject(newUserName, forKey: "UserDefaults_UserName")
    }
    
    /// 如果用户登录了,返回用户的账号(电话号)
    class func getUserAccount() -> String? {
        if !userIsLogin() {
            return nil
        }
        
        let user = NSUserDefaults.standardUserDefaults()
        let account = user.objectForKey("UserDefaults_Account") as? String
        return account!
    }
    class func getUserCustNo() -> String? {
        if !userIsLogin() {
            return nil
        }
        
        let user = NSUserDefaults.standardUserDefaults()
        let account = user.objectForKey("UserDefaults_CustNo") as? String
        return account!
    }
    class func getUserName() -> String? {
        if !userIsLogin() {
            return nil
        }
        
        let user = NSUserDefaults.standardUserDefaults()
        let account = user.objectForKey("UserDefaults_UserName") as? String
        return account!
    }
    class func getUserImageUrl() -> String? {
        if !userIsLogin() {
            return nil
        }
        
        let user = NSUserDefaults.standardUserDefaults()
        let account = user.objectForKey("UserDefaults_ImageUrl") as? String
        return account!
    }
    class func getUserRole() -> String? {
        if !userIsLogin() {
            return nil
        }
        let user = NSUserDefaults.standardUserDefaults()
        let role = user.objectForKey("UserDefaults_Role") as? String
        return role
    }
    class func getUserShopNo() -> String? {
        if !userIsLogin() {
            return nil
        }
        let user = NSUserDefaults.standardUserDefaults()
        let shopNo = user.objectForKey("UserDefaults_ShopNo") as? String
        return shopNo
    }
    
    // 地址相关
    
    
    class func setAppAddressInfo(city: String,area: String,shopName: String,callBack: () -> ()){
        let user = NSUserDefaults.standardUserDefaults()
        user.setObject(city, forKey: "AppDefaults_City")
        user.setObject(area, forKey: "AppDefaults_Area")
        user.setObject(shopName, forKey: "AppDefaults_ShopName")
        if user.synchronize() {
            callBack()
        }
    }
    
    class func judgeIsAppAddress() -> Bool {
        let user = NSUserDefaults.standardUserDefaults()
        let city = user.objectForKey("AppDefaults_City") as? String
        let area = user.objectForKey("AppDefaults_Area") as? String
        let shopName = user.objectForKey("AppDefaults_ShopName") as? String
        if city != nil && area != nil && shopName != nil {
            if !city!.isEmpty && !area!.isEmpty && !shopName!.isEmpty {
                return true
            }
        }
        return false
    }
    
    class func getAppAddressInfo() -> [String]? {
        if !judgeIsAppAddress() {
            return nil
        }
        var information: [String] = []
        let user = NSUserDefaults.standardUserDefaults()
        let city = user.objectForKey("AppDefaults_City") as? String
        let area = user.objectForKey("AppDefaults_Area") as? String
        let shopName = user.objectForKey("AppDefaults_ShopName") as? String
        information.append(city!)
        information.append(area!)
        information.append(shopName!)
        return information
    }
    
    
    
    class func judgeUserIsAddress() -> Bool {
        let user = NSUserDefaults.standardUserDefaults()
        let telephone = user.objectForKey("UserDefaults_Telephone") as? String
        let address = user.objectForKey("UserDefaults_Address") as? String
        let name = user.objectForKey("UserDefaults_Name") as? String
        if telephone != nil && address != nil && name != nil{
            if !telephone!.isEmpty && !address!.isEmpty && !name!.isEmpty{
                return true
            }
        }
        return false
    }
    
    class func getUserAddressInformation() -> [String]? {
        if !judgeUserIsAddress() {
            return nil
        }
        var information: [String] = []
        let user = NSUserDefaults.standardUserDefaults()
        let name = user.objectForKey("UserDefaults_Name") as? String
        information.append(name!)
        let telephone = user.objectForKey("UserDefaults_Telephone") as? String
        information.append(telephone!)
        let address = user.objectForKey("UserDefaults_Address") as? String
        information.append(address!)
        return information
    }
    
}

