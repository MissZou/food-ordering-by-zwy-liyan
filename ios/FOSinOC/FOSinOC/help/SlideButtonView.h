//
//  SlideButtonView.h
//  FOSinOC
//
//  Created by MoonSlides on 16/4/20.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SlideButtonView;
@protocol SlideButtonDelegate <NSObject>
-(void)slideButtionClicked;

@end

@interface SlideButtonView : UIView

@property(assign,nonatomic) CGFloat buttonWidth;

+(id)initSlideButton:(NSArray *)buttonTitle;
-(void)addTitle:(NSArray *)buttonTitle;
@end
