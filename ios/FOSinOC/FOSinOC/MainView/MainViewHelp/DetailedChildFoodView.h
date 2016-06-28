//
//  DetailedChildFoodView.h
//  FOSinOC
//
//  Created by MoonSlides on 16/4/26.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DetailedChildFoodView;
@protocol DetailedChildFoodViewDelegate <NSObject>

@optional

-(void) detailedChildFoodDidSelectItem:(NSDictionary *)item image:(UIImage *)image shopId:(NSString *)shopId;
-(void) detailedChildFoodCheckout;

@end

@interface DetailedChildFoodView : UIViewController
@property(copy,nonatomic)NSString *shopID;
@property(assign,nonatomic)BOOL isEnableInteraction;
@property(strong,nonatomic)UIView *cartView;// set to public for adjust view origin y

@property(strong,nonatomic)NSDictionary *itemList;
@property(strong,nonatomic)NSArray *catagory;

@property(weak)id <DetailedChildFoodViewDelegate> delegate;
@end
