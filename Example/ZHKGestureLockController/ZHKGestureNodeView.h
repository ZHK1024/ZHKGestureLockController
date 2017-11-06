//
//  ZHKGestureNodeView.h
//  Example
//
//  Created by ZHK on 2017/3/13.
//  Copyright © 2017年 Weiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COLOR(R, G, B, A) [UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:A]

@interface ZHKGestureNodeView : UIView

@property (nonatomic, assign) CGPoint location; // node 在阵列中的坐标
@property (nonatomic, assign) BOOL    selected; // 是否被选中

/**
 判断当前触点是否进入范围内

 @param location 手指触摸点的坐标
 @return 判断结果
 */
- (BOOL)isInNodeWithLocation:(CGPoint)location;

/**
 设置为普通样式
 */
- (void)setNormalStyle;

/**
 设置为验证成功样式
 */
- (void)setSuccessStyle;

/**
 设置为验证失败样式
 */
- (void)setFailedStyle;

@end
