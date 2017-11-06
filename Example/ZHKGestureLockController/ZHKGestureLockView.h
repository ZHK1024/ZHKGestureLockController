//
//  ZHKGestureLockView.h
//  Example
//
//  Created by ZHK on 2017/3/13.
//  Copyright © 2017年 Weiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kZHKGestureLockStateNormal,
    kZHKGestureLockStateSuccess,
    kZHKGestureLockStateFailed,
} ZHKGestureLockState;

@class ZHKGestureLockView;
@protocol ZHKGestureLockDelegate <NSObject>

- (BOOL)gestureLockView:(ZHKGestureLockView *)lockView checkResultWithPassword:(NSArray *)password;

@end

@interface ZHKGestureLockView : UIView

@property (nonatomic, assign) ZHKGestureLockState state;
@property (nonatomic, weak) id <ZHKGestureLockDelegate> delegate;


/**
 重置验证
 */
- (void)resetCheck;

@end
