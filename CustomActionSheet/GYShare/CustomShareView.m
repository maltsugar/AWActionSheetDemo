//
//  CustomShareView.m
//  CustomActionSheet
//
//  Created by zgy on 16/5/3.
//  Copyright © 2016年 zgy. All rights reserved.
//

#import "CustomShareView.h"
#import "CustomCell.h"

@interface CustomShareView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionLayout;

@end


NSArray *_itemsBuffer;
@implementation CustomShareView


+ (instancetype)viewWithShareItems:(NSArray *)arr
{
    _itemsBuffer = arr;
    NSArray *nibArr = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    return [nibArr firstObject];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.shareItems = _itemsBuffer;
        
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellWithReuseIdentifier:@"GYCustomShareCell"];
    
    self.collectionLayout.itemSize = CGSizeMake(80, 80);
    self.collectionLayout.minimumLineSpacing = 10.0;
    self.collectionLayout.minimumInteritemSpacing = 10.0;
    
}


#pragma mark- <UICollectionViewDelegate, UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shareItems.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GYCustomShareCell" forIndexPath:indexPath];
    
    NSDictionary *dic = self.shareItems[indexPath.item];
    cell.itemTitle = dic[@"title"];
    cell.itemImgName = dic[@"img"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didClickItemAtIndex:inShareView:)]) {
        [self.delegate didClickItemAtIndex:indexPath.item inShareView:self];
    }
}

#pragma mark-
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
@end
