//
//  ChooseAddressViewController.h
//  FOSinOC
//
//  Created by MoonSlides on 16/6/29.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChooseAddressViewController;
@protocol ChooseAddressViewDelegate <NSObject>

@optional

-(void)ChooseAddressViewDidSelectedAddressWithName:(NSString *)name phone:(NSString *)phone address:(NSString *)address addrDict:(NSDictionary *)addrDict;

@end


@interface ChooseAddressViewController : UIViewController
@property(weak) id<ChooseAddressViewDelegate> delegate;
@end
