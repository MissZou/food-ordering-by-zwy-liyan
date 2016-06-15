//
//  AssetGridViewController.h
//  FOSinOC
//
//  Created by MoonSlides on 16/6/15.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Photos;

@interface AssetGridViewController : UIViewController

@property (nonatomic, strong) PHFetchResult *assetsFetchResults;
@property (nonatomic, strong) PHAssetCollection *assetCollection;

@end
