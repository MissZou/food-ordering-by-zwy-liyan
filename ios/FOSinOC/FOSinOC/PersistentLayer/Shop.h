//
//  Shop.h
//  FOSinOC
//
//  Created by MoonSlides on 16/4/29.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Shop : NSObject
@property(copy,nonatomic) NSString * shopID;
@property(copy,nonatomic) NSString *shopPicUrl;
@property(copy,nonatomic) NSString* shopName;
@property(copy,nonatomic) NSString* shopAddress;

@property(strong,nonatomic) NSMutableArray *shopCatagory;
@property(strong,nonatomic) NSMutableArray *shopFoods;
@property(copy,nonatomic) NSString* startPrice;
@property(strong,nonatomic) NSNumber *shopMark;
@property(strong,nonatomic) NSNumber *distance;
@property(strong,nonatomic) NSMutableArray *shopComments;

@end
