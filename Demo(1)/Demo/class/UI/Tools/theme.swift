//
//  PayViewController.swift
//  webDemo
//
//  Created by mac on 15/12/5.
//  Copyright © 2015年 jason. All rights reserved.
//  全局公用属性

import UIKit

public let NavigationH: CGFloat = 64
public let AppWidth: CGFloat = UIScreen.mainScreen().bounds.size.width
public let AppHeight: CGFloat = UIScreen.mainScreen().bounds.size.height
public let MainBounds: CGRect = UIScreen.mainScreen().bounds
//存储用户个人信息
public let SD_UserDefaults_Account = "SD_UserDefaults_Account"
public let SD_UserDefaults_Password = "SD_UserDefaults_Password"
public let SD_UserDefaults_CustNo = "SD_UserDefaults_CustNo"
public let SD_UserDefaults_ImageUrl = "SD_UserDefaults_ImageUrl"
public let SD_UserDefaults_Integral = "SD_UserDefaults_Integral"
public let SD_UserDefaults_UserName = "SD_UserDefaults_UserName"
//存储用户地址信息
public let SD_UserDefaults_Name = "SD_UserDefaults_Name"
public let SD_UserDefaults_Telephone = "SD_UserDefaults_Telephone"
public let SD_UserDefaults_Address = "SD_UserDefaults_Address"
public let SD_OrderInfo_Note = "SD_OrderInfo_Note"

public let ShopCarRedDotAnimationDuration: NSTimeInterval = 0.2

// StoryBoard
public let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
public let myStoryBoard = UIStoryboard(name: "MyStoryBoard", bundle: nil)


public let GuideViewControllerDidFinish = "GuideViewControllerDidFinish"
// MARK: - Mine属性
public let CouponViewControllerMargin: CGFloat = 10
// MARK: - 广告页通知
public let ADImageLoadSecussed = "ADImageLoadSecussed"
public let ADImageLoadFail = "ADImageLoadFail"
///优惠劵使用规则
public let CouponUserRuleURLString = "http://m.beequick.cn/show/webview/p/coupon?zchtauth=e33f2ac7BD%252BaUBDzk6f5D9NDsFsoCcna6k%252BQCEmbmFkTbwnA&__v=ios4.7&__d=d14ryS0MFUAhfrQ6rPJ9Gziisg%2F9Cf8CxgkzZw5AkPMbPcbv%2BpM4HpLLlnwAZPd5UyoFAl1XqBjngiP6VNOEbRj226vMzr3D3x9iqPGujDGB5YW%2BZ1jOqs3ZqRF8x1keKl4%3D"
public let LFBNavigationYellowColor = UIColor.colorWithCustom(253, g: 212, b: 49)
struct theme {
    ///  APP导航条barButtonItem文字大小
    static let SDNavItemFont: UIFont = UIFont.systemFontOfSize(16)
    ///  APP导航条titleFont文字大小
    static let SDNavTitleFont: UIFont = UIFont.systemFontOfSize(18)
    /// ViewController的背景颜色
    static let SDBackgroundColor: UIColor = UIColor.colorWith(239, green: 239, blue: 239, alpha: 1)
    /// webView的背景颜色
    static let SDWebViewBacagroundColor: UIColor = UIColor.colorWith(245, green: 245, blue: 245, alpha: 1)
    static let NavigationColor: UIColor = UIColor.colorWith(242, green: 48, blue: 58, alpha: 1)
    /// 友盟分享的APP key
    static let UMSharedAPPKey: String = "55e2f45b67e58ed4460012db"
    /// 自定义分享view的高度
    static let ShareViewHeight: CGFloat = 215
    static let GitHubURL: String = "https://github.com/ZhongTaoTian"
    static let JianShuURL: String = "http://www.jianshu.com/users/5fe7513c7a57/latest_articles"
    /// cache文件路径
    static let cachesPath: String = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last!
    /// UIApplication.sharedApplication()
    static let appShare = UIApplication.sharedApplication()
    static let sinaURL = "http://weibo.com/u/5622363113/home?topnav=1&wvr=6"
    /// 是否刷新标记
    static var refreshFlag = true
    //判断是否是第一次请求购物车数据
    static var isFirstLoad = true
    // 用户名
    static var userName: String?
}
