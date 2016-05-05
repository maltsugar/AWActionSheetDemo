//
//  CustomActionSheet.h
//  CustomActionSheet
//
//  Created by zgy on 16/5/3.
//  Copyright © 2016年 zgy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLeftAndRightSpace 10.0
#define kContainerRoundSpace 20.0

#define SCREEN_W [[UIScreen mainScreen]bounds].size.width
#define SCREEN_H [[UIScreen mainScreen]bounds].size.height

@class CustomActionSheet;
@protocol CustomActionSheetDelegate <NSObject>

@optional
- (void)actionSheetDidShow:(CustomActionSheet *)sheet;

- (void)actionSheetDidDismiss:(CustomActionSheet *)sheet;


@end


@interface CustomActionSheet : UIView


@property (nonatomic,   weak) id<CustomActionSheetDelegate> delegate;

// content 的width 必须小于 screenWidth - 2*kLeftAndRightSpace, 建议宽度：screenWidth - 2*(kLeftAndRightSpace + kContainerRoundSpace)
@property (nonatomic, strong) UIView *content;
@property (nonatomic, strong) UIViewController *contentViewController;

+ (instancetype)actionSheet;

- (void)show;

- (void)dismiss;

@end
