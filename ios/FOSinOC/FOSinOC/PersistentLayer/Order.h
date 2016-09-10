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
@class Order;
@protocol OrderDelegate <NSObject>

@optional

- (void)OrderFinishPlaceOrder:(NSDictionary *)order;

@end

@interface Order : NSObject



@end
