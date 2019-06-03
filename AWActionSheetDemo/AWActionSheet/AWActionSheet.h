//
//  AWActionSheet.h
//  AWActionSheetDemo
//
//  Created by mac on 2019/5/31.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AWActionSheet;
@protocol AWActionSheetDelegate <NSObject>

@optional
- (void)actionSheetDidAppear:(AWActionSheet *)sheet;
- (void)actionSheetDidDismiss:(AWActionSheet *)sheet;


@end



typedef void(^AWActionSheetWidthChangedCallBack)(CGFloat width);

@interface AWActionSheet : UIView


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (nonatomic, weak, nullable) id<AWActionSheetDelegate> delegate;
@property (nonatomic, assign) BOOL shouldDismissOnTouchOutside; // 点击空白区域是否消失（默认YES）
@property (nonatomic, assign) BOOL showCancelBtn; // 显示底部取消按钮（默认YES）

@property (nonatomic, assign) CGFloat sheetLeading; // 10 by default
@property (nonatomic, assign) CGFloat sheetTrailing; // 10 by default


@property (nonatomic,   copy) AWActionSheetWidthChangedCallBack widthChanged;

+ (instancetype)actionSheet;



/**
 设置内容和高度

 @param content vc/ view
 @param height 高度
 */
- (void)setContent:(id)content height:(CGFloat)height;


- (void)show;
- (void)dismiss;



@end

NS_ASSUME_NONNULL_END
