//
//  SearchViewHelp.h
//  FOSinOC
//
//  Created by MoonSlides on 16/4/13.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"
@class SearchViewHelpController;
@protocol SearchViewHelpControllerDelegate <NSObject>

@optional
-(void) finishSearchLocationWithResult:(NSArray *)result;
-(void) finishChooseLocationWithLocation:(NSDictionary *)location;
@end

@interface SearchViewHelpController : NSObject<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate, UISearchResultsUpdating>

@property(weak) id<SearchViewHelpControllerDelegate> delegate;

@end
