//
//  HomeViewController.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/3/19.
//  Copyright © 2016年 黄人煌. All rights reserved.
//

import UIKit
import SVProgressHUD
class HomeViewController: SelectedAdressViewController {
    private var flag: Int = -1
    private var collectionView: HRHCollectionView!
    private var lastContentOffsetY: CGFloat = 0
    private var isAnimation: Bool = false
    private var headData: adList?
    private var freshHot: listCx?
    private var hotData: listHot?
    private var classData: [bigClass]?
    private var address: String!
    private var itemNo: String!
    @IBOutlet weak var giftButton: JSButton!
    //加载超时操作
    var ti:NSTimer?
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadDataFromNet", name: "reloadMainView", object: nil)
        registerNetObserve(4)
        buildCollectionView()
        initGiftModel()
        if(UserAccountTool.judgeIsAppAddress()){
            loadDataFromNet()
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        weak var tmpSelf = self
        tmpSelf?.giftButton.edge = String((DataCenter.shareDataCenter.canGetCoupons.filter({ (GiftModel) -> Bool in
            GiftModel.status == 0
        }).count))
        buildCollectionView()
        initGiftModel()
    }
    
    
    // MARK:- Creat UI
    func initGiftModel(){
        giftButton.backgroundColor = HRHNavigationBarRedBackgroundColor
        giftButton.button.setTitle("券", forState: .Normal)
        weak var tmpSelf = self
        giftButton.buttonAction = {
            ()->() in
                let giftVC = GiftViewController()
                giftVC.mode = 0
            tmpSelf?.navigationController?.pushViewController(giftVC, animated: true)
        }
        DataCenter.shareDataCenter.updateCanGetCoupons { () -> Void in
             self.giftButton.edge = String((DataCenter.shareDataCenter.canGetCoupons.filter({ (GiftModel) -> Bool in
                GiftModel.status == 0
            }).count))
        }
    }
    private func buildCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: HomeCollectionViewCellMargin, bottom: 0, right: HomeCollectionViewCellMargin)
        layout.headerReferenceSize = CGSizeMake(0, HomeCollectionViewCellMargin)
        
        collectionView = HRHCollectionView(frame: CGRectMake(0, NavigationH, AppWidth, AppHeight - 64), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = HRHGlobalBackgroundColor
        collectionView.registerClass(HomeCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.registerNib(UINib(nibName: "HomeSortCell", bundle: nil), forCellWithReuseIdentifier: "HomeSortCell")
        collectionView.registerClass(HomeTableHeadView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "homeHeaderView")
        collectionView.registerClass(HomeCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView")
        collectionView.registerClass(HomeCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footerView")
        view.addSubview(collectionView)
        
        let refreshHeadView = LFBRefreshHeader(refreshingTarget: self, refreshingAction: "headRefresh")
        refreshHeadView.gifView?.frame = CGRectMake(0, 30, 100, 100)
        collectionView.mj_header = refreshHeadView
    }
    
    // MARK: 刷新
    func headRefresh() {
        headData = nil
        freshHot = nil
        
        weak var tmpSelf = self
        loadDataFromNet()
        tmpSelf?.collectionView.mj_header.endRefreshing()
    }
    //隐藏tabBar的方法：在跳转之前调用self.hidesBottomBarWhenPushed = true
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        let vc = segue.destinationViewController
        if( vc.isKindOfClass(OtherViewController)){
            let vc2 = vc as! OtherViewController
            vc2.address = address
            vc2.itemNo = itemNo
        }else{
            if(vc.isKindOfClass(SearcherViewController)){
                let vc2 = vc as! SearcherViewController
//                vc2.delegate  = self
            }
        }
    }
    
    func restartData() {
        
        loadDataFromNet()
        
    }
}

extension HomeViewController:HomeTableHeadViewDelegate{
    
    func tableHeadView(headView: HomeTableHeadView, focusImageViewClick index: Int) {
        dPrint("focusImageViewClick")

    }
    
    func tableHeadView(headView: HomeTableHeadView, iconClick index: Int) {
        dPrint("iconClick")

    }

    func loadDataFromNet(){
        weak var tmpSelf = self
        SVProgressHUD.showWithStatus("加载中啊..", maskType: SVProgressHUDMaskType.Clear)
        if(UserAccountTool.judgeIsAppAddress()){
            let appAddress = UserAccountTool.getAppAddressInfo()
            address = "\(appAddress![0])-\(appAddress![1])-\(appAddress![2])"
        }
        HTTPManager.POST(ContentType.HomeItem, params: ["address":address]).responseJSON({ (json) -> Void in
            print(json)
            if let infomation = json as? NSDictionary{
                let homeData = HomeItemModel(dict: infomation as! [String:AnyObject])
                tmpSelf?.headData = homeData.adlist
                tmpSelf?.freshHot = homeData.listcx
                tmpSelf?.hotData = homeData.listhot
                tmpSelf?.classData = homeData.bigclass
                print(tmpSelf?.freshHot?.itemlist.count)
                tmpSelf?.collectionView.reloadData()
            }
            SVProgressHUD.dismiss()
            }) { (error) -> Void in
                SVProgressTool.showErrorSVProgress("发生了错误")
                dPrint(error!)
        }
//        let path = NSBundle.mainBundle().pathForResource("supermarket", ofType: nil)
//        let data = NSData(contentsOfFile: path!)
//        if data != nil {
//            let dict: NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)) as! NSDictionary
//            let homeData = HomeItemModel(dict: dict as! [String : AnyObject])
//            tmpSelf?.headData = homeData.adlist
//            tmpSelf?.freshHot = homeData.listcx
//            tmpSelf?.hotData = homeData.listhot
////            tmpSelf?.classData = homeData.bigclass
//            tmpSelf?.collectionView.reloadData()
//        }
//        SVProgressHUD.dismiss()
    }

}
// MARK:- UICollectionViewDelegate UICollectionViewDataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,HomeSortCellkDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if headData?.adlist?.count <= 0 || freshHot?.itemlist.count <= 0 || hotData?.itemlist.count <= 0 {
            return 0
        }
        
        if section == 0 {
            return (freshHot?.itemlist.count)!
        } else if section == 1 {
            return (hotData?.itemlist.count)!
        }
        else if section == 2 {
            return (classData?.count)!
        }
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 || indexPath.section == 1{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! HomeCell
            
            if indexPath.section == 0 {
                cell.goods = freshHot!.itemlist[indexPath.row]
            }
            else if indexPath.section == 1{
                cell.goods = hotData!.itemlist[indexPath.row]
            }
            
            return cell
        }
        else  {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HomeSortCell", forIndexPath: indexPath) as! HomeSortCell
            cell.bigClassData = classData![indexPath.row]
            cell.color = sortColor[indexPath.row]
            cell.delegate = self
            return cell
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if headData?.adlist?.count <= 0 || freshHot?.itemlist.count <= 0 {
            return 0
        }
        
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var itemSize = CGSizeZero
        if indexPath.section == 0 {
            itemSize = CGSizeMake((AppWidth - HomeCollectionViewCellMargin * 2) * 0.5 - 4, (AppWidth - HomeCollectionViewCellMargin * 2) * 0.5 + 80)
        } else if indexPath.section == 1 {
            itemSize = CGSizeMake((AppWidth - HomeCollectionViewCellMargin * 2) * 0.5 - 4, (AppWidth - HomeCollectionViewCellMargin * 2) * 0.5 + 80)
        } else if indexPath.section == 2 {
             itemSize = CGSizeMake(AppWidth, 240)
        }
        
        return itemSize
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSizeMake(AppWidth, AppWidth * 0.4 + HomeCollectionViewCellMargin)
        } else if section == 1 {
            return CGSizeMake(AppWidth, HomeCollectionViewCellMargin * 2)
        } else if section == 2 {
            return CGSizeMake(AppWidth, HomeCollectionViewCellMargin * 2)
        }
        
        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSizeMake(AppWidth, HomeCollectionViewCellMargin)
        } else if section == 1 {
            return CGSizeMake(AppWidth, HomeCollectionViewCellMargin)
        } else if section == 2 {
            return CGSizeMake(AppWidth, HomeCollectionViewCellMargin * 5)
        }
        
        return CGSizeZero
    }
    
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 && (indexPath.row == 0 || indexPath.row == 1) {
            return
        }
        
        if isAnimation {
            startAnimation(cell, offsetY: 80, duration: 1.0)
        }
    }
    
    private func startAnimation(view: UIView, offsetY: CGFloat, duration: NSTimeInterval) {
        
        view.transform = CGAffineTransformMakeTranslation(0, offsetY)
        
        UIView.animateWithDuration(duration, animations: { () -> Void in
            view.transform = CGAffineTransformIdentity
        })
    }
    
    func collectionView(collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, atIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 && headData != nil && freshHot != nil && isAnimation {
            startAnimation(view, offsetY: 60, duration: 0.8)
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 && kind == UICollectionElementKindSectionHeader {
            let headView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "homeHeaderView", forIndexPath: indexPath) as! HomeTableHeadView
            headView.delegate = self
            headView.headData = headData
            return headView
        }
        
        let headView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView", forIndexPath: indexPath) as! HomeCollectionHeaderView
        
        if indexPath.section == 0 && kind == UICollectionElementKindSectionHeader {
            headView.setHeaderTitle("商品促销")
        }
        if indexPath.section == 1 && kind == UICollectionElementKindSectionHeader {
            headView.setHeaderTitle("新鲜热卖")
        }
        let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "footerView", forIndexPath: indexPath) as! HomeCollectionFooterView
        
        if indexPath.section == 2 && kind == UICollectionElementKindSectionFooter {
            footerView.showLabel()
            footerView.tag = 100
        } else {
            footerView.hideLabel()
            footerView.tag = 1
        }
        let tap = UITapGestureRecognizer(target: self, action: "moreGoodsClick:")
        footerView.addGestureRecognizer(tap)
        
        return footerView
    }
    
    // MARK: 查看更多商品被点击
    func moreGoodsClick(tap: UITapGestureRecognizer) {
        if tap.view?.tag == 100 {
//            let tabBarController = UIApplication.sharedApplication().keyWindow?.rootViewController as! MainTabBarController
//            tabBarController.setSelectIndex(from: 0, to: 1)
        }
    }
    
    // MARK: - ScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if animationLayers?.count > 0 {
            let transitionLayer = animationLayers![0]
            transitionLayer.hidden = true
        }
        
        if scrollView.contentOffset.y <= scrollView.contentSize.height {
            isAnimation = lastContentOffsetY < scrollView.contentOffset.y
            lastContentOffsetY = scrollView.contentOffset.y
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            itemNo = freshHot?.itemlist[indexPath.row].itemNo
            self.performSegueWithIdentifier("showHome", sender: nil)
        } else {
            itemNo = hotData?.itemlist[indexPath.row].itemNo
            self.performSegueWithIdentifier("showHome", sender: nil)
        }
    }
    
    func pushView(spView: shopView) {
        itemNo = spView.goods?.itemNo
        self.performSegueWithIdentifier("showHome", sender: nil)
    }
}
