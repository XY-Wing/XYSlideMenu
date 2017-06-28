//
//  ViewController.swift
//  XYSlideMenu
//
//  Created by Xue Yang on 2017/6/28.
//  Copyright © 2017年 Xue Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var exampleIndex: Int = 4
    var slideMenu: XYSlideMenu?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor(red: CGFloat(arc4random()%256) / 255, green: CGFloat(arc4random()%256) / 255, blue: CGFloat(arc4random()%256) / 255, alpha: 1)
        
        switch exampleIndex {
        case 0:
            example1()
        case 1:
            example1()
        case 2:
            example1()
        case 3:
            example1()
        case 4:
            example4()
        default:
            break
        }
        
    }
    
    private func example1() {
    
    }
    
    private func example2() {
        
    }
    
    private func example3() {
        
    }
    
    private func example4() {
        let titles = ["今天","头条","推荐","新闻","直播","看世界","微博10周年纪念"]
        var controllers: [UIViewController] = []
        
        for _ in 0..<titles.count {
            let vc = ViewController()
            addChildViewController(vc)
            controllers.append(vc)
        }
        
        let slideMenu = XYSlideMenu(frame: CGRect(x: 0, y: 64, width:view.frame.width, height: 40), titles: titles, childControllers: controllers)
        slideMenu.backgroundColor = .white
        view.addSubview(slideMenu)
    }

}

