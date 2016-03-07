//
//  MeViewController.swift
//
//  Created by 黄人煌 on 15/12/28.
//  Copyright © 2015年 Fjnu. All rights reserved.
//  这种cell最好用stroyboard的静态单元格来描述

import UIKit
import Alamofire
public let SD_UserIconData_Path = theme.cachesPath + "/iconImage.data"

class MeViewController: UIViewController,UINavigationControllerDelegate {
    
    private var loginLabel: UILabel!
    private var tableView: HRHTableView!
    private var iconImageView: UIImageView!
    private var headView: MineHeadView!
    private var headViewHeight: CGFloat = 120
    private var tableHeadView: MineTabeHeadView!
    // MARK: Flag
    var iderVCSendIderSuccess = false
    private lazy var pickVC: UIImagePickerController = {
        let pickVC = UIImagePickerController()
        pickVC.delegate = self
        pickVC.allowsEditing = true
        return pickVC
        }()
    
    // MARK: Lazy Property
    private lazy var mines: [MineCellModel] = {
        let mines = MineCellModel.loadMineCellModels()
        return mines
    }()
    
    private lazy var mineIcons: NSMutableArray = NSMutableArray(array: ["usercenter", "orders", "setting_like", "feedback", "recomment"])
    
    private lazy var iconActionSheet: UIActionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照", "从手机相册选择")
    
    private lazy var mineTitles: NSMutableArray = NSMutableArray(array: ["个人中心", "我的订单", "我的收藏", "留言反馈", "应用推荐"])
    private var iconView: IconView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBarHidden = true
        buildUI()
        // 设置tableView
//        setTableView()
    }
    
    
