//
//  OrderDetailViewController.h
//  FOSinOC
//
//  Created by MoonSlides on 16/9/9.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
@interface OrderDetailViewController : UIViewController
@property (copy, nonatomic)NSString *orderStatus;
@property (strong, nonatomic) Order *order;
@property (copy, nonatomic) NSArray *itemList;
@property (strong, nonatomic) UIImage *shopImage;
@property (assign, nonatomic) NSInteger *totalPrice;
@property (strong ,nonatomic) NSDictionary *address;
@end
