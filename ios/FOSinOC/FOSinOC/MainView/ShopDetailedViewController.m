//
//  ShopDetailedViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/26.
//  Copyright © 2016年 李龑. All rights reserved.
//
#define sdNavigationBarHeight 64
#define sdSegmentViewHeight 100

#import "ShopDetailedViewController.h"
#import "SlideMultiViewController.h"
#import "DetailedChildFoodView.h"
#import "DetailedChildShopView.h"
#import "DetailedChildCommentView.h"
@interface ShopDetailedViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property(strong,nonatomic) UIScrollView *mainScrollView;
@property(strong,nonatomic) SlideMultiViewController *slideMultiViewController;
@property(strong,nonatomic)  DetailedChildFoodView *foodView;
@property(strong,nonatomic)  DetailedChildShopView *shopView;
@property(strong,nonatomic)  DetailedChildCommentView *commentView;
@property(strong,nonatomic) UIPanGestureRecognizer *scrollSlideViewGesture;
@property(assign,nonatomic) CGFloat slideMenuFrameY;
@property(assign,nonatomic) CGPoint lastVeclocity;

@property(assign,nonatomic) BOOL isContinueScrolling;
@property(assign,nonatomic) BOOL isNotifyScrolling;
@property(assign,nonatomic) BOOL isChangeScrollDirection;
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
    self.slideMultiViewController = [[SlideMultiViewController alloc]init];
    self.slideMultiViewController.view.frame =CGRectMake(0, sdNavigationBarHeight + sdSegmentViewHeight, self.view.frame.size.width, self.view.frame.size.height);
    
    //slideMultiViewController.view.frame =CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 64);
    [self addChildViewController:self.slideMultiViewController];
    [self.slideMultiViewController initSlideMultiView:viewArray withTitle:title];
  
    
//    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
//    self.mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+100);
//    self.mainScrollView.pagingEnabled = false;
//    self.mainScrollView.delegate = self;
//    [self.mainScrollView addSubview:slideMultiViewController.view];
//    [self.view addSubview:self.mainScrollView];
    [self.view addSubview:self.slideMultiViewController.view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(triggerNotificationAction:) name:@"mainContinueScrolling" object:nil];
    self.isNotifyScrolling = false;
    
    self.scrollSlideViewGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(scrollSlideView:)];
    [self.view addGestureRecognizer:self.scrollSlideViewGesture];
}

-(void) triggerNotificationAction:(NSNotification *) notification
{
    if ([notification.object isKindOfClass:[NSNumber class]])
    {
        NSNumber *y = [notification object];
        NSLog(@"notification main %f",[y floatValue]);
        self.slideMenuFrameY = self.slideMultiViewController.view.frame.origin.y;
        self.slideMultiViewController.view.frame = CGRectMake(0, 65 - [y floatValue], self.view.frame.size.width, self.view.frame.size.height - sdNavigationBarHeight-sdSegmentViewHeight);
           NSLog(@"continu to scroll y: %f",self.slideMultiViewController.view.frame.origin.y);
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



-(void)scrollSlideView:(UIPanGestureRecognizer *) panGesture{
    
    CGPoint velocity = [panGesture velocityInView:self.view];
    CGPoint translatedPoint = [panGesture translationInView:self.view];
    
    
    if(velocity.y*self.lastVeclocity.y > 0)
    {
       
        self.isChangeScrollDirection = false;
    }
    else
    {
       
        self.isChangeScrollDirection = true;
    }
    
    self.lastVeclocity = velocity;
    

    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        self.slideMenuFrameY = self.slideMultiViewController.view.frame.origin.y;
    }
    

    if (self.slideMultiViewController.view.frame.origin.y <sdNavigationBarHeight+sdSegmentViewHeight +60 && self.slideMultiViewController.view.frame.origin.y>sdNavigationBarHeight ) {
        NSLog(@"move frame");
            self.slideMultiViewController.view.frame = CGRectMake(0, self.slideMenuFrameY + translatedPoint.y, self.view.frame.size.width, self.view.frame.size.height - sdNavigationBarHeight-sdSegmentViewHeight);
//        if(self.slideMultiViewController.view.frame.origin.y <= sdNavigationBarHeight && self.isChangeScrollDirection) {
//            NSLog(@"direction change");
//            self.slideMultiViewController.view.frame = CGRectMake(0, sdNavigationBarHeight, self.view.frame.size.width, self.view.frame.size.height - sdNavigationBarHeight-sdSegmentViewHeight);
//        }
    }

    if(self.slideMultiViewController.view.frame.origin.y <= sdNavigationBarHeight)
    {
        
        self.slideMultiViewController.view.frame = CGRectMake(0, sdNavigationBarHeight, self.view.frame.size.width, self.view.frame.size.height - sdNavigationBarHeight-sdSegmentViewHeight);
        NSNumber *y = [NSNumber numberWithFloat:translatedPoint.y];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"enableInteraction" object:y];
//        if(self.slideMultiViewController.view.frame.origin.y <= sdNavigationBarHeight && self.isChangeScrollDirection) {
//            NSLog(@"direction change");
//            self.slideMultiViewController.view.frame = CGRectMake(0, sdNavigationBarHeight, self.view.frame.size.width, self.view.frame.size.height - sdNavigationBarHeight-sdSegmentViewHeight);
//        }
        
        
    }
    
    //move from top to bottom
    
//    if (self.slideMultiViewController.view.frame.origin.y <sdNavigationBarHeight+sdSegmentViewHeight && self.slideMultiViewController.view.frame.origin.y>=sdNavigationBarHeight && velocity.y>0) {
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"disableInteraction" object:nil];
//        self.slideMultiViewController.view.frame = CGRectMake(0, self.slideMenuFrameY + translatedPoint.y, self.view.frame.size.width, self.view.frame.size.height - sdNavigationBarHeight-sdSegmentViewHeight);
//    }

    
    if (panGesture.state == UIGestureRecognizerStateEnded) {

        if(self.slideMultiViewController.view.frame.origin.y > sdNavigationBarHeight+sdSegmentViewHeight)
        {
            [UIView animateWithDuration:0.25 animations:^{
                self.slideMultiViewController.view.frame = CGRectMake(0, sdNavigationBarHeight+sdSegmentViewHeight, self.view.frame.size.width, self.view.frame.size.height - sdNavigationBarHeight-sdSegmentViewHeight);
            }];
        }
        if(self.slideMultiViewController.view.frame.origin.y < sdNavigationBarHeight+sdSegmentViewHeight && self.slideMultiViewController.view.frame.origin.y > sdNavigationBarHeight+20 && velocity.y>0)
        {
            [UIView animateWithDuration:0.25 animations:^{
                self.slideMultiViewController.view.frame = CGRectMake(0, sdNavigationBarHeight+sdSegmentViewHeight, self.view.frame.size.width, self.view.frame.size.height - sdNavigationBarHeight-sdSegmentViewHeight);
            }];
        }
    }
    
    NSLog(@"translatedPoint y:%f",translatedPoint.y);
    NSLog(@"speed y:%f",velocity.y);
    NSLog(@"slide y: %f",self.slideMultiViewController.view.frame.origin.y);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
     NSLog(@"main %f", self.mainScrollView.contentOffset.y);
    if (self.mainScrollView.contentOffset.y<99 && !self.isNotifyScrolling) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"disableInteraction" object:nil];
        self.isNotifyScrolling = true;
    }
    else if(self.mainScrollView.contentOffset.y>=100){
       
        [[NSNotificationCenter defaultCenter]postNotificationName:@"enableInteraction" object:nil];
        self.isNotifyScrolling = false;
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
