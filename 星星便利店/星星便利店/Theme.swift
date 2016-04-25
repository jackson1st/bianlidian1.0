//
//  Theme.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/3/19.
//  Copyright © 2016年 黄人煌. All rights reserved.
//

import UIKit

// MARK: - 全局常用属性
public let NavigationH: CGFloat = 64
public let AppWidth: CGFloat = UIScreen.mainScreen().bounds.size.width
public let AppHeight: CGFloat = UIScreen.mainScreen().bounds.size.height
public let AppBounds: CGRect = UIScreen.mainScreen().bounds
public let HRHNavigationBarRedBackgroundColor = UIColor.colorWithCustom(245, g: 77, b: 86)

// StoryBoard
public let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
public let myStoryBoard = UIStoryboard(name: "MyStoryBoard", bundle: nil)

// MARK: - 通知
/// 首页headView高度改变
public let HomeTableHeadViewHeightDidChange = "HomeTableHeadViewHeightDidChange"


// MARK: - 常用颜色
public let HRHGlobalBackgroundColor = UIColor.colorWithCustom(239, g: 239, b: 239)
public let sortColor = [UIColor.colorWithCustom(107, g: 216, b: 174),UIColor.colorWithCustom(27, g: 168, b: 237),UIColor.colorWithCustom(255, g: 144, b: 161),UIColor.colorWithCustom(111, g: 92, b: 77),UIColor.colorWithCustom(157, g: 206, b: 55),UIColor.colorWithCustom(225, g: 235, b: 166),UIColor.colorWithCustom(254, g: 59, b: 119),UIColor.colorWithCustom(244, g: 239, b: 113)]
public let HRHTextGreyColol = UIColor.colorWithCustom(130, g: 130, b: 130)


public let GuideViewControllerDidFinish = "GuideViewControllerDidFinish"
// MARK: - Mine属性
public let CouponViewControllerMargin: CGFloat = 10
// MARK: - 广告页通知
public let ADImageLoadSecussed = "ADImageLoadSecussed"
public let ADImageLoadFail = "ADImageLoadFail"
// MARK: - Home 属性
public let HotViewMargin: CGFloat = 10
public let HomeCollectionViewCellMargin: CGFloat = 10
public let HomeCollectionTextFont = UIFont.systemFontOfSize(13)
public let HomeCollectionCellAnimationDuration: NSTimeInterval = 1.0
///优惠劵使用规则
public let CouponUserRuleURLString = "http://m.beequick.cn/show/webview/p/coupon?zchtauth=e33f2ac7BD%252BaUBDzk6f5D9NDsFsoCcna6k%252BQCEmbmFkTbwnA&__v=ios4.7&__d=d14ryS0MFUAhfrQ6rPJ9Gziisg%2F9Cf8CxgkzZw5AkPMbPcbv%2BpM4HpLLlnwAZPd5UyoFAl1XqBjngiP6VNOEbRj226vMzr3D3x9iqPGujDGB5YW%2BZ1jOqs3ZqRF8x1keKl4%3D"
public let LFBNavigationYellowColor = UIColor.colorWithCustom(253, g: 212, b: 49)
//判断是否是第一次请求购物车数据
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
}
