//
//  DropDownView.h
//  FOSinOC
//
//  Created by MoonSlides on 16/4/13.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DropDownView;
@protocol DropDownViewDelegate <NSObject>

@optional
-(void) dropDownMenuClicked:(DropDownView *)sender;
-(void) dropDownMenuDelete:(DropDownView *)sender withString:(NSString *)string;

@end

@interface DropDownView : UIView<UITableViewDelegate, UITableViewDataSource> {
    
}

@property(weak) id<DropDownViewDelegate> delegate;

@property (copy,nonatomic)NSString *choosedString;
@property (strong,nonatomic)UITableView *dropDownTableView;
@property (strong,nonatomic)NSMutableArray *dropDownList;

+(id)initDropDownView:(UIButton *)button cellHeight:(CGFloat)cellHeight viewHeight:(CGFloat)viewHeight Array:(NSMutableArray *)array;
-(void)hideDropDownView;
@end
