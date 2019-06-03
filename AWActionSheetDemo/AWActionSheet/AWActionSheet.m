//
//  AWActionSheet.m
//  AWActionSheetDemo
//
//  Created by mac on 2019/5/31.
//  Copyright © 2019 mac. All rights reserved.
//

#import "AWActionSheet.h"

@interface AWActionSheet ()


// 隐藏按钮时 这两个值设置为0 ， 否则 44  10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelBtnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelBtnBottom;
// ⏫⏫⏫



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBot; // -kBottomViewHeight  or  bottomSafe
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewTrailing;




@property (weak, nonatomic) IBOutlet UIView *contentView;


@property (nonatomic, assign) CGFloat totalHeight;
@property (nonatomic, assign) CGFloat cancelAreaHeight;

@end



@implementation AWActionSheet


+ (instancetype)actionSheet
{
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    AWActionSheet *sheet = [arr lastObject];
    sheet.showCancelBtn = YES;
    sheet.shouldDismissOnTouchOutside = YES;
    sheet.totalHeight = sheet.contentViewHeight.constant + sheet.cancelAreaHeight;
    sheet.bottomViewBot.constant = -sheet.totalHeight;
    sheet.sheetLeading = 10.f;
    sheet.sheetTrailing = 10.f;
    return sheet;
}

- (void)setContent:(id)content height:(CGFloat)height
{
    UIView *cview = nil;
    if ([content isKindOfClass:[UIView class]]){
        cview = content;
    }
    if ([content isKindOfClass:[UIViewController class]]){
        UIViewController *vc = (UIViewController *)content;
        cview = vc.view;
    }
    
    if (cview) {
        cview.translatesAutoresizingMaskIntoConstraints = NO;
        _contentViewHeight.constant = height;
        [self.contentView addSubview:cview];

        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[cview]|" options:0 metrics:nil views:@{@"cview": cview}]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cview]|" options:0 metrics:nil views:@{@"cview": cview}]];
        
    }
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    
    
    UIView *sheetBaseView = self;
    sheetBaseView.translatesAutoresizingMaskIntoConstraints = NO;
    [window addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[sheetBaseView]|" options:0 metrics:nil views:@{@"sheetBaseView": sheetBaseView}]];
    [window addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[sheetBaseView]|" options:0 metrics:nil views:@{@"sheetBaseView": sheetBaseView}]];
    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.bottomViewBot.constant = self.awSafeAreaInset.bottom;
        [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (finished && [self.delegate respondsToSelector:@selector(actionSheetDidAppear:)]) {
                [self.delegate actionSheetDidAppear:self];
            }
        }];
    });
   
    
    
}
- (void)dismiss
{
    self.bottomViewBot.constant = -_totalHeight;
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished && [self.delegate respondsToSelector:@selector(actionSheetDidDismiss:)]) {
            [self.delegate actionSheetDidDismiss:self];
        }
        [self removeFromSuperview];
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (_shouldDismissOnTouchOutside) {
        [self dismiss];
    }
    
}

- (IBAction)handleCancelBtnAction {
    [self dismiss];
}



- (UIEdgeInsets)awSafeAreaInset {
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        return mainWindow.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}


- (void)setShowCancelBtn:(BOOL)showCancelBtn
{
    _showCancelBtn = showCancelBtn;
    if (_showCancelBtn) {
        _cancelBtn.hidden = NO;
        _cancelBtnHeight.constant = 44.f;
        _cancelBtnBottom.constant = 10.f;
    
    }else {
        _cancelBtn.hidden = YES;
        _cancelBtnHeight.constant = 0;
        _cancelBtnBottom.constant = 0.f;
    }
    
    _cancelAreaHeight = 10 + _cancelBtnHeight.constant + _cancelBtnBottom.constant;
}

- (void)safeAreaInsetsDidChange
{
    UIEdgeInsets inset = [self awSafeAreaInset];
//    NSLog(@"%@", NSStringFromUIEdgeInsets(inset));
    _bottomViewLeading.constant = self.sheetLeading + inset.left;
    _bottomViewTrailing.constant = self.sheetTrailing + inset.right;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.widthChanged) {
        CGFloat width = UIScreen.mainScreen.bounds.size.width - _bottomViewLeading.constant - _bottomViewTrailing.constant;
        self.widthChanged(width);
    }
}

//- (void)dealloc {
//    NSLog(@"%s", __func__);
//}

@end
