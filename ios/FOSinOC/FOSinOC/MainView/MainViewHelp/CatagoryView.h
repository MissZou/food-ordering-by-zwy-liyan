//
//  CatagoryView.h
//  FOSinOC
//
//  Created by MoonSlides on 16/4/22.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CatagoryView;
@protocol CatagoryViewDelegate <NSObject>

-(void)finishChooseCatagory:(NSString *)catagory;

@end
@interface CatagoryView : UIView<UITableViewDelegate,UITableViewDataSource>
@property(weak) id<CatagoryViewDelegate> delegate;
-(void)initCatagoryView:(NSDictionary *)catagory;

@end
