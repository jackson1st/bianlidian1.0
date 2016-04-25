//
//  SettingCell.swift
//  Created by 黄人煌 on 15/12/28.
//  Copyright © 2015年 Fjnu. All rights reserved.


import UIKit

enum SettingCellType: Int {
    case Recommend = 0
    case About = 1
    case Clean = 2
}

class SettingCell: UITableViewCell {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomView.alpha = 0.3
        sizeLabel.hidden = true
        selectionStyle = .None
    }

    class func settingCellWithTableView(tableView: UITableView) -> SettingCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("settingCell") as! SettingCell
        return cell
    }

}
