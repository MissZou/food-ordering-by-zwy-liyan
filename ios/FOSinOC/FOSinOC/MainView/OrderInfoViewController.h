//
//  OrderInfoViewController.h
//  FOSinOC
//
//  Created by MoonSlides on 16/9/8.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Address.h"

@interface OrderInfoViewController : UIViewController
@property (copy, nonatomic) NSArray *itemList;
@property (copy, nonatomic) NSString *shopName;
@property (strong, nonatomic) UIImage *shopImage;
@property (strong ,nonatomic) NSDictionary *address;
@end
