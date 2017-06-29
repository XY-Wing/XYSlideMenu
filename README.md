# XYSlideMenu
- scrollView 联动
- OC 与 Swift 两个版本都有。 混合在一块
#
!(image)[https://github.com/XY-Wing/XYSlideMenu/blob/master/GIF/scroll.gif]
# 使用方式
- Swift
```swift
let slideMenu = XYSlideMenu(frame: CGRect(x: 0, y: 64, width:view.frame.width, height: 40), titles: titles, childControllers: controllers)
slideMenu.indicatorType = .stretch
view.addSubview(slideMenu)
```
- OC
```objc
XYSlideMenu *slideMenu = [[XYSlideMenu alloc] initWithFrame:CGRectMake(0,64, self.view.frame.size.width, 40) titles:titles childControllers: controllers];
slideMenu.indicatorType = XYSlideMenuIndicatorTypeStrech;
[self.view addSubview:slideMenu];
```

