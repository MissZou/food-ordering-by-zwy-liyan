//
//  TutorialPageViewController.h
//  FOSinOC
//
//  Created by MoonSlides on 16/4/7.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialPageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *pageTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnLoginText;
@property (weak, nonatomic) IBOutlet UITextView *introTextView;

@property(assign,nonatomic) NSUInteger pageIndex;
@property(copy,nonatomic) NSString *imageFile;
@property(copy,nonatomic) NSString *textTitle;
@property(copy,nonatomic) NSString *textContent;


@end
