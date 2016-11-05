//
//  OrderInfoViewController.h
//  FOSinOC
//
//  Created by MoonSlides on 16/9/8.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Address.h"
#import "Order.h"

@interface OrderInfoViewController : UIViewController
typedef NS_ENUM(NSUInteger, status){
    CREATED = 0,
    PAID,
    SHIPPED,
    RECEIVED
};
@property (copy, nonatomic) NSArray *itemList;
@property (copy, nonatomic) NSString *shopName;
@property (strong, nonatomic) UIImage *shopImage;
@property (strong, nonatomic) NSDictionary *address;
@property (copy, nonatomic) NSString *orderStatus;
@property (assign, nonatomic) NSInteger *totalPrice;
@property (strong, nonatomic) Order *order;

@end
