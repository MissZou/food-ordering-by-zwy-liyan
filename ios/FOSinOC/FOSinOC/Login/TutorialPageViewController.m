//
//  TutorialPageViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/7.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "TutorialPageViewController.h"

@interface TutorialPageViewController ()

@property(copy,nonatomic) NSString *labelStringForBtn;
@property(copy,nonatomic) NSString *labelStringColor;
@property(copy,nonatomic) NSString *labelStringBlack;

@end

@implementation TutorialPageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelStringForBtn = @"Log in with your account and Enjoy";
    self.labelStringColor = @"Log in";
    self.labelStringBlack = @" with your account and Enjoy";
    [self setAttributeString];
    //self.pageTitle.text = [@(self.pageIndex) stringValue];
    
    self.pageTitle.text = self.textTitle;
    self.imageView.image = [UIImage imageNamed:self.imageFile];
    self.introTextView.text = self.textContent;
    
    
    
    self.btnLogin.hidden = true;
    self.btnLoginText.hidden = true;
    
    if(self.pageIndex == 0){
        _btnLogin.hidden = false;
        _btnLoginText.hidden = true;
    }
    if (self.pageIndex == 2) {
        _btnLogin.hidden = true;
        _btnLoginText.hidden = false;
    }
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

-(void) setAttributeString{
    NSRange range = [self.labelStringForBtn rangeOfString:self.labelStringColor];
    NSRange rangeFull = [self.labelStringForBtn rangeOfString:self.labelStringForBtn];
    NSRange rangeBlack = [self.labelStringForBtn rangeOfString:self.labelStringBlack];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.labelStringForBtn];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:69/255.0 green:83/255.0 blue:153/255.0 alpha:1] range:range];
    
    //[attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:95/255.0 green:94/255.0 blue:95/255.0 alpha:1] range:rangeBlack];
    
    NSMutableAttributedString *attributedStringClicked = [[NSMutableAttributedString alloc] initWithString:self.labelStringForBtn];
    [attributedStringClicked addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.5 alpha:0.5] range:rangeFull];
    [attributedStringClicked addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:69/255.0 green:83/255.0 blue:153/255.0 alpha:0.5] range:range];
    [self.btnLoginText setAttributedTitle:attributedString forState:UIControlStateNormal];
    [self.btnLoginText setAttributedTitle:attributedStringClicked forState:UIControlStateHighlighted];
}

@end
