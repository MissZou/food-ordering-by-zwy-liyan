//
//  SlideButtonView.h
//  FOSinOC
//
//  Created by MoonSlides on 16/4/20.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SlideMultiView;
@protocol SlideMultiDelegate <NSObject>
-(void)slideButtionClicked:(NSString *)title;

@end

@interface SlideMultiView : UIView
@property(assign,nonatomic) CGFloat buttonWidth;

@property(weak) id<SlideMultiDelegate> delegate;



-(void)markButtonSelected:(NSInteger)tag;
-(void)initSlideMultiView:(NSArray *)viewControllerArray withTitle:(NSArray *)title;
@end
