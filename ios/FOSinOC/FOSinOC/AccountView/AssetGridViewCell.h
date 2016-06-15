//
//  AssetGridViewCell.h
//  FOSinOC
//
//  Created by MoonSlides on 16/6/15.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetGridViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImage *thumbnailImage;
@property (nonatomic, copy) NSString *representedAssetIdentifier;
@end
