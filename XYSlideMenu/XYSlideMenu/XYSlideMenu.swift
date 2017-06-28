//
//  XYSlideMenu.swift
//  XYSlideMenu
//
//  Created by Xue Yang on 2017/6/28.
//  Copyright © 2017年 Xue Yang. All rights reserved.
//

import UIKit

class XYSlideMenu: UIView {
    
    private var titles: [String]
    
    private var controllers: [UIViewController]
    
    private var tabScrollView: UIScrollView = UIScrollView()
    
    private var itemSelectedIndex: Int = 0
    
    //tab的边距
    private var itemMargin: CGFloat = 15.0
    
    private var items: [UILabel] = []
    
    private let indicatorView: UIView = UIView()
    
    private lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        line.frame = CGRect(x: 0, y: self.bounds.height - 0.5, width: self.bounds.width, height: 0.5)
        return line
    }()
    
    //标题字体
    var itemFont: UIFont = UIFont.systemFont(ofSize: 13) {
        didSet {
        
        }
    }
    
    //选中颜色
    var itemSelectedColor: UIColor = .red {
        didSet {
        
        }
    }
    
    //选中颜色
    var itemUnselectedColor: UIColor = .black {
        didSet {
            
        }
    }
    
    //下标距离底部距离
    var bottomPadding: CGFloat = 2.0 {
        didSet {
        
        }
    }
    
    //下标高度
    var indicatorHeight: CGFloat = 2.0 {
        didSet{
        
        }
    }
    
    //MARK: -
    init(frame: CGRect,titles: [String],childControllers: [UIViewController]) {
        self.titles = titles
        controllers = childControllers
        super.init(frame: frame)
        
        setupTabScrollView()
        setupIndicatorView()
        
        addSubview(line)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    //MARK: --- 配置导航栏
    private func setupTabScrollView() {
        tabScrollView.frame = self.bounds
        tabScrollView.showsVerticalScrollIndicator = false
        tabScrollView.showsHorizontalScrollIndicator = false
        tabScrollView.backgroundColor = .clear
        addSubview(tabScrollView)
        
        var originX = itemMargin
        for (index,title) in titles.enumerated() {
            
            let item = UILabel()
            item.isUserInteractionEnabled = true
            //计算title长度
            let size = (title as NSString).size(attributes: [NSFontAttributeName : itemFont])
            item.frame = CGRect(x: originX, y: 0, width: size.width, height: self.bounds.height)
            //设置属性
            item.text = title
            item.font = itemFont
            item.textColor = index == itemSelectedIndex ? itemSelectedColor : itemUnselectedColor
            //添加tap手势
            let tap = UITapGestureRecognizer(target: self, action: #selector(itemDidClicked(_:)))
            item.addGestureRecognizer(tap)
            
            items.append(item)
            tabScrollView.addSubview(item)
            
            originX = item.frame.maxX + itemMargin * 2
        }
        
        tabScrollView.contentSize = CGSize(width: originX - itemMargin, height: self.bounds.height)
        tabScrollView.addSubview(indicatorView)
        
        if tabScrollView.contentSize.width < self.bounds.width {
            //如果item的长度小于self的width，就重新计算margin排版
            updateLabelsFrame()
        }
    }
    
    //MARK: --- item点击事件
    @objc private func itemDidClicked(_ gesture: UITapGestureRecognizer) {
        
        let item = gesture.view as! UILabel
        if item == items[itemSelectedIndex] { return }
        let fromIndex = itemSelectedIndex
        itemSelectedIndex = items.index(of: item)!
        changeItemTitle(fromIndex, to: itemSelectedIndex)
        changeIndicatorViewPosition(fromIndex, to: itemSelectedIndex)
        
    }
    //MARK: --- 改变itemTitle
    private func changeItemTitle(_ from: Int, to: Int) {
        items[from].textColor = itemUnselectedColor
        items[to].textColor = itemSelectedColor
    }
    //MARK: --- 改变indicatorView位置
    private func changeIndicatorViewPosition(_ from: Int,to: Int) {
        let frame = items[to].frame
        let indicatorFrame = CGRect(x: frame.origin.x, y: indicatorView.frame.origin.y, width: frame.size.width, height: indicatorHeight)
        
        UIView.animate(withDuration: 0.25) {
            self.indicatorView.frame = indicatorFrame
        }
    }
    //MARK: --- 当item过少时，更新item位置
    private func updateLabelsFrame() {
        let newMargin = itemMargin + (self.bounds.width - tabScrollView.contentSize.width) / CGFloat(items.count * 2)
        var originX = newMargin
        for item in items {
            var frame = item.frame
            frame.origin.x = originX
            item.frame = frame
            originX = frame.maxX + 2 * newMargin
        }
        tabScrollView.contentSize = CGSize(width: originX - newMargin, height: self.bounds.height)
    }
    
    //配置下标
    private func setupIndicatorView() {
        var frame = items[itemSelectedIndex].frame
        frame.origin.y = self.bounds.height - bottomPadding - indicatorHeight
        frame.size.height = indicatorHeight
        
        indicatorView.frame = frame
        indicatorView.backgroundColor = itemSelectedColor
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
