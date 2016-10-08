//
//  Shop.h
//  FOSinOC
//
//  Created by MoonSlides on 16/4/29.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYModel/YYModel.h>
#import "Item.h"

@class Shop;
@protocol ShopDelegate
@optional
-(void)finishSearchShops:(NSDictionary *)shops;
-(void)shopFinishFetchData;
-(void)shopFinishFetchComment;
@end

@interface Shop : NSObject
@property(copy,nonatomic) NSString * _id;
@property(copy,nonatomic) NSString * shopID;
@property(copy,nonatomic) NSString *shopPicUrl;
@property(copy,nonatomic) NSString* shopName;
@property(copy,nonatomic) NSString* shopAddress;

@property(strong,nonatomic) NSMutableArray *shopCatagory;
@property(strong,nonatomic) NSArray *dishs;
@property(strong,nonatomic) NSDictionary *shopItems;
@property(copy,nonatomic) NSString* startPrice;
@property(strong,nonatomic) NSNumber *shopMark;
@property(strong,nonatomic) NSNumber *distance;
@property(strong,nonatomic) NSMutableArray *shopComments;

@property(strong,nonatomic) UIImage *shopImage;
@property (strong, nonatomic) NSDictionary *imageCache;
@property(weak)id <ShopDelegate> delegate;

+(Shop *) sharedManager;
-(void)searchShopByLocation:(NSArray *)location withdistance:(NSNumber *)distance;
-(void)fetchShopData:(NSString *)shopId;
-(void)fetchShopDataModelingByYYKit:(NSString *)shopId;
@end