//    private func setTableView() {
//        self.automaticallyAdjustsScrollViewInsets = false
//        
//        tableView = UITableView(frame: CGRectMake(0, 0, AppWidth, AppHeight), style: .Grouped)
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.rowHeight = 46
//        view.addSubview(tableView)
//        
//        
//        // 设置tableView的headerView
//        let iconImageViewHeight: CGFloat = 280
//        iconImageView = UIImageView(frame: CGRectMake(0, 0, AppWidth, iconImageViewHeight))
//        iconImageView.image = UIImage(named: "mybk1")
//        iconImageView.userInteractionEnabled = true
//
//    
//        
//        // 添加未登录的文字
//        let loginLabelHeight: CGFloat = 40
//        loginLabel = UILabel(frame: CGRectMake(0, iconImageViewHeight - loginLabelHeight, AppWidth, loginLabelHeight))
//        loginLabel.textAlignment = .Center
//        loginLabel.text = "立即登录"
//        loginLabel.font = UIFont.systemFontOfSize(16)
//        loginLabel.textColor = UIColor.whiteColor()
//        iconImageView.addSubview(loginLabel)
//
//        
//        
//        // 添加iconImageView
//        iconView = IconView(frame: CGRectMake(0, 0, 100, 100))
//        iconView!.delegate = self
//        iconView!.center = CGPointMake(iconImageView.width * 0.5, (iconImageViewHeight - loginLabelHeight) * 0.5 + 8)
//        iconImageView.addSubview(iconView!)
//        
//        
//        iconView?.snp_makeConstraints(closure: { (make) -> Void in
//            make.center.equalTo(iconImageView)
//            make.size.equalTo(100)
//        })
//        loginLabel.snp_makeConstraints { (make) -> Void in
//            make.top.equalTo((iconView?.snp_bottom)!).offset(10)
//            make.width.equalTo(AppWidth)
//            make.height.equalTo(loginLabelHeight)
//        }
//        //添加tableHeaderView
//        let headerView_v: ParallaxHeaderView = ParallaxHeaderView.parallaxHeaderViewWithSubView(iconImageView) as! ParallaxHeaderView
//        
//         tableView.tableHeaderView = headerView_v
//    }
//    
//    func settingClick() {
//        let settingVC = SettingViewController()
//        navigationController?.pushViewController(settingVC, animated: true)
//    }
//    
//    //MARK: 滑动操作
//     func  scrollViewDidScroll(scrollView: UIScrollView) {
//        if (scrollView == self.tableView){
//            let header: ParallaxHeaderView = self.tableView.tableHeaderView as! ParallaxHeaderView
//            header.layoutHeaderViewForScrollViewOffset(scrollView.contentOffset)
//            self.tableView.tableHeaderView = header
//        }
//    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        buildUI()
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
//        loginLabel.hidden = UserAccountTool.userIsLogin()
//        if UserAccountTool.userIsLogin() {
//            if let data = NSData(contentsOfFile: SD_UserIconData_Path) {
//                iconView!.iconButton.setImage(UIImage(data: data)!.imageClipOvalImage(), forState: .Normal)
//            } else {
//                iconView!.iconButton.setImage(UIImage(named: "my"), forState: .Normal)
//            }
//        } else {
//            iconView!.iconButton.setImage(UIImage(named: "my"), forState: .Normal)
//        }
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if iderVCSendIderSuccess {
            SVProgressHUD.showSuccessWithStatus("已经收到你的意见了,我们会刚正面的,放心吧~~")
            iderVCSendIderSuccess = false
        }
    }
    
    // MARK:- Private Method
    // MARK: Build UI
    private func buildUI() {
        
        navigationItem.title = "我的"
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor.clearColor())
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor.colorWith(245, green: 77, blue: 86, alpha: 1))
        let settingButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "v2_my_settings_icon")!, style: UIBarButtonItemStyle.Plain, target: self, action: "setUpButtonClick")
        let flexSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: self, action: nil)
        flexSpacer.width = -2
        self.navigationItem.setRightBarButtonItems(NSArray(objects: flexSpacer,settingButton) as? [UIBarButtonItem], animated: false)
        
        buildTableView()
    }
    
    private func buildTableView() {
        tableView = HRHTableView(frame: CGRectMake(0, NavigationH, AppWidth, AppHeight), style: .Grouped)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 46
        view.addSubview(tableView)
        
        weak var tmpSelf = self
        tableHeadView = MineTabeHeadView(frame: CGRectMake(0, 0, AppWidth, 70 + headViewHeight))
        // 点击headView回调
        tableHeadView.mineHeadViewClick = { (type) -> () in
            
            if UserAccountTool.userIsLogin() {
            
                switch type {
                case .Collect:
                    let collectVc = MyLikeViewController()
                    tmpSelf!.navigationController?.pushViewController(collectVc, animated: true)
                    break
                case .Coupon:
                    let couponVC = GiftViewController()
                    tmpSelf!.navigationController!.pushViewController(couponVC, animated: true)
                    break
                case .Integral:
    //                let message = MessageViewController()
    //                tmpSelf!.navigationController?.pushViewController(message, animated: true)
                    break
                case .MyCenter:
                    let myCenterVC = myStoryBoard.instantiateViewControllerWithIdentifier("MyCenterController")
                    tmpSelf!.navigationController!.pushViewController(myCenterVC, animated: true)

                    break
                }
            }
            else {
                let login = LoginViewController()
                tmpSelf!.navigationController?.pushViewController(login, animated: true)
            }
        }
        tableView.tableHeaderView = tableHeadView
    }
}

/// MARK: iconViewDelegate
//extension MeViewController: IconViewDelegate {
//    func iconView(iconView: IconView, didClick iconButton: UIButton) {
//        // TODO 判断用户是否登录了
//        if UserAccountTool.userIsLogin() {
//            iconActionSheet.showInView(view)
//        } else {
//            let vc = LoginViewController()
//            navigationController?.pushViewController(vc, animated: true)
//        }
//    }
//}

/// MARK: UIActionSheetDelegate
extension MeViewController: UIActionSheetDelegate {
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        print(buttonIndex, terminator: "")
        switch buttonIndex {
        case 1:
            openCamera()
        case 2:
            openUserPhotoLibrary()
        default:
            print("", terminator: "")
        }
    }
    
}
/// MARK: 摄像机和相册的操作和代理方法
extension MeViewController: UIImagePickerControllerDelegate {
    
