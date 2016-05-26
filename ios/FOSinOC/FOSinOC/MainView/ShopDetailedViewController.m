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
#import "UINavigationBar+Awesome.h"

#import "Shop.h"
@interface ShopDetailedViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,DetailedChildFoodViewDelegate>

@property(nonatomic,strong) Shop *myShop;
//@property (weak, nonatomic) IBOutlet UILabel *topViewNameLabel;
//@property (weak, nonatomic) IBOutlet UIButton *topViewMenuButton;
//@property (weak, nonatomic) IBOutlet UIView *topViewSubView;
@property(strong,nonatomic) UILabel *naviShopName;
@property(strong,nonatomic) UIView *naviRightViewSmall;
@property(strong,nonatomic) UIBarButtonItem *rightBarItemSmall;
@property(strong,nonatomic) UIView *naviRightViewFull;
@property(strong,nonatomic) UIBarButtonItem *rightBarItemFull;
@property(strong,nonatomic) UIButton *naviMenuButton;
@property(strong,nonatomic) UIButton *naviShareButton;


@property (strong,nonatomic)UIScreenEdgePanGestureRecognizer *edgePanGesture;
@property CGPoint startLocation;
@property CGPoint currentLocation;
@property CGFloat swipeOffset;
@property CGPoint tempTranslatedPoint;
@property CGFloat tempTransPointY;
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

    NSLog(@"shop id %@",self.shopID);
    //[[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self initNavigationBar];
  
}

-(void)initNavigationBar{
    
    self.naviShopName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.naviShopName.text = @"shopName";
    self.naviShopName.textAlignment = NSTextAlignmentCenter;
    //self.naviShopName.backgroundColor = [UIColor redColor];
    
    self.navigationItem.titleView = self.naviShopName;
    self.naviRightViewSmall = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    //self.naviRightViewSmall.backgroundColor = [UIColor blueColor];
    
    self.naviMenuButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [self.naviMenuButton setTitle:@"..." forState:UIControlStateNormal];
    [self.naviMenuButton addTarget:self action:@selector(naviMenuButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.naviMenuButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.naviRightViewSmall addSubview:self.naviMenuButton];
    self.rightBarItemSmall = [[UIBarButtonItem alloc]initWithCustomView:self.naviRightViewSmall];
    //self.navigationItem.rightBarButtonItem = self.rightBarItemSmall;
    
    self.naviRightViewFull = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 160, 30)];
    //self.naviRightViewFull.backgroundColor = [UIColor blackColor];
    self.naviShareButton = [[UIButton alloc]initWithFrame:CGRectMake(120, 0, 40, 30)];
    [self.naviShareButton setTitle:@"share" forState:UIControlStateNormal];
    [self.naviShareButton addTarget:self action:@selector(naviShareButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.naviShareButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.naviRightViewFull addSubview:self.naviShareButton];
    self.rightBarItemFull = [[UIBarButtonItem alloc]initWithCustomView:self.naviRightViewFull];
    self.navigationItem.rightBarButtonItem = self.rightBarItemFull;
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
    
    self.navigationItem.backBarButtonItem = backBarButton;
    
    //[self.navigationController.navigationBar lt_setBackgroundColor:[UIColor blueColor]];
    self.naviShopName.alpha = 0;
    self.naviRightViewSmall.alpha = 0;
    self.naviRightViewFull.alpha = 1;
    //self.naviRightView.alpha = 0;
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
    

    
//slideMenu view ====================================
    self.foodView = [[DetailedChildFoodView alloc]init];
    self.shopView = [[DetailedChildShopView alloc]init];
    self.commentView = [[DetailedChildCommentView alloc]init];
    self.foodView.delegate = self;
    self.foodView.shopID = self.shopID;
    
    
    NSArray *title = @[@"Food", @"Comment", @"Shop"];
    NSArray *viewArray = @[self.foodView, self.commentView, self.shopView];
    self.slideMultiViewController = [[SlideMultiViewController alloc]init];
    self.slideMultiViewController.view.frame =CGRectMake(0, sdNavigationBarHeight + sdSegmentViewHeight, self.view.frame.size.width, self.view.frame.size.height);
    
    
    [self addChildViewController:self.slideMultiViewController];
    [self.slideMultiViewController initSlideMultiView:viewArray withTitle:title];
    [self.view addSubview:self.slideMultiViewController.view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(triggerNotificationAction:) name:@"mainContinueScrollingShop" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(triggerNotificationAction:) name:@"mainContinueScrollingComment" object:nil];
    self.isNotifyScrolling = false;
    
    self.scrollSlideViewGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(scrollSlideView:)];
    [self.view addGestureRecognizer:self.scrollSlideViewGesture];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + sdSegmentViewHeight);
    //NSLog(@"shop detail %f",self.slideMultiViewController.view.frame.size.height);
    //NSLog(@"shop detail %f",self.view.frame.size.height);
       // [self initNavigationBar];
    self.naviShopName.alpha = 0;
    self.naviRightViewSmall.alpha = 0;
    self.naviRightViewFull.alpha = 1;
    
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar lt_reset];
//}

