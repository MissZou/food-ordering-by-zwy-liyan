//
//  MainViewController.h
//  FOSinOC
//
//  Created by MoonSlides on 16/4/12.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownView.h"
#import "SearchViewHelpController.h"
#import "MainViewCell.h"
#import "CatagoryView.h"
#import "SortView.h"
#import "SlideButtonView.h"


@class MainViewController;
@protocol MainViewSearchControllerDelegate <NSObject>

@optional
-(void)finishSearchLocation:(NSString *)location;

@end
@interface MainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate,UIGestureRecognizerDelegate,SearchViewHelpControllerDelegate,DropDownViewDelegate,SlideButtonDelegate,CatagoryViewDelegate,SortViewDelegate>

@end
