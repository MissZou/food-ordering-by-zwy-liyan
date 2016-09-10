//
//  Item.h
//  FOSinOC
//
//  Created by MoonSlides on 16/9/8.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#import "Commnet.h"

@interface Item : NSObject
@property (copy, nonatomic) NSString *dishName;
@property (assign, nonatomic) NSInteger price;
@property (copy, nonatomic) NSString *intro;
@property (copy, nonatomic) NSString *category;
@property (copy, nonatomic) NSString *dishPic;
@property (copy ,nonatomic) NSArray *tags;
@end
