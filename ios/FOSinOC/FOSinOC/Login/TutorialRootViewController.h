//
//  TutorialRootViewController.h
//  FOSinOC
//
//  Created by MoonSlides on 16/4/7.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TutorialPageViewController.h"
@interface TutorialRootViewController : UIViewController<UIPageViewControllerDataSource>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@end
