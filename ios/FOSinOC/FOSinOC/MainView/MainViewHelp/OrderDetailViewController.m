//
//  OrderDetailViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/9/9.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "OrderDetailViewController.h"

static const CGFloat slideTitleHeight = 40;
static const CGFloat sdNavigationBarHeight = 64;

@interface OrderDetailViewController ()

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    NSLog(@"%f",self.view.frame.origin.y);
    //self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - slideTitleHeight - sdNavigationBarHeight);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //[self initView];
    //self.view.frame = CGRectMake(0, slideTitleHeight, self.view.frame.size.width, self.view.frame.size.height - slideTitleHeight - sdNavigationBarHeight);
    //NSLog(@"%f",self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView {
    self.view.backgroundColor = [UIColor blueColor];
    self.view.frame = CGRectMake(0, slideTitleHeight, self.view.frame.size.width, self.view.frame.size.height - slideTitleHeight - sdNavigationBarHeight);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
