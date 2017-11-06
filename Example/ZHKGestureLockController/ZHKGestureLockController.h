//
//  ZHKGestureLockController.h
//  Example
//
//  Created by ZHK on 2017/3/13.
//  Copyright © 2017年 Weiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kGestureLockCheck,  // 验证
    kGestureLockSet,    // 设置
    kGestureLockReset,  // 重设
} ZHKGestureLockStyle;

@interface ZHKGestureLockController : UIViewController

@property (nonatomic, assign) ZHKGestureLockStyle style;   // 验证/设置/重设 (手势密码)

@end
