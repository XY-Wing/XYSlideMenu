//
//  XYSlideMenuView.h
//  XYSlideMenu
//
//  Created by Xue Yang on 2017/6/29.
//  Copyright © 2017年 Xue Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,XYSlideMenuIndicatorType) {
    XYSlideMenuIndicatorTypeNormal = 0,
    XYSlideMenuIndicatorTypeStrech,
    XYSlideMenuIndicatorTypeStrechAndMove
};

@interface XYSlideMenuView : UIView
@property(nonatomic,assign)XYSlideMenuIndicatorType indicatorType;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles childControllers:(NSArray <UIViewController *>*)controllers;

@end
