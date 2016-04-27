//
//  ShopDetailedViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/26.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "ShopDetailedViewController.h"
#import "SlideMultiViewController.h"
#import "DetailedChildFoodView.h"
#import "DetailedChildShopView.h"
#import "DetailedChildCommentView.h"
@interface ShopDetailedViewController ()<UIScrollViewDelegate>

@property(strong,nonatomic) UIScrollView *mainScrollView;
@property(strong,nonatomic)  DetailedChildFoodView *foodView;
@property(strong,nonatomic)  DetailedChildShopView *shopView;
@property(strong,nonatomic)  DetailedChildCommentView *commentView;
@property(assign,nonatomic) BOOL isContinueScrolling;
@end

@implementation ShopDetailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.foodView = [[DetailedChildFoodView alloc]init];
    self.shopView = [[DetailedChildShopView alloc]init];
    self.commentView = [[DetailedChildCommentView alloc]init];
    self.foodView.shopID = self.shopID;
    
    
    NSArray *title = @[@"Food", @"Shop", @"Comment"];
    NSArray *viewArray = @[self.foodView, self.shopView, self.commentView];
    SlideMultiViewController *slideMultiViewController = [[SlideMultiViewController alloc]init];
    //slideMultiViewController.view.frame =CGRectMake(0, 164, self.view.frame.size.width, self.view.frame.size.height - 164);
    slideMultiViewController.view.frame =CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 64);
    [self addChildViewController:slideMultiViewController];
    [slideMultiViewController initSlideMultiView:viewArray withTitle:title];
  
    
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    self.mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+100);
    self.mainScrollView.pagingEnabled = false;
    self.mainScrollView.delegate = self;
    [self.mainScrollView addSubview:slideMultiViewController.view];
    [self.view addSubview:self.mainScrollView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainContinueScrolling) name:@"mainContinueScrolling" object:nil];
}

-(void) triggerNotificationAction:(NSNotification *) notification
{
    if ([notification.object isKindOfClass:[NSNumber class]])
    {
        NSNumber *y = [notification object];
        NSLog(@"continu to scroll %f",[y floatValue]);
        [self.mainScrollView setContentOffset:CGPointMake(0, [y floatValue])];
    }
    else
    {
        NSLog(@"Error, object not recognised.");
    }
}

-(void)mainContinueScrolling{
     NSLog(@"continu to scroll");
     [self.mainScrollView setContentOffset:CGPointMake(0, 95)];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
     NSLog(@"main %f", self.mainScrollView.contentOffset.y);
    if (self.mainScrollView.contentOffset.y<99 ) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"disableInteraction" object:nil];
        
    }
    else{
       
        [[NSNotificationCenter defaultCenter]postNotificationName:@"enableInteraction" object:nil];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (IBAction)dismissViewController:(id)sender {
    CATransition *transition = [CATransition new];
    transition.duration = 0.35;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromLeft;
    
    UIWindow *containerWindow = self.view.window;
    [containerWindow.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:false completion:nil];
}




@end
