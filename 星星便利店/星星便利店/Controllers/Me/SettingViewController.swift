//
//  SettingViewController.swift
//
//  Created by 黄人煌 on 15/12/28.
//  Copyright © 2015年 Fjnu. All rights reserved.
//
//  设置控制器

import UIKit

class SettingViewController: BaseViewController {
    private lazy var images: NSMutableArray! = {
        var array = NSMutableArray(array: ["recommendfriend", "about", "remove"])
        return array
        }()
    
    private lazy var titles: NSMutableArray! = {
        var array = NSMutableArray(array: ["推荐给朋友", "关于我们", "清理缓存"])
        return array
        }()
    
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        // 设置tableView
        setTableView()
    }
    
    private func setTableView() {
        tableView = UITableView(frame: view.bounds, style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.colorWith(247, green: 247, blue: 247, alpha: 1)
        tableView.rowHeight = 50
        tableView.separatorStyle = .None
        tableView.registerNib(UINib(nibName: "SettingCell", bundle: nil), forCellReuseIdentifier: "settingCell")
        view.addSubview(tableView)
    }
    
    deinit {
        print("设置控制器被销毁了", terminator: "")
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = SettingCell.settingCellWithTableView(tableView)
        cell.imageImageView.image = UIImage(named: images[indexPath.row] as! String)
        cell.titleLabel.text = titles[indexPath.row] as? String
        
        if indexPath.row == SettingCellType.Clean.hashValue {
            cell.bottomView.hidden = true
            cell.sizeLabel.hidden = false
            cell.sizeLabel.text =  String().stringByAppendingFormat("%.2f M", FileTool.folderSize(theme.cachesPath))
            
            
        } else {
            cell.bottomView.hidden = false
            cell.sizeLabel.hidden = true
        }
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == SettingCellType.About.hashValue {
            let aboutVC = AboutWeViewController()
            navigationController!.pushViewController(aboutVC, animated: true)
            
        }  else if indexPath.row == SettingCellType.Clean.hashValue {
            weak var tmpSelf = self
            FileTool.cleanFolder(theme.cachesPath, complete: { () -> () in
                tmpSelf!.tableView.reloadData()
            })
            
        }
    }
}