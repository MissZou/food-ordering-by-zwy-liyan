//
//  DeliveryInfoViewController.h
//  FOSinOC
//
//  Created by MoonSlides on 16/9/9.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface DeliveryInfoViewController : UIViewController
@property (copy, nonatomic)NSString *orderStatus;
@property (strong, nonatomic) Order *order;
@end
