//
//  ZHKGestureLockController.m
//  Example
//
//  Created by ZHK on 2017/3/13.
//  Copyright © 2017年 Weiyu. All rights reserved.
//

#import "ZHKGestureLockController.h"
#import "ZHKGestureLockView.h"

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define GESTURE_PASSWORD_KEY @"GESTURE_PASSWORD_KEY"

@interface ZHKGestureLockController () <ZHKGestureLockDelegate>

@property (nonatomic, strong) ZHKGestureLockView *gestureLockView;
@property (nonatomic, strong) NSMutableArray *passwordArray;    // 设置密码
@property (nonatomic, assign) BOOL resetCheckSuccess;   // 重设验证是否通过

@end

@implementation ZHKGestureLockController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:59 / 255.0 green:61 / 255.0 blue:65 / 255.0 alpha:1];

    self.gestureLockView = [[ZHKGestureLockView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.width)];
    _gestureLockView.center = self.view.center;
    _gestureLockView.delegate = self;
    
    [self.view addSubview:_gestureLockView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 

- (BOOL)checkGestureLockWithPassword:(NSArray *)array {
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:GESTURE_PASSWORD_KEY];
    return [pwd isEqualToString:[self passwordStringFromPasswordArray:array]];
}


#pragma mark - ZHKGestureLock delegate

- (BOOL)gestureLockView:(ZHKGestureLockView *)lockView checkResultWithPassword:(NSArray *)password {
    NSLog(@"pwd = %@", password);
    
    // 验证
    if (_style == kGestureLockCheck) {
        if ([self checkPassword:password]) {
            lockView.state = kZHKGestureLockStateSuccess;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
            
        }else {
            lockView.state = kZHKGestureLockStateFailed;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [lockView resetCheck];
            });
        }
    // 设置
    }else if (_style == kGestureLockSet) {
        NSString *pwd = [self passwordStringFromPasswordArray:password];
        NSLog(@"s = %@", password);
        NSLog(@"array = %@", self.passwordArray);
        NSLog(@"pwd = %@", pwd);
        
        if (self.passwordArray.count > 0) {
            // 2次输入密码相同
            if ([pwd isEqualToString:_passwordArray[0]]) {
                NSLog(@"success");
                lockView.state = kZHKGestureLockStateSuccess;
                // 保存密码
                [[NSUserDefaults standardUserDefaults] setValue:pwd forKey:GESTURE_PASSWORD_KEY];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            // 2次输入不相同
            }else {
                lockView.state = kZHKGestureLockStateFailed;
//                [self.passwordArray addObject:pwd];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [lockView resetCheck];
                });
            }
        }else {
            [self.passwordArray addObject:pwd];
            lockView.state = kZHKGestureLockStateNormal;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [lockView resetCheck];
            });
        }
    // 重设
    }else if (_style == kGestureLockReset) {
//        NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:GESTURE_PASSWORD_KEY];
        // 第一次验证已经通过, 开始设置
        if (_resetCheckSuccess) {
            if (self.passwordArray.count > 0) {
                if ([[self passwordStringFromPasswordArray:password] isEqualToString:[self passwordStringFromPasswordArray:_passwordArray[0]]]) {
                    lockView.state = kZHKGestureLockStateSuccess;
                    [[NSUserDefaults standardUserDefaults] setValue:[self passwordStringFromPasswordArray:password] forKey:GESTURE_PASSWORD_KEY];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                }else {
                    lockView.state = kZHKGestureLockStateFailed;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [lockView resetCheck];
                    });
                }
            }else {
                [self.passwordArray addObject:password];
                lockView.state = kZHKGestureLockStateNormal;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [lockView resetCheck];
                });
            }
        // 第一次验证未通过
        }else {
            if ([self checkGestureLockWithPassword:password]) {
                lockView.state = kZHKGestureLockStateSuccess;
                _resetCheckSuccess = YES;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [lockView resetCheck];
                });
                
            }else {
                lockView.state = kZHKGestureLockStateFailed;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [lockView resetCheck];
                });
            }
        }
    }
    
    return YES;
}

#pragma mark - 

- (BOOL)checkPassword:(NSArray *)password {
    NSString *passString = [self passwordStringFromPasswordArray:password];
    return [[[NSUserDefaults standardUserDefaults] valueForKey:GESTURE_PASSWORD_KEY] isEqualToString:passString];
}

- (NSString *)passwordStringFromPasswordArray:(NSArray *)passwordArray {
    if (passwordArray.count) {
        NSMutableString *string = [NSMutableString new];
        for (NSValue *pointValue in passwordArray) {
            [string appendFormat:@"+%@", NSStringFromCGPoint(pointValue.CGPointValue)];
        }
        return [string copy];
    }
    return @"";
}

#pragma mark - Getter

- (NSMutableArray *)passwordArray {
    if (_passwordArray == nil) {
        self.passwordArray = [NSMutableArray new];
    }
    return _passwordArray;
}

@end
