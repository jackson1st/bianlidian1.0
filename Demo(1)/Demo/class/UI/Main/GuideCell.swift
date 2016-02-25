//
//  GuideCell.swift
//  Demo
//
//  Created by 黄人煌 on 16/2/22.
//  Copyright © 2016年 Fjnu. All rights reserved.
//

import UIKit

class GuideCell: UICollectionViewCell {
    
    private let newImageView = UIImageView(frame: MainBounds)
    private let nextButton = UIButton(frame: CGRectMake((AppWidth - 100) * 0.5, AppHeight - 110, 100, 33))
    
    var newImage: UIImage? {
        didSet {
            newImageView.image = newImage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        newImageView.contentMode = UIViewContentMode.ScaleAspectFill
        contentView.addSubview(newImageView)
        
        nextButton.setBackgroundImage(UIImage(named: "icon_next"), forState: UIControlState.Normal)
        nextButton.addTarget(self, action: "nextButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        nextButton.hidden = true
        contentView.addSubview(nextButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNextButtonHidden(hidden: Bool) {
        nextButton.hidden = hidden
    }
    
    func nextButtonClick() {
        NSNotificationCenter.defaultCenter().postNotificationName(GuideViewControllerDidFinish, object: nil)
    }
}
