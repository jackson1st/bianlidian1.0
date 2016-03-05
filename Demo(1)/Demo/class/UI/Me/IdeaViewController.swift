//
//  FeedbackViewController.swift
//  Created by 黄人煌 on 15/12/28.
//  Copyright © 2015年 Fjnu. All rights reserved.

//  用户反馈ViewController

import UIKit

import UIKit

class IdeaViewController: BaseViewController {
    
    private let margin: CGFloat = 15
    private var promptLabel: UILabel!
    private var iderTextView: PlaceholderTextView!
    weak var mineVC: MeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
        buildRightItemButton()
        
        buildPlaceholderLabel()
        
        buildIderTextView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        iderTextView.becomeFirstResponder()
    }
    
    // MARK: - Build UI
    private func setUpUI() {
        view.backgroundColor = theme.SDBackgroundColor
        navigationItem.title = "意见反馈"
    }
    
    private func buildRightItemButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.barButton("发送", titleColor: UIColor.colorWith(100, green: 100, blue: 100, alpha: 1), target: self, action: "rightItemClick")
    }
    
    private func buildPlaceholderLabel() {
        promptLabel = UILabel(frame: CGRectMake(margin, 70, AppWidth - 2 * margin, 50))
        promptLabel.text = "你的批评和建议能帮助我们更好的完善产品,请留下你的宝贵意见!"
        promptLabel.numberOfLines = 2;
        promptLabel.textColor = UIColor.blackColor()
        promptLabel.font = UIFont.systemFontOfSize(15)
        view.addSubview(promptLabel)
    }
    
    private func buildIderTextView() {
        iderTextView = PlaceholderTextView(frame: CGRectMake(margin, CGRectGetMaxY(promptLabel.frame) + 10, AppWidth - 2 * margin, 150))
        iderTextView.placeholder = "请输入宝贵意见(300字以内)"
        view.addSubview(iderTextView)
    }
    
    // MARK: - Action
    func rightItemClick() {
        
        if iderTextView.text == nil || 0 == iderTextView.text?.characters.count {
            SVProgressHUD.showInfoWithStatus("请输入意见,心里空空的")
//            ProgressHUDManager.showImage(UIImage(named: "v2_orderSuccess")!, status: "请输入意见,心里空空的")
        } else if iderTextView.text?.characters.count < 5 {
            SVProgressHUD.showInfoWithStatus("请输入超过5个字啊亲~")
//            ProgressHUDManager.showImage(UIImage(named: "v2_orderSuccess")!, status: "请输入超过5个字啊亲~")
        } else if iderTextView.text?.characters.count >= 300 {
             SVProgressHUD.showInfoWithStatus("说的太多了,臣妾做不到啊~")
//            ProgressHUDManager.showImage(UIImage(named: "v2_orderSuccess")!, status: "说的太多了,臣妾做不到啊~")
        } else {
            MBProgressHUD.showMessage("发送中")
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
            dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
                self.navigationController?.popViewControllerAnimated(true)
                self.mineVC?.iderVCSendIderSuccess = true
                MBProgressHUD.hideHUD()
            })
        }
    }
}


