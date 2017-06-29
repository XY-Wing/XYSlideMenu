//
//  XYTestViewController.swift
//  XYSlideMenu
//
//  Created by Xue Yang on 2017/6/29.
//  Copyright © 2017年 Xue Yang. All rights reserved.
//

import UIKit
private let cellIdentifier = "UITableViewCell"
class XYTestViewController: UIViewController {

    private lazy var tabView: UITableView = { [unowned self] in
        let tabView = UITableView(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height), style: .grouped)
        tabView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tabView.delegate = self
        tabView.dataSource = self
        tabView.contentInset = UIEdgeInsets(top: 104, left: 0, bottom: 0, right: 0)
        return tabView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: CGFloat(arc4random()%256) / 255, green: CGFloat(arc4random()%256) / 255, blue: CGFloat(arc4random()%256) / 255, alpha: 1)
        view.addSubview(tabView)
        
    }

}

extension XYTestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = UIColor.init(red: CGFloat(arc4random()%256) / 255, green: CGFloat(arc4random()%256) / 255, blue: CGFloat(arc4random()%256) / 255, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
}
