//
//  CustomCell.m
//  CustomActionSheet
//
//  Created by zgy on 16/5/3.
//  Copyright © 2016年 zgy. All rights reserved.
//

#import "CustomCell.h"

@interface CustomCell ()

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;


@end

@implementation CustomCell

- (void)setItemTitle:(NSString *)itemTitle
{
    _itemTitle = itemTitle;
    [_shareBtn setTitle:itemTitle forState:UIControlStateNormal];
    
}

- (void)setItemImgName:(NSString *)itemImgName
{
    _itemImgName = itemImgName;
    [_shareBtn setImage:[UIImage imageNamed:itemImgName] forState:UIControlStateNormal];
}

@end
