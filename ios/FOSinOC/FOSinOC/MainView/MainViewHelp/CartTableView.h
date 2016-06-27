//
//  CartTableView.h
//  FOSinOC
//
//  Created by MoonSlides on 16/6/26.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CartTableView;
@protocol CartTableViewDelegate <NSObject>

@optional

-(void)cartTableViewDidFinishDismissAnimation;

@end

@interface CartTableView : UIView
@property(weak)id <CartTableViewDelegate> delegate;
-(void)initCartTableView:(NSArray *)cartDetail;
-(void)dismissCartTableViewAnimation;
@end
