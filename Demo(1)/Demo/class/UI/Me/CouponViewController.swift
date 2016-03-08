//
//  CouponViewController.swift
//  Demo
//
//  Created by 黄人煌 on 16/3/3.
//  Copyright © 2016年 Fjnu. All rights reserved.
//

import UIKit

class CouponViewController: BaseViewController {
    
    private var couponTableView: HRHTableView?
    
    private var useCoupons: [Coupon] = [Coupon]()
    
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        setNavigationItem()
        
        bulidCouponTableView()
        
        loadCouponData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    // MARK: bulidUI
    private func setNavigationItem() {
        navigationItem.title = "优惠劵"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.barButton("使用规则", titleColor: UIColor.colorWith(100, green: 100, blue: 100, alpha: 1), target: self, action: "rightItemClick")
    }
    
    private func bulidCouponTableView() {
        couponTableView = HRHTableView(frame: CGRectMake(0, 0,  AppWidth, AppHeight), style: UITableViewStyle.Plain)
        couponTableView!.delegate = self
        couponTableView?.dataSource = self
        view.addSubview(couponTableView!)
    }
    // MARK: Method
    private func loadCouponData() {
        weak var tmpSelf = self
        CouponData.loadCouponData { (data, error) -> Void in
            if error != nil {
                return
            }
            
            if data?.data?.count > 0 {
                for obj in data!.data! {
                    switch obj.status {
                    case 0: tmpSelf!.useCoupons.append(obj)
                        break
                    default: tmpSelf!.unUseCoupons.append(obj)
                        break
                    }
                }
            }
            
            tmpSelf!.couponTableView?.reloadData()
        }
    }
    
    // MARK: Action
    func rightItemClick() {
        let couponRuleVC = CoupinRuleViewController()
        couponRuleVC.loadURLStr = CouponUserRuleURLString
        couponRuleVC.navTitle = "使用规则"
        navigationController?.pushViewController(couponRuleVC, animated: true)
    }
}

// - MARK: UITableViewDelegate, UITableViewDataSource
extension CouponViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if useCoupons.count > 0 && unUseCoupons.count > 0 {
            if 0 == section {
                return useCoupons.count
            } else {
                return unUseCoupons.count
            }
        }
        
        if useCoupons.count > 0 {
            return useCoupons.count
        }
        
        if unUseCoupons.count > 0 {
            return unUseCoupons.count
        }
        
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if useCoupons.count > 0 && unUseCoupons.count > 0 {
            return 2
        } else if useCoupons.count > 0 || unUseCoupons.count > 0 {
            return 1
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = CouponCell.cellWithTableView(tableView)
        var coupon: Coupon?
        if useCoupons.count > 0 && unUseCoupons.count > 0 {
            if 0 == indexPath.section {
                coupon = useCoupons[indexPath.row]
            } else {
                coupon = unUseCoupons[indexPath.row]
            }
        } else if useCoupons.count > 0 {
            coupon = useCoupons[indexPath.row]
        } else if unUseCoupons.count > 0 {
            coupon = unUseCoupons[indexPath.row]
        }
        
        cell.coupon = coupon!
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if unUseCoupons.count > 0 && useCoupons.count > 0 {
            if 0 == section {
                return nil
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}