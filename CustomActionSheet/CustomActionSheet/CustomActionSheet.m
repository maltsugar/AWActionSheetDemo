//
//  CustomActionSheet.m
//  CustomActionSheet
//
//  Created by zgy on 16/5/3.
//  Copyright © 2016年 zgy. All rights reserved.
//

#import "CustomActionSheet.h"



@interface CustomActionSheet ()

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation CustomActionSheet

- (UIButton *)cancelBtn
{
    if (nil == _cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn addTarget:self action:@selector(handleCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.layer.cornerRadius = 5.0;
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        [self addSubview:_cancelBtn];
    }
    return _cancelBtn;
}

- (UIView *)containerView
{
    if (nil == _containerView) {
        _containerView = [[UIView alloc]init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 5.0;
        _containerView.clipsToBounds = YES;
        [self addSubview:_containerView];
    }
    return _containerView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    }
    return self;
}

+ (instancetype)actionSheet
{
    return [[self alloc]init];
}

- (void)setContent:(UIView *)content
{
    if (_content) {
        [_content removeFromSuperview];
    }
    
    _content = content;
    
    // 容器（大view）frame
    self.containerView.frame = CGRectMake(kLeftAndRightSpace, SCREEN_H, SCREEN_W - 2*kLeftAndRightSpace, CGRectGetHeight(content.frame) + 2*kContainerRoundSpace);
    [self.containerView addSubview:content];
    
    // 设置内容center
    CGPoint contentCenter = content.center;
    contentCenter.x = CGRectGetWidth(self.containerView.frame) * 0.5;
    contentCenter.y = CGRectGetHeight(self.containerView.frame) * 0.5;
    content.center = contentCenter;
}

- (void)setContentViewController:(UIViewController *)contentViewController
{
    _contentViewController = contentViewController;
    [self setContent:contentViewController.view];
}


- (void)show
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    self.frame = window.bounds;
    [window addSubview:self];
    
    
    CGRect containerFrame = self.containerView.frame;
    self.cancelBtn.frame = CGRectMake(10, CGRectGetMaxY(self.containerView.frame) + 10, SCREEN_W - 2*kLeftAndRightSpace, 44.0);
    
    // 向上移动 自身高度 和 按钮高度
    containerFrame.origin.y -= (64.0 + containerFrame.size.height);
    
    [UIView animateWithDuration:0.55
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.5
                        options:(UIViewAnimationOptionBeginFromCurrentState|
                                 UIViewAnimationOptionCurveEaseInOut|
                                 UIViewAnimationOptionLayoutSubviews)
                     animations:^{
                         
                         self.containerView.frame = containerFrame;
            
                         // 取消按钮
                         self.cancelBtn.frame = CGRectMake(10, CGRectGetMaxY(self.containerView.frame) + 10, SCREEN_W - 2*kLeftAndRightSpace, 44.0);
                     } completion:nil];
    
    
    if ([self.delegate respondsToSelector:@selector(actionSheetDidShow:)]) {
        [self.delegate actionSheetDidShow:self];
    }
    
}

- (void)dismiss
{
    
    
    CGRect containerFrame = self.containerView.frame;
    
    // 向下移动 到屏幕外
    containerFrame.origin.y = SCREEN_H;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.frame = containerFrame;
        // 取消按钮
        self.cancelBtn.frame = CGRectMake(10, CGRectGetMaxY(self.containerView.frame) + 10, SCREEN_W - 2*kLeftAndRightSpace, 44.0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    
    if ([self.delegate respondsToSelector:@selector(actionSheetDidDismiss:)]) {
        [self.delegate actionSheetDidDismiss:self];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

#pragma mark- 取消按钮
- (void)handleCancelBtn
{
    [self dismiss];
}

@end
