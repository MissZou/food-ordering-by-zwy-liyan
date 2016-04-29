//
//  Food.h
//  FOSinOC
//
//  Created by MoonSlides on 16/4/29.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Food : NSObject

@property(copy,nonatomic) NSString *foodName;
@property(copy,nonatomic) NSString *foodPicUrl;
@property(strong,nonatomic) NSArray *foodTags;
@property(copy,nonatomic) NSString *foodInfo;

@end