-(void) triggerNotificationAction:(NSNotification *) notification
{
    if ([notification.object isKindOfClass:[NSArray class]]){
        NSArray *param = [notification object];
        NSNumber *y = [param objectAtIndex:0];
       // NSValue *velocityInValue = [param objectAtIndex:1];
       // CGPoint velocity = velocityInValue.CGPointValue;
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
        
        //NSLog(@"continu to scroll y: %f",self.slideMultiViewController.view.frame.origin.y);
        
    }
    else
    {
       //NSLog(@"Error, object not recognised.");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}



-(void)hideTopview:(CGFloat) alpha{
    //NSLog(@"orign alpha %f",alpha);
    alpha = (alpha - 64)/100;
    float adjustAlpha;
    if (alpha < 0) {
        alpha = 0;
    }
    if (alpha < 0.5) {
        self.navigationItem.rightBarButtonItem = self.rightBarItemSmall;
        self.navigationItem.titleView = self.naviShopName;
        self.naviShopName.frame = CGRectMake(0, 0, 200, 30);
        self.naviShopName.alpha =0;
        self.naviRightViewSmall.alpha = 0;
        
        adjustAlpha = (alpha)/0.5;
        self.naviShopName.alpha =1 - adjustAlpha;
        self.naviRightViewSmall.alpha = 1 - adjustAlpha;
        
    }
    if(alpha > 0.5){
        self.navigationItem.rightBarButtonItem = self.rightBarItemFull;
        self.navigationItem.titleView = nil;
        if (alpha>1) {
            adjustAlpha = 1;
        }
        else{
            adjustAlpha = (alpha - 0.5)/0.5;
        }
        self.naviRightViewFull.alpha = adjustAlpha;
    }
//    NSLog(@"right small %f",self.naviRightViewSmall.alpha);
//    NSLog(@"title %f",self.naviShopName.alpha);
//    NSLog(@"alpha %f",alpha);
}


-(void)hideSegmentView:(CGFloat) alpha{
    
    self.segmentView.alpha = (alpha - 64)/100;
    //self.topViewSubView.alpha = (alpha - 64)/100;
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
        self.tempTranslatedPoint = translatedPoint;
    }
    
// when the food view is on the top, scroll it to show segment view
    if (self.slideMultiViewController.view.frame.origin.y <sdNavigationBarHeight+sdSegmentViewHeight + 60  && self.slideMultiViewController.view.frame.origin.y>sdNavigationBarHeight ) {
        
        self.slideMultiViewController.view.frame = CGRectMake(0, self.slideMenuFrameY + translatedPoint.y, self.view.frame.size.width, self.view.frame.size.height - sdNavigationBarHeight-sdSegmentViewHeight);
        if(velocity.y>0){
            self.tempTransPointY = self.tempTranslatedPoint.y - translatedPoint.y;
        }
    }
    
    if(self.slideMultiViewController.view.frame.origin.y <= sdNavigationBarHeight)
    {
        
        self.slideMultiViewController.view.frame = CGRectMake(0, sdNavigationBarHeight, self.view.frame.size.width, self.view.frame.size.height - sdNavigationBarHeight-sdSegmentViewHeight);
        //NSNumber *y = [NSNumber numberWithFloat:translatedPoint.y + self.tempTransPointY];
        NSNumber *y = [NSNumber numberWithFloat:translatedPoint.y];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"enableInteractionFood" object:y];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"enableInteractionComment" object:y];
        
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
    //NSLog(@"translatedPoint y:%f",translatedPoint.y);
    //NSLog(@"speed y:%f",velocity.y);
//    NSLog(@"slide y: %f",self.slideMultiViewController.view.frame.origin.y);
}

-(void)naviMenuButtonClicked{
    NSLog(@"naviMenuButtonClicked");
}

-(void)naviShareButtonClicked{
    NSLog(@"naviShareButtonClicked");
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return true;
}

-(void)DetailedChildFoodDidSelectFood:(NSString *)foodId{
    NSLog(@"%@",foodId);
    [self performSegueWithIdentifier:@"foodDetailSegue" sender:nil];
}

@end
