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
-(void)slideButtionClicked:(NSString *)title;

@end

@interface SlideButtonView : UIView
@property(assign,nonatomic) CGFloat buttonWidth;

@property(weak) id<SlideButtonDelegate> delegate;

+(id)initSlideButton:(NSArray *)buttonTitle;
-(void)initSlideButtonAddTitle:(NSArray *)buttonTitle;
-(void)markButtonSelected:(NSInteger)tag;

@end
