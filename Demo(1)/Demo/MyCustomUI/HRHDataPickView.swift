//
//  HRHDataPickView.swift
//  Demo
//
//  Created by 黄人煌 on 16/3/13.
//  Copyright © 2016年 Fjnu. All rights reserved.
//

import UIKit

protocol HRHDataPickViewDelegate: NSObjectProtocol{
    func selectButtonClick(selectString: String)
}


class HRHDataPickView: UIViewController {
    
    private let widthDistance:CGFloat = 100
    private let heigh: CGFloat = 200
    private let lineColor: UIColor = UIColor.colorWithCustom(235, g: 235, b: 235)
    var dataArray: [String] = []
    private var selectRow: Int = 0
    var delegate: HRHDataPickViewDelegate!
    
    
    private let label: UILabel = UILabel()
    private let dataView: UIView = UIView()
    private let pickView: UIPickerView = UIPickerView()
    private let cancelButton: UIButton = UIButton()
    private let selectButton: UIButton = UIButton()
    private let line1: UIView = UIView()
    private let line2: UIView = UIView()
    private let line3: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "确定送达时间"
        label.textColor = UIColor.lightGrayColor()
        label.textAlignment = .Center
        dataView.addSubview(label)
        
        
        
        pickView.dataSource = self
        pickView.delegate = self
        dataView.addSubview(pickView)
        
        cancelButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        cancelButton.setTitle("取消", forState: UIControlState.Normal)
        cancelButton.addTarget(self, action: "closeAction", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        dataView.addSubview(cancelButton)
        
        selectButton.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        selectButton.setTitle("确定", forState: UIControlState.Normal)
        selectButton.addTarget(self, action: "selectAction", forControlEvents: UIControlEvents.TouchUpInside)
        
        dataView.addSubview(selectButton)
        
        line1.backgroundColor = lineColor
        line2.backgroundColor = lineColor
        line3.backgroundColor = lineColor
        dataView.addSubview(line1)
        dataView.addSubview(line2)
        dataView.addSubview(line3)
        
        dataView.layer.masksToBounds = true
        dataView.layer.cornerRadius = 5
        dataView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(dataView)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        dataView.frame = CGRectMake(widthDistance * 0.5, (AppHeight - heigh) * 0.5, AppWidth - widthDistance, heigh)
        label.frame = CGRectMake(0,0,dataView.frame.width,40)
        line1.frame = CGRectMake(0, label.frame.maxY, label.frame.width, 1)
        
        pickView.frame = CGRectMake(0, label.frame.maxY, label.frame.width, dataView.height - label.height - 40)
        print(pickView.frame)
        
        cancelButton.frame = CGRectMake(0, dataView.frame.height - 40, dataView.width / 2, 40)
        selectButton.frame = CGRectMake(dataView.width / 2, dataView.frame.height - 40, dataView.width / 2, 40)
        line2.frame = CGRectMake(0, cancelButton.frame.minY, label.frame.width, 1)
        line3.frame = CGRectMake(cancelButton.frame.maxX, cancelButton.frame.minY, 1, cancelButton.frame.height)
    }
    
}

extension HRHDataPickView {
    func closeAction() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    func selectAction() {
        delegate.selectButtonClick(dataArray[selectRow])
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}


extension HRHDataPickView: UIPickerViewDelegate,UIPickerViewDataSource {
    internal func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    internal func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return dataArray.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataArray[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectRow = row
    }
}