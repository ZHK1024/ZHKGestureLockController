//
//  ZHKGestureNodeView.m
//  Example
//
//  Created by ZHK on 2017/3/13.
//  Copyright © 2017年 Weiyu. All rights reserved.
//

#import "ZHKGestureNodeView.h"



// default normal color
#define NORMAL_CIRCLE_STROKE_COLOR COLOR(86, 88, 91, 1) // 范围边界颜色(大圆颜色)
#define NORMAL_CIRCLE_FILL_COLOR [[UIColor blackColor] colorWithAlphaComponent:0.5] // 范围填充颜色(大圆填充颜色)
#define NORMAL_POINT_STROKE_COLOR [UIColor clearColor] // 中心点颜色
// default select color
#define SELECT_CIRCLE_STROKE_COLOR COLOR(42, 151, 193, 1)
#define SELECT_CIRCLE_FILL_COLOR [[UIColor blackColor] colorWithAlphaComponent:0.5]
#define SELECT_POINT_STROKE_COLOR COLOR(30, 176, 239, 1)
// default success color
#define SUCCESS_CIRCLE_STROKE_COLOR COLOR(86, 88, 91, 1)
#define SUCCESS_CIRCLE_FILL_COLOR [[UIColor blackColor] colorWithAlphaComponent:0.5]
#define SUCCESS_POINT_STROKE_COLOR COLOR(38, 199, 10, 1)
// default failed color
#define FAILED_CIRCLE_STROKE_COLOR COLOR(86, 88, 91, 1)
#define FAILED_CIRCLE_FILL_COLOR [[UIColor blackColor] colorWithAlphaComponent:0.5]
#define FAILED_POINT_STROKE_COLOR COLOR(215, 57, 54, 1)

@interface ZHKGestureNodeView ()

@property (nonatomic, strong) CAShapeLayer *circleLayer;    // 轮廓线
@property (nonatomic, strong) CAShapeLayer *pointLayer;     // 中心圆点

@end

@implementation ZHKGestureNodeView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.layer addSublayer:self.circleLayer];
        [self.layer addSublayer:self.pointLayer];
    }
    return self;
}

#pragma mark -

- (BOOL)isInNodeWithLocation:(CGPoint)location {
    return CGRectContainsPoint(self.frame, location);
}

#pragma mark -

- (void)setNormalStyle {
    _selected = NO;
    _circleLayer.strokeColor = NORMAL_CIRCLE_STROKE_COLOR.CGColor;
    _pointLayer.strokeColor = NORMAL_POINT_STROKE_COLOR.CGColor;
    _pointLayer.fillColor = NORMAL_POINT_STROKE_COLOR.CGColor;
}

- (void)setSelectStyle {
    _circleLayer.strokeColor = SELECT_CIRCLE_STROKE_COLOR.CGColor;
    _pointLayer.strokeColor = SELECT_POINT_STROKE_COLOR.CGColor;
    _pointLayer.fillColor = SELECT_POINT_STROKE_COLOR.CGColor;
}

- (void)setSuccessStyle {
//    _circleLayer.strokeColor = NORMAL_CIRCLE_STROKE_COLOR.CGColor;
    _pointLayer.strokeColor = SUCCESS_CIRCLE_FILL_COLOR.CGColor;
    _pointLayer.fillColor = SUCCESS_POINT_STROKE_COLOR.CGColor;
}

- (void)setFailedStyle {
//    _circleLayer.strokeColor = NORMAL_CIRCLE_STROKE_COLOR.CGColor;
    _pointLayer.strokeColor = FAILED_CIRCLE_FILL_COLOR.CGColor;
    _pointLayer.fillColor = FAILED_POINT_STROKE_COLOR.CGColor;
}

#pragma mark - Setter

- (void)setSelected:(BOOL)selected {
    if (_selected != selected) {
        _selected = selected;
        if (_selected) {
            [self setSelectStyle];
        }else {
            [self setNormalStyle];
        }
    }
}

#pragma mark - Getter

- (CAShapeLayer *)circleLayer {
    if (_circleLayer == nil) {
        self.circleLayer = [[CAShapeLayer alloc] init];
        _circleLayer.frame = self.bounds;
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
        _circleLayer.path = path.CGPath;
        _circleLayer.strokeColor = NORMAL_CIRCLE_STROKE_COLOR.CGColor;
        _circleLayer.fillColor = NORMAL_CIRCLE_FILL_COLOR.CGColor;
        _circleLayer.lineWidth = 3.0;
    }
    return _circleLayer;
}

- (CAShapeLayer *)pointLayer {
    if (_pointLayer == nil) {
        self.pointLayer = [[CAShapeLayer alloc] init];
        _pointLayer.frame = self.bounds;
        CGFloat height = CGRectGetHeight(self.bounds);
        CGFloat width = CGRectGetWidth(self.bounds);
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(width / 3, height / 3, width / 3, height / 3)];
        _pointLayer.path = path.CGPath;
        _pointLayer.strokeColor = NORMAL_POINT_STROKE_COLOR.CGColor;
        _pointLayer.fillColor = NORMAL_POINT_STROKE_COLOR.CGColor;
    }
    return _pointLayer;
}

@end
