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

#import "Shop.h"
@interface ShopDetailedViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong) Shop *myShop;
@property (weak, nonatomic) IBOutlet UILabel *topViewNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *topViewMenuButton;
@property (weak, nonatomic) IBOutlet UIView *topViewSubView;


//slideMenu view ====================================
@property(strong,nonatomic) UIScrollView *mainScrollView;
@property(strong,nonatomic) SlideMultiViewController *slideMultiViewController;
@property(strong,nonatomic)  DetailedChildFoodView *foodView;
@property(strong,nonatomic)  DetailedChildShopView *shopView;
@property(strong,nonatomic)  DetailedChildCommentView *commentView;
@property(strong,nonatomic) UIPanGestureRecognizer *scrollSlideViewGesture;
@property(assign,nonatomic) CGFloat slideMenuFrameY;
@property(assign,nonatomic) CGPoint lastVeclocity;

//segment view ====================================
@property(strong,nonatomic) UIView *segmentView;
//@property(strong,nonatomic) UIImageView *shopImageView;


@property(assign,nonatomic) BOOL isContinueScrolling;
@property(assign,nonatomic) BOOL isNotifyScrolling;
@property(assign,nonatomic) BOOL isChangeScrollDirection;
@end

@implementation ShopDetailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + sdSegmentViewHeight);
    [self initDetailedChildFoodView];
}

-(void)initDetailedChildFoodView{
//segment view ====================================
    self.segmentView = [[UIView alloc]initWithFrame:CGRectMake(0, sdNavigationBarHeight, self.view.frame.size.width, sdSegmentViewHeight)];
    //self.segmentView.backgroundColor = [UIColor orangeColor];
    
    UIImageView *shopImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 90, 90)];
    shopImageView.image = [UIImage imageNamed:@"favoriteGreen.png"];
    UILabel *shopName = [[UILabel alloc]initWithFrame:CGRectMake(shopImageView.frame.size.width+shopImageView.frame.origin.x + 10, 5, self.view.frame.size.width - 150, 30)];
    shopName.text = @"ShopName";
    
    [self.segmentView addSubview:shopImageView];
    [self.segmentView addSubview:shopName];
    [self.view addSubview:self.segmentView];
    
    self.topViewMenuButton.alpha = 0;
    self.topViewNameLabel.alpha = 0;
    
//slideMenu view ====================================
    self.foodView = [[DetailedChildFoodView alloc]init];
    self.shopView = [[DetailedChildShopView alloc]init];
    self.commentView = [[DetailedChildCommentView alloc]init];
    self.foodView.shopID = self.shopID;
    
    
    NSArray *title = @[@"Food", @"Comment", @"Shop"];
    NSArray *viewArray = @[self.foodView, self.commentView, self.shopView];
    self.slideMultiViewController = [[SlideMultiViewController alloc]init];
    self.slideMultiViewController.view.frame =CGRectMake(0, sdNavigationBarHeight + sdSegmentViewHeight, self.view.frame.size.width, self.view.frame.size.height);
    
    
    [self addChildViewController:self.slideMultiViewController];
    [self.slideMultiViewController initSlideMultiView:viewArray withTitle:title];
    [self.view addSubview:self.slideMultiViewController.view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(triggerNotificationAction:) name:@"mainContinueScrollingFood" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(triggerNotificationAction:) name:@"mainContinueScrollingComment" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(triggerNotificationAction:) name:@"mainContinueScrollingShop" object:nil];
    self.isNotifyScrolling = false;
    
    self.scrollSlideViewGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(scrollSlideView:)];
    [self.view addGestureRecognizer:self.scrollSlideViewGesture];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + sdSegmentViewHeight);
    NSLog(@"shop detail %f",self.slideMultiViewController.view.frame.size.height);
    NSLog(@"shop detail %f",self.view.frame.size.height);
    
}

-(void) triggerNotificationAction:(NSNotification *) notification
{
    if ([notification.object isKindOfClass:[NSNumber class]])
    {
        NSNumber *y = [notification object];
        NSLog(@"notification main %f",[y floatValue]);
        self.slideMenuFrameY = self.slideMultiViewController.view.frame.origin.y;
        self.slideMultiViewController.view.frame = CGRectMake(0, 65 - [y floatValue], self.view.frame.size.width, self.view.frame.size.height - sdNavigationBarHeight-sdSegmentViewHeight);
        [self hideSegmentView:self.slideMultiViewController.view.frame.origin.y];
        [self hideTopview:self.slideMultiViewController.view.frame.origin.y];
        
        if(self.slideMultiViewController.view.frame.origin.y > sdNavigationBarHeight+sdSegmentViewHeight)
        {
            [UIView animateWithDuration:0.25 animations:^{
                self.slideMultiViewController.view.frame = CGRectMake(0, sdNavigationBarHeight+sdSegmentViewHeight, self.view.frame.size.width, self.view.frame.size.height - sdNavigationBarHeight-sdSegmentViewHeight);
                [self hideSegmentView:sdNavigationBarHeight+sdSegmentViewHeight];
            }];
            
        }
        
        NSLog(@"continu to scroll y: %f",self.slideMultiViewController.view.frame.origin.y);
        
    }
    else
    {
        NSLog(@"Error, object not recognised.");
    }
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

- (IBAction)topViewMenuButtonClicked:(id)sender {
}
- (IBAction)topViewSubViewShareButtonClicked:(id)sender {
}

-(void)hideTopview:(CGFloat) alpha{
    alpha = (alpha - 134)/30;
    if (alpha < 0) {
        alpha = 0;
    }
    self.topViewNameLabel.alpha =1 - alpha;
    self.topViewMenuButton.alpha =1 - alpha;
}


-(void)hideSegmentView:(CGFloat) alpha{
    
    self.segmentView.alpha = (alpha - 64)/100;
    self.topViewSubView.alpha = (alpha - 64)/100;
    if (alpha <= 164.0) {
        self.segmentView.frame = CGRectMake(0, alpha-100, self.segmentView.frame.size.width, self.segmentView.frame.size.width);
    }
    
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
    }
    
    if(self.slideMultiViewController.view.frame.origin.y <= sdNavigationBarHeight)
    {
        
        self.slideMultiViewController.view.frame = CGRectMake(0, sdNavigationBarHeight, self.view.frame.size.width, self.view.frame.size.height - sdNavigationBarHeight-sdSegmentViewHeight);
        NSNumber *y = [NSNumber numberWithFloat:translatedPoint.y];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"enableInteractionFood" object:y];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"enableInteractionComment" object:y];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"enableInteractionShop" object:y];
        
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
                [self hideSegmentView:sdNavigationBarHeight+sdSegmentViewHeight];
            }];
            
        }
        
        
    }
    
    [self hideSegmentView:self.slideMultiViewController.view.frame.origin.y];
    [self hideTopview:self.slideMultiViewController.view.frame.origin.y];
    NSLog(@"translatedPoint y:%f",translatedPoint.y);
    NSLog(@"speed y:%f",velocity.y);
    NSLog(@"slide y: %f",self.slideMultiViewController.view.frame.origin.y);
}



@end
