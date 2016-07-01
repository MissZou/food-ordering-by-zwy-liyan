//
//  WriteMessageViewController.h
//  FOSinOC
//
//  Created by MoonSlides on 16/6/30.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WriteMessageViewController;
@protocol WriteMessageViewDelegate <NSObject>

-(void)WriteMessageViewFinishEnterWithMessage:(NSString *)message;

@end

@interface WriteMessageViewController : UIViewController
@property(strong,nonatomic) NSString *message;
@property(weak)id<WriteMessageViewDelegate> delegate;

@end
