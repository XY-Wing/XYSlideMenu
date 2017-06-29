//
//  ViewController.swift
//  XYSlideMenu
//
//  Created by Xue Yang on 2017/6/28.
//  Copyright © 2017年 Xue Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var slideMenu: XYSlideMenu?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = "滚动视图"
        
        view.backgroundColor = UIColor(red: CGFloat(arc4random()%256) / 255, green: CGFloat(arc4random()%256) / 255, blue: CGFloat(arc4random()%256) / 255, alpha: 1)
        
        example()
    }
    
    
    private func example() {
        let titles = ["请假","出差","外出","加班","补签","Live","Recommed","Decade Anniversary"]
        var controllers: [UIViewController] = []
        
        for _ in 0..<titles.count {
            let vc = XYTestViewController()
            addChildViewController(vc)
            controllers.append(vc)
        }
        
        /*Swfit版*/
        let slideMenu = XYSlideMenu(frame: CGRect(x: 0, y: 64, width:view.frame.width, height: 40), titles: titles, childControllers: controllers)
        slideMenu.indicatorType = .stretch
        view.addSubview(slideMenu)
        
        /*OC版*/
//        let slideMenu = XYSlideMenuView(frame: CGRect(x: 0, y: 64, width:view.frame.width, height: 40), titles: titles, childControllers: controllers)
//        slideMenu?.indicatorType = .strech
//        view.addSubview(slideMenu!)
    }

}

