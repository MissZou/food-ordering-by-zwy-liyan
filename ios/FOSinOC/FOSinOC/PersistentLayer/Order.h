//
//  Order.h
//  FOSinOC
//
//  Created by MoonSlides on 16/9/8.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#import "Item.h"
#import "Shop.h"
#import "Address.h"

@class Order;
@protocol OrderDelegate <NSObject>

@optional

- (void)OrderFinishPlaceOrder:(NSDictionary *)order;

@end
@class Item;
@interface Order : NSObject
@property (copy, nonatomic) NSString *_id;
@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSString *message;
@property (strong ,nonatomic) NSMutableArray *items;
@property (strong, nonatomic) Shop *shop;
@property (strong, nonatomic) Address *address;
@property (copy, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *date;
@property (copy, nonatomic) NSString *shippedDate;
@property (copy, nonatomic) NSString *confirmedDate;
@end
