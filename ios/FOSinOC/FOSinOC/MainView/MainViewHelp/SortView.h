//
//  SortView.h
//  FOSinOC
//
//  Created by MoonSlides on 16/4/23.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SortView;
@protocol SortViewDelegate <NSObject>

-(void)sortOperation:(NSString *)opreation;

@end


@interface SortView : UIView<UITableViewDelegate,UITableViewDataSource>

@property(weak)id<SortViewDelegate> delegate;
-(void)initSortView;
@end
