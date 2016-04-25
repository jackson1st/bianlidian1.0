//
//  FeedbackViewController.swift
//  Created by 黄人煌 on 15/12/28.
//  Copyright © 2015年 Fjnu. All rights reserved.

//  用户反馈ViewController

import UIKit

import UIKit
import SVProgressHUD
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
        navigationItem.rightBarButtonItem = UIBarButtonItem.barButton("发送", titleColor: UIColor.whiteColor(), target: self, action: "rightItemClick")
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
        iderTextView.layer.masksToBounds = true
        iderTextView.layer.borderWidth = 1
        iderTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        iderTextView.layer.cornerRadius = 3
        view.addSubview(iderTextView)
    }
    
    // MARK: - Action
    func rightItemClick() {
        
        if iderTextView.text == nil || 0 == iderTextView.text?.characters.count {
            SVProgressTool.showErrorSVProgress("请输入意见,心里空空的~")
        } else if iderTextView.text?.characters.count < 5 {
            SVProgressTool.showErrorSVProgress("请输入超过5个字啊,亲!")
        } else if iderTextView.text?.characters.count >= 300 {
            SVProgressTool.showErrorSVProgress("说的太多了,臣妾做不到啊!")
             SVProgressHUD.showInfoWithStatus("说的太多了,臣妾做不到啊~")
        } else {
            SVProgressHUD.showWithStatus("发送中", maskType: SVProgressHUDMaskType.Clear)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
            dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
                self.navigationController?.popViewControllerAnimated(true)
                self.mineVC?.iderVCSendIderSuccess = true
                SVProgressHUD.dismiss()
            })
        }
    }
}


