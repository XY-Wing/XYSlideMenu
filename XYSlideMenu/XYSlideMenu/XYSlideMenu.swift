//
//  XYSlideMenu.swift
//  XYSlideMenu
//
//  Created by Xue Yang on 2017/6/28.
//  Copyright © 2017年 Xue Yang. All rights reserved.
//

import UIKit

enum XYSlideMenuIndicatorType {
    case normal
    case stretch
    case stretchAndMove
}

class XYSlideMenu: UIView {
    
    //MARK: - properties
    
    private var titles: [String]
    
    private var controllers: [UIViewController]
    
    private var tabScrollView: UIScrollView = UIScrollView()
    
    private var mainScrollView: UIScrollView = UIScrollView()
    
    private var itemSelectedIndex: Int = 0
    
    var indicatorType: XYSlideMenuIndicatorType = .normal
    
    //tab的边距
    private var itemMargin: CGFloat = 15.0
    
    private var items: [UILabel] = []
    
    private let indicatorView: UIView = UIView()
    
    private var leftIndex = 0
    private var rightIndex = 0
    
    //伸缩动画的偏移量
    fileprivate let indicatorAnimatePadding: CGFloat = 8.0
//    private var isSlideRight: Bool = true
    
    //底部横线
    private lazy var line: UIView = { [unowned self] in
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        line.frame = CGRect(x: 0, y: self.bounds.height - 0.5, width: self.bounds.width, height: 0.5)
        return line
    }()
    
    //背景模糊
    private lazy var blurView: UIVisualEffectView = { [unowned self] in
        let blurView = UIVisualEffectView(effect: UIBlurEffect.init(style: .light))
        blurView.frame = self.bounds
        return blurView
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
        
        backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        addSubview(blurView)
        setupTabScrollView()
        setupIndicatorView()
        
        addSubview(line)
        
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupMainScrollView()
    }
    
    //MARK: --- 配置控制器滑动scrollView
    private func setupMainScrollView() {
        if mainScrollView.superview == nil {
            mainScrollView.frame = (self.superview?.bounds)!
            self.superview?.insertSubview(mainScrollView, belowSubview: self)
            mainScrollView.contentSize = CGSize(width: CGFloat(controllers.count) * mainScrollView.bounds.width, height: 0)
            mainScrollView.bounces = false
            mainScrollView.isPagingEnabled = true
            mainScrollView.delegate = self
        }
        
        setupChildControllers()
    
    }
    
    //MARK: --- 配置子控制器
    private func setupChildControllers() {
        for (index,vc) in controllers.enumerated() {
            mainScrollView.addSubview(vc.view)
            vc.view.frame = CGRect(x: CGFloat(index) * mainScrollView.bounds.width, y: 0, width: mainScrollView.bounds.width, height: mainScrollView.bounds.height)
        }
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
        
        
        resetTabScrollViewContentOffset(item)
        
        resetMainScrollViewContentOffset(itemSelectedIndex)
        
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
        
        indicatorView.layer.cornerRadius = frame.height * 0.5
        indicatorView.layer.masksToBounds = true
    }
    
    //点击item 修改tabScrollView的偏移量
    private func resetTabScrollViewContentOffset(_ item: UILabel) {
        var destinationX: CGFloat = 0
        let itemCenterX = item.center.x
        let scrollHalfWidth = tabScrollView.bounds.width / 2
        //item中心点超过最高滚动范围时
        if tabScrollView.contentSize.width - itemCenterX < scrollHalfWidth {
            destinationX = tabScrollView.contentSize.width - scrollHalfWidth * 2
            tabScrollView.setContentOffset(CGPoint(x: destinationX, y: 0), animated: true)
            return
        }
        //item中心点低于最低滚动范围时
        if itemCenterX > scrollHalfWidth{
            destinationX = itemCenterX - scrollHalfWidth
            tabScrollView.setContentOffset(CGPoint(x: destinationX, y: 0), animated: true)
            return
        }
        
        tabScrollView.setContentOffset(CGPoint(x: 0, y:0), animated: true)
        
    }
    
    //点击item 修改mainScrollView的偏移量
    private func resetMainScrollViewContentOffset(_ index: Int) {
        mainScrollView.setContentOffset(CGPoint(x: CGFloat(index) * mainScrollView.bounds.width, y: 0), animated: false)
    }
    
    fileprivate func changeItemStatusBecauseDealNormalIndicatorType() {
        let to = Int(mainScrollView.contentOffset.x / mainScrollView.bounds.width)
        let toItem = items[to]
        let g = toItem.gestureRecognizers
        itemDidClicked(g?.first as! UITapGestureRecognizer)
    }
    
    //MARK: --- 处理normal状态的 indicatorView
    fileprivate func dealNormalIndicatorType(_ offsetX: CGFloat) {
        if offsetX <= 0 {
            //左边界
            leftIndex = 0
            rightIndex = 0
            
        } else if offsetX >= mainScrollView.contentSize.width {
            //右边界
            leftIndex = items.count - 1
            rightIndex = leftIndex
        } else {
            //中间
            leftIndex = Int(offsetX / mainScrollView.bounds.width)
            rightIndex = leftIndex + 1
        }
        
        let ratio = offsetX / mainScrollView.bounds.width - CGFloat(leftIndex)
        if ratio == 0 { return }
        
        let leftItem = items[leftIndex]
        let rightItem = items[rightIndex]
        
        let totalSpace = rightItem.center.x - leftItem.center.x
        indicatorView.center = CGPoint(x:leftItem.center.x + totalSpace * ratio, y: indicatorView.center.y)
    }
    
    //MARK: --- 处理followText状态的 indicatorView
    fileprivate func dealFollowTextIndicatorType(_ offsetX: CGFloat) {
        if offsetX <= 0 {
            //左边界
            leftIndex = 0
            rightIndex = 0
            
        } else if offsetX >= mainScrollView.contentSize.width {
            //右边界
            leftIndex = items.count - 1
            rightIndex = leftIndex
        } else {
            //中间
            leftIndex = Int(offsetX / mainScrollView.bounds.width)
            rightIndex = leftIndex + 1
        }
        
        let ratio = offsetX / mainScrollView.bounds.width - CGFloat(leftIndex)
        if ratio == 0 { return }
        
        let leftItem = items[leftIndex]
        let rightItem = items[rightIndex]
        
        //-
        let distance: CGFloat = indicatorType == .stretch ? 0 : indicatorAnimatePadding
        var frame = self.indicatorView.frame
        let maxWidth = rightItem.frame.maxX - leftItem.frame.minX - distance * 2
        
        if ratio <= 0.5 {
            frame.size.width = leftItem.frame.width + (maxWidth - leftItem.frame.width) * (ratio / 0.5)
            frame.origin.x = leftItem.frame.minX + distance * (ratio / 0.5)
        } else {
            frame.size.width = rightItem.frame.width + (maxWidth - rightItem.frame.width) * ((1 - ratio) / 0.5)
            frame.origin.x = rightItem.frame.maxX - frame.size.width - distance * ((1 - ratio) / 0.5)
        }
        
        self.indicatorView.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UIScrollViewDelegate
extension XYSlideMenu: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        switch indicatorType {
        case .normal:
            dealNormalIndicatorType(offsetX)
        case .stretch:
            dealFollowTextIndicatorType(offsetX)
        case .stretchAndMove:
            dealFollowTextIndicatorType(offsetX)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        changeItemStatusBecauseDealNormalIndicatorType()
    }
    
}
