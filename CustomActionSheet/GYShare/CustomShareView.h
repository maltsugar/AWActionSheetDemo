//
//  CustomShareView.h
//  CustomActionSheet
//
//  Created by zgy on 16/5/3.
//  Copyright © 2016年 zgy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomShareView;
@protocol CustomShareViewDelegate <NSObject>

@optional
- (void)didClickItemAtIndex:(NSInteger)idx inShareView:(CustomShareView *)sView;

@end

@interface CustomShareView : UIView


@property (nonatomic,   weak) id<CustomShareViewDelegate> delegate;

// 内容为字典 @{@"title": @"xxx", @"img": @"123"}
@property (nonatomic, strong) NSArray *shareItems;

+ (instancetype)viewWithShareItems:(NSArray *)arr;

@end