    /// 打开照相功能
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            pickVC.sourceType = .Camera
            self.presentViewController(pickVC, animated: true, completion: nil)
        } else {
            SVProgressHUD.showErrorWithStatus("模拟器没有摄像头,请链接真机调试", maskType: SVProgressHUDMaskType.Black)
        }
    }
    
    /// 打开相册
    private func openUserPhotoLibrary() {
        pickVC.sourceType = .PhotoLibrary
        pickVC.allowsEditing = true
        presentViewController(pickVC, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // 对用户选着的图片进行质量压缩,上传服务器,本地持久化存储
        if let typeStr = info[UIImagePickerControllerMediaType] as? String {
            if typeStr == "public.image" {
                if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                    var data: NSData?
//                    let smallImage = UIImage.imageClipToNewImage(image, newSize: iconView!.iconButton.size)
//                    if UIImagePNGRepresentation(smallImage) == nil {
//                        data = UIImageJPEGRepresentation(smallImage, 0.8)
//                    } else {
//                        data = UIImagePNGRepresentation(smallImage)
//                    }
                    
                    if data != nil {
                        do {
                            // TODO: 将头像的data传入服务器
                            // 本地也保留一份data数据
                            try NSFileManager.defaultManager().createDirectoryAtPath(theme.cachesPath, withIntermediateDirectories: true, attributes: nil)
                            } catch _ {
                        }
                        NSFileManager.defaultManager().createFileAtPath(SD_UserIconData_Path, contents: data, attributes: nil)
                        
                        HTTPManager.UPload(ContentType.UserHeadPicSubmit, params: ["custno" : UserAccountTool.getUserCustNo()!], multipartFormData: { (MultipartFormData) -> Void in
                            MultipartFormData.appendBodyPart(data: data!, name: "head", fileName: "head.jpg", mimeType: "image/jpg")
                            }, encodingMemoryThreshold: { (MultipartFormDataEncodingResult) -> Void in
                                switch (MultipartFormDataEncodingResult){
                                case .Success(let upload, _, _):upload.responseJSON(completionHandler: { (response) -> Void in
                                    if response.result.isSuccess {
                                        SVProgressHUD.showSuccessWithStatus("图片上传成功", maskType: SVProgressHUDMaskType.Black)
                                    }
                                    else {
                                        SVProgressHUD.showErrorWithStatus("图片上传失败", maskType: SVProgressHUDMaskType.Black)
                                    }
                                })
                                case .Failure(let x):
                                    SVProgressHUD.showErrorWithStatus("图片上传失败", maskType: SVProgressHUDMaskType.Black)
                                }
                        })
            }
        else {
            SVProgressHUD.showErrorWithStatus("图片无法获取", maskType: SVProgressHUDMaskType.Black)
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
            }
            }
        }
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        pickVC.dismissViewControllerAnimated(true, completion: nil)
    }

    
}



// MARK:UITableViewDelegate, UITableViewDataSource 代理方法
extension MeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if 0 == section {
            return 2
        } else if (1 == section) {
            return 1
        } else {
            return 2
        }
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = MineCell.cellFor(tableView)
        
        if 0 == indexPath.section {
            cell.mineModel = mines[indexPath.row]
        } else if 1 == indexPath.section {
            cell.mineModel = mines[2]
        } else {
            if indexPath.row == 0 {
                cell.mineModel = mines[3]
            } else {
                cell.mineModel = mines[4]
            }
        }
        
        return cell
//        if indexPath.section == 0 {
//            cell!.imageView!.image = UIImage(named: mineIcons[indexPath.row] as! String)
//            cell!.textLabel?.text = mineTitles[indexPath.row] as? String
//        } else {
//            cell!.imageView!.image = UIImage(named: "yaoyiyao")
//            cell!.textLabel!.text = "摇一摇 每天都有小惊喜"
//        }
//        
//        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
                if indexPath.row == 0 {  // 个人中心
                if UserAccountTool.userIsLogin() {
                    
                    let myCenterVC = myStoryBoard.instantiateViewControllerWithIdentifier("MyCenterController")
 
                    navigationController!.pushViewController(myCenterVC, animated: true)
                } else {
                    let vc = LoginViewController()
                    navigationController?.pushViewController(vc, animated: true)
                }
                
            }
            if indexPath.row == 1 {   // 我的订单
                if UserAccountTool.userIsLogin() {
                    
                    let orderVC = myStoryBoard.instantiateViewControllerWithIdentifier("OrderView")
                    navigationController!.pushViewController(orderVC, animated: true)
                    
                } else {
                    
                    let vc = LoginViewController()
                    navigationController?.pushViewController(vc, animated: true)                }
            }
        }
        if indexPath.section == 1{
            
        }
        if indexPath.section == 2{
            // 留言反馈
            if indexPath.row == 1 {
                let feedbackVC = IdeaViewController()
                feedbackVC.mineVC = self
                navigationController?.pushViewController(feedbackVC, animated: true)
            }
        }
        
    }
    
}


