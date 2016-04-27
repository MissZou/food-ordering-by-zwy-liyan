//
//  SlideButtonView.h
//  FOSinOC
//
//  Created by MoonSlides on 16/4/20.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SlideMultiViewController;
@protocol SlideMultiViewControllerDelegate <NSObject>
-(void)slideButtionClicked:(NSString *)title;

@end

@interface SlideMultiViewController : UIViewController
@property(assign,nonatomic) CGFloat buttonWidth;

@property(weak) id<SlideMultiViewControllerDelegate> delegate;



-(void)markButtonSelected:(NSInteger)tag;
-(void)initSlideMultiView:(NSArray *)viewControllerArray withTitle:(NSArray *)title;
-(void)initSlideButtonAddTitle:(NSArray *)buttonTitle;
@end
