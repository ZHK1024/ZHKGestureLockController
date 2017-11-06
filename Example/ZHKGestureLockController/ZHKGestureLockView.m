//
//  ZHKGestureLockView.m
//  Example
//
//  Created by ZHK on 2017/3/13.
//  Copyright © 2017年 Weiyu. All rights reserved.
//

#import "ZHKGestureLockView.h"
#import "ZHKGestureNodeView.h"

#define LINE_COLOR_NORMAL COLOR(30, 176, 239, 1)    // 普通颜色
#define LINE_COLOR_SUCCESS COLOR(38, 199, 10, 1)    // 成功颜色
#define LINE_COLOR_FAILED COLOR(215, 57, 54, 1)     // 失败颜色

@interface ZHKGestureLockView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *nodes;        // 所有节点的容器
@property (nonatomic, strong) NSMutableArray *selectNodes;  // 被选中的节点容器
@property (nonatomic, strong) CAShapeLayer   *pathLayer;    // 选择路径显示层

@end

@implementation ZHKGestureLockView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

#pragma mark - UI

/**
 创建基本 UI
 */
- (void)createUI {
    self.backgroundColor = [UIColor clearColor];
    [self.layer addSublayer:self.pathLayer];
    self.clipsToBounds = YES;
    
    CGFloat width = CGRectGetWidth(self.bounds);
    
    CGFloat gap = width * 0.1;
    CGFloat size = width * 0.16;
    
    for (NSInteger lIndex = 0; lIndex < 3; ++lIndex) {
        CGFloat y = gap * lIndex + size * (lIndex + 1);
        for (NSInteger cIndex = 0; cIndex < 3; ++cIndex) {
            CGFloat x = size * (cIndex + 1) + gap * cIndex;
            ZHKGestureNodeView *nodeView = [[ZHKGestureNodeView alloc] initWithFrame:CGRectMake(x, y, size, size)];
            nodeView.location = CGPointMake(cIndex, lIndex);
            [self addSubview:nodeView];
            [self.nodes addObject:nodeView];
        }
    }
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self addGestureRecognizer:pan];
}

/**
 根据 state 设置页面 UI 样式

 @param state state
 */
- (void)setUIStyleWithState:(ZHKGestureLockState)state {
    switch (state) {
            case kZHKGestureLockStateNormal:
            _pathLayer.strokeColor = LINE_COLOR_NORMAL.CGColor;
            [_selectNodes makeObjectsPerformSelector:@selector(setNormalStyle)];
            break;
        case kZHKGestureLockStateSuccess:
            _pathLayer.strokeColor = LINE_COLOR_SUCCESS.CGColor;
            [_selectNodes makeObjectsPerformSelector:@selector(setSuccessStyle)];
            break;
        case kZHKGestureLockStateFailed:
            _pathLayer.strokeColor = LINE_COLOR_FAILED.CGColor;
            [_selectNodes makeObjectsPerformSelector:@selector(setFailedStyle)];
            break;
        default:
            _pathLayer.strokeColor = LINE_COLOR_NORMAL.CGColor;
            [_selectNodes makeObjectsPerformSelector:@selector(setNormalStyle)];
            break;
    }
//    [_selectNodes removeAllObjects];
}

/**
 检测 node 是否被选中
 */
- (void)checkNodesWithLocation:(CGPoint)location {
    for (ZHKGestureNodeView *node in self.nodes) {
        if (!node.selected && [node isInNodeWithLocation:location]) {
            node.selected = YES;
            [self.selectNodes addObject:node];
        }
    }
}

/**
 绘制选择路径

 @param location 当前触点坐标, 传入 CGPointZero 意为密码绘制结束
 */
- (void)drawPathLineWithLocation:(CGPoint)location {
    if (_selectNodes.count > 0) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        for (NSInteger i = 0; i < _selectNodes.count; ++i) {
            ZHKGestureNodeView *node = _selectNodes[i];
            if (i == 0) {
                [path moveToPoint:node.center];
            }else {
                [path addLineToPoint:node.center];
            }
        }
        // 以传入参数 location = CGPointZero 为标记, 意为密码绘制结束
        if (!CGPointEqualToPoint(location, CGPointZero)) {
            // 绘制触点与最后一个选择点之间的连线
            [path addLineToPoint:location];
        }
        _pathLayer.path = path.CGPath;
    }
}


#pragma mark - Action

/**
 重置验证
 */
- (void)resetCheck {
    self.state = kZHKGestureLockStateNormal;
    [_selectNodes makeObjectsPerformSelector:@selector(setNormalStyle)];
    [_selectNodes removeAllObjects];
    _pathLayer.path = nil;
    // 开启交互
    self.userInteractionEnabled = YES;
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    CGPoint location = [pan locationInView:self];
    [self checkNodesWithLocation:location];
    
    // 如果手势结束 失败 取消, 则最后一个点不进行连线绘制
    if (pan.state == UIGestureRecognizerStateEnded ||
        pan.state == UIGestureRecognizerStateCancelled ||
        pan.state == UIGestureRecognizerStateFailed) {
        [self drawPathLineWithLocation:CGPointZero];
        // 关闭交互, 避免再次绘制
        self.userInteractionEnabled = NO;
        if (_selectNodes.count > 0 &&[_delegate respondsToSelector:@selector(gestureLockView:checkResultWithPassword:)]) {
            [_delegate gestureLockView:self checkResultWithPassword:[self nodesLocation2PasswordString]];
        }
    }else {
        [self drawPathLineWithLocation:location];
    }
}

/**
 通过选择结果生成密码
 
 @return 生成密码
 */
- (NSArray *)nodesLocation2PasswordString {
    if (_selectNodes.count > 0) {
        NSMutableArray *password = [NSMutableArray new];
        for (ZHKGestureNodeView *node in _selectNodes) {
            [password addObject:[NSValue valueWithCGPoint:node.location]];
        }
        return [password copy];
    }
    return nil;
}

#pragma mark - Setter

- (void)setState:(ZHKGestureLockState)state {
    if (_state != state) {
        _state = state;
        [self setUIStyleWithState:state];
    }
}

#pragma mark - Getter

- (NSMutableArray *)nodes {
    if (_nodes == nil) {
        self.nodes = [NSMutableArray new];
    }
    return _nodes;
}

- (NSMutableArray *)selectNodes {
    if (_selectNodes == nil) {
        self.selectNodes = [NSMutableArray new];
    }
    return _selectNodes;
}

- (CAShapeLayer *)pathLayer {
    if (_pathLayer == nil) {
        self.pathLayer = [[CAShapeLayer alloc] init];
        self.frame = self.bounds;
        _pathLayer.strokeColor = LINE_COLOR_NORMAL.CGColor;
        _pathLayer.fillColor = [UIColor clearColor].CGColor;
        _pathLayer.lineWidth = 6.0;
    }
    return _pathLayer;
}

@end
