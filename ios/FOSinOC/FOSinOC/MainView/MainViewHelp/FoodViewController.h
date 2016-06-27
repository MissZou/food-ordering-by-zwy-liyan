//
//  FoodViewController.h
//  FOSinOC
//
//  Created by MoonSlides on 16/5/26.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodViewController : UIViewController


@property(copy,nonatomic) NSString *itemId;
@property(copy,nonatomic) NSString *shopId;
@property(strong,nonatomic) UIImage *itemImage;
@property(strong,nonatomic) NSDictionary *item;

@end
