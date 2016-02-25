//
//  GuideViewController.swift
//  Demo
//
//  Created by 黄人煌 on 16/2/22.
//  Copyright © 2016年 Fjnu. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {
    
    private var collectionView: UICollectionView?
    private var imageNames = ["guide_40_1", "guide_40_2", "guide_40_3", "guide_40_4"]
    private let cellIdentifier = "GuideCell"
    private var isHiddenNextButton = true
    private var pageController = UIPageControl(frame: CGRectMake(0, AppHeight - 50, AppWidth, 20))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        buildCollectionView()
        
        buildPageController()
    }
    
    // MARK: - Build UI
    private func buildCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = MainBounds.size
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView = UICollectionView(frame: MainBounds, collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
        collectionView?.registerClass(GuideCell.self, forCellWithReuseIdentifier: cellIdentifier)
        view.addSubview(collectionView!)
    }
    
    private func buildPageController() {
        pageController.numberOfPages = imageNames.count
        pageController.currentPage = 0
        view.addSubview(pageController)
    }
}

extension GuideViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imageNames.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! GuideCell
        cell.newImage = UIImage(named: imageNames[indexPath.row])
        if indexPath.row != imageNames.count - 1 {
            cell.setNextButtonHidden(true)
        }
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView.contentOffset.x == AppWidth * CGFloat(imageNames.count - 1) {
            let cell = collectionView!.cellForItemAtIndexPath(NSIndexPath(forRow: imageNames.count - 1, inSection: 0)) as! GuideCell
            cell.setNextButtonHidden(false)
            isHiddenNextButton = false
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x != AppWidth * CGFloat(imageNames.count - 1) && !isHiddenNextButton && scrollView.contentOffset.x > AppWidth * CGFloat(imageNames.count - 2) {
            let cell = collectionView!.cellForItemAtIndexPath(NSIndexPath(forRow: imageNames.count - 1, inSection: 0)) as! GuideCell
            cell.setNextButtonHidden(true)
            isHiddenNextButton = true
        }
        
        pageController.currentPage = Int(scrollView.contentOffset.x / AppWidth + 0.5)
    }
}

