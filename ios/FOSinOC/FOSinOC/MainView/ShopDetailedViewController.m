//
//  ShopDetailedViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/26.
//  Copyright © 2016年 李龑. All rights reserved.
//
#define sdNavigationBarHeight 64
#define sdSegmentViewHeight 100
#define slideTitleHeight 40
#define cartViewHeight 50

#import "ShopDetailedViewController.h"
#import "SlideMultiViewController.h"
#import "DetailedChildFoodView.h"
#import "DetailedChildShopView.h"
#import "DetailedChildCommentView.h"
#import "UINavigationBar+Awesome.h"

#import "Shop.h"
@interface ShopDetailedViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,SlideMultiViewControllerDelegate,DetailedChildFoodViewDelegate,ShopDelegate>

@property(nonatomic,strong) Shop *myShop;

@property(strong,nonatomic) UILabel *naviShopName;
@property(strong,nonatomic) UIView *naviRightViewSmall;
@property(strong,nonatomic) UIBarButtonItem *rightBarItemSmall;
@property(strong,nonatomic) UIView *naviRightViewFull;
@property(strong,nonatomic) UIBarButtonItem *rightBarItemFull;
@property(strong,nonatomic) UIButton *naviMenuButton;
@property(strong,nonatomic) UIButton *naviShareButton;

//gesture varibles
@property CGPoint startLocation;
@property CGPoint currentLocation;
@property CGFloat swipeOffset;
@property CGPoint tempTranslatedPoint;
@property CGFloat tempTransPointY;
@property CGFloat superViewHeight;
@property BOOL gestureStateBegin;
@property (strong,nonatomic)NSString *currentTitle;
//slideMenu view ====================================

@property(strong,nonatomic) SlideMultiViewController *slideMultiViewController;
@property(strong,nonatomic)  DetailedChildFoodView *foodView;
@property(strong,nonatomic)  DetailedChildShopView *shopView;
@property(strong,nonatomic)  DetailedChildCommentView *commentView;
@property(strong,nonatomic) UIPanGestureRecognizer *scrollSlideViewGesture;
@property(assign,nonatomic) CGFloat slideMenuFrameY;
@property(assign,nonatomic) CGFloat slideMenuFrameInitY;
@property(assign,nonatomic) CGPoint lastVeclocity;

//segment view ====================================
@property(strong,nonatomic) UIView *segmentView;
//@property(strong,nonatomic) UIImageView *shopImageView;


@property(assign,nonatomic) BOOL isContinueScrolling;
@property(assign,nonatomic) BOOL isNotifyScrolling;
@property(assign,nonatomic) BOOL isChangeScrollDirection;
@property(assign,nonatomic) BOOL isChildViewGustureStateBegin;
@property(assign,nonatomic) BOOL isTranslatedPointCleared;

//cartview
@property(assign,nonatomic) CGFloat cartViewInitFrameY;

//activity indicator
@property (strong,nonatomic)UIBlurEffect *blurEffet;
@property (strong,nonatomic)UIVisualEffectView *blurEffectView;
@property (strong) UIActivityIndicatorView *mySpinner;

@end

@implementation ShopDetailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.superViewHeight = self.view.frame.size.height;
    [self initDetailedChildFoodView];
    
    NSLog(@"shop id %@",self.shopID);
    
    [self initNavigationBar];
    self.currentTitle = @"Food";
    self.cartViewInitFrameY = self.foodView.cartView.frame.origin.y;
    
    //add blur view to prevent user interaction when load data from internet
    self.blurEffet = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:self.blurEffet];

    [self initActivityIndicator];
    [self.mySpinner startAnimating];
//    //NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval: 0.5
//                                                      target: self
//                                                    selector: @selector(loadFinished)
//                                                    userInfo: nil
//                                                     repeats: YES];
    self.myShop = [Shop sharedManager];
    self.myShop.delegate = self;
    [self.myShop fetchShopData:self.shopID];
}

-(void)initNavigationBar{
    
    self.naviShopName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.naviShopName.text = @"shopName";
    self.naviShopName.textAlignment = NSTextAlignmentCenter;
    
    
    self.navigationItem.titleView = self.naviShopName;
    //self.naviRightViewSmall = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    //self.naviRightViewSmall.backgroundColor = [UIColor blueColor];
    
    self.naviMenuButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [self.naviMenuButton setTitle:@"..." forState:UIControlStateNormal];
    [self.naviMenuButton addTarget:self action:@selector(naviMenuButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.naviMenuButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //[self.naviRightViewSmall addSubview:self.naviMenuButton];
    //self.rightBarItemSmall = [[UIBarButtonItem alloc]initWithCustomView:self.naviRightViewSmall];
    //self.navigationItem.rightBarButtonItem = self.rightBarItemSmall;
    
    self.naviRightViewFull = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    //self.naviRightViewFull.backgroundColor = [UIColor blackColor];
    self.naviShareButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [self.naviShareButton setTitle:@"share" forState:UIControlStateNormal];
    [self.naviShareButton addTarget:self action:@selector(naviShareButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.naviShareButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [self.naviRightViewFull addSubview:self.naviShareButton];
    [self.naviRightViewFull addSubview:self.naviMenuButton];
    
    self.rightBarItemFull = [[UIBarButtonItem alloc]initWithCustomView:self.naviRightViewFull];
    self.navigationItem.rightBarButtonItem = self.rightBarItemFull;
//    self.navigationItem.rightBarButtonItem = self.rightBarItemSmall;
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
    
    self.navigationItem.backBarButtonItem = backBarButton;
    
    [self.naviMenuButton setHidden:true];
    [self.naviShopName setHidden:true];
}

-(void)initDetailedChildFoodView{
//segment view ====================================
    self.segmentView = [[UIView alloc]initWithFrame:CGRectMake(0, sdNavigationBarHeight, self.view.frame.size.width, sdSegmentViewHeight)];
    //self.segmentView.backgroundColor = [UIColor orangeColor];
    
//    UIImageView *shopImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 90, 90)];
//    shopImageView.image = [UIImage imageNamed:@"favoriteGreen.png"];
//    UILabel *shopName = [[UILabel alloc]initWithFrame:CGRectMake(shopImageView.frame.size.width+shopImageView.frame.origin.x + 10, 5, self.view.frame.size.width - 150, 30)];
//    shopName.text = @"ShopName";
//    
//    [self.segmentView addSubview:shopImageView];
//    [self.segmentView addSubview:shopName];
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
    self.slideMultiViewController.delegate = self;
    
    [self addChildViewController:self.slideMultiViewController];
    [self.slideMultiViewController initSlideMultiView:viewArray withTitle:title];
    [self.view addSubview:self.slideMultiViewController.view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(triggerNotificationAction:) name:@"mainContinueScrollingShop" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(triggerNotificationAction:) name:@"mainContinueScrollingComment" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(childViewGustureStateBegin:) name:@"childViewGustureStateBegin" object:nil];
    self.isNotifyScrolling = false;
    
    self.scrollSlideViewGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(scrollSlideView:)];
    [self.view addGestureRecognizer:self.scrollSlideViewGesture];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    }

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + sdSegmentViewHeight);

    self.slideMenuFrameInitY = self.slideMultiViewController.view.frame.origin.y;
    self.isTranslatedPointCleared = false;

}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

-(void)initActivityIndicator{
    UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    self.blurEffectView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.blurEffectView];
    self.mySpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.mySpinner];

    self.mySpinner.center = self.view.center;
}

-(void)loadFinished{
    [self.blurEffectView removeFromSuperview];
    [self.mySpinner stopAnimating];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
}

-(void) triggerNotificationAction:(NSNotification *) notification
{
    
    if ([notification.object isKindOfClass:[NSArray class]]){
        NSArray *param = [notification object];
        NSNumber *y = [param objectAtIndex:0];
        NSLog(@"mainContinueScrollingShop %f",[y floatValue]);
       // NSValue *velocityInValue = [param objectAtIndex:1];
       // CGPoint velocity = velocityInValue.CGPointValue;
        self.slideMenuFrameY = self.slideMultiViewController.view.frame.origin.y;
        self.slideMultiViewController.view.frame = CGRectMake(0, 65 - [y floatValue], self.view.frame.size.width, self.view.frame.size.height - sdNavigationBarHeight-sdSegmentViewHeight);
        [self hideSegmentView:self.slideMultiViewController.view.frame.origin.y];
        [self hideTopview:self.slideMultiViewController.view.frame.origin.y];
        //[self adjustCartViewFrameY:-self.slideMultiViewController.view.frame.origin.y + self.slideMenuFrameInitY];
        if(self.slideMultiViewController.view.frame.origin.y > sdNavigationBarHeight+sdSegmentViewHeight && self.isChildViewGustureStateBegin == false)
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

-(void)childViewGustureStateBegin:(NSNotification *)notification{
    if ([notification.object isKindOfClass:[NSNumber class]]){
        NSNumber *boolValue = [notification object];
        self.isChildViewGustureStateBegin = [boolValue boolValue];
    }
    
    if(self.slideMultiViewController.view.frame.origin.y > sdNavigationBarHeight+sdSegmentViewHeight && self.isChildViewGustureStateBegin == false)
    {
        if (self.slideMultiViewController.view.frame.origin.y<self.slideMenuFrameInitY) {
            [self adjustCartViewFrameY:-self.slideMultiViewController.view.frame.origin.y + self.slideMenuFrameInitY];
        }else{
            CGRect cartFrame = self.foodView.cartView.frame;
            self.foodView.cartView.frame = CGRectMake(cartFrame.origin.x, self.cartViewInitFrameY, cartFrame.size.width, cartFrame.size.height);
        }
        [UIView animateWithDuration:0.25 animations:^{
            self.slideMultiViewController.view.frame = CGRectMake(0, sdNavigationBarHeight+sdSegmentViewHeight, self.view.frame.size.width, self.view.frame.size.height - sdNavigationBarHeight-sdSegmentViewHeight);
            [self hideSegmentView:sdNavigationBarHeight+sdSegmentViewHeight];

        }];
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)hideTopview:(CGFloat) alpha{
    alpha = (alpha - 64)/sdSegmentViewHeight;
    float adjustAlpha;
    
    if (alpha < 0.5) {
        [self.naviMenuButton setHidden:false];
        [self.naviShopName setHidden:false];
        [self.naviShareButton setHidden:true];
        
        adjustAlpha = (alpha)/0.5;
        self.naviShopName.alpha =1 - adjustAlpha;
        self.naviMenuButton.alpha = 1-adjustAlpha;
        
        
    }
    if(alpha > 0.5){
        [self.naviMenuButton setHidden:true];
        [self.naviShopName setHidden:true];
        [self.naviShareButton setHidden:false];
        if (alpha>1) {
            adjustAlpha = 1;
        }
        else{
            adjustAlpha = (alpha - 0.5)/0.5;
        }
        self.naviShareButton.alpha = adjustAlpha;
    }
//    
//    NSLog(@"shopname alpha %f",self.naviShopName.alpha);
//    NSLog(@"righ view alpha %f",self.naviRightViewFull.alpha);
}


-(void)hideSegmentView:(CGFloat) alpha{

    self.segmentView.alpha = (alpha - 64)/sdSegmentViewHeight;
    //self.topViewSubView.alpha = (alpha - 64)/100;
    if (alpha <= 164.0) {
        self.segmentView.frame = CGRectMake(0, alpha-sdSegmentViewHeight, self.segmentView.frame.size.width, self.segmentView.frame.size.width);
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
        //self.tempTranslatedPoint = translatedPoint;
    }
    
    self.lastVeclocity = velocity;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"slideViewFrameY" object:[NSNumber numberWithFloat:self.slideMultiViewController.view.frame.origin.y]];
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        self.slideMenuFrameY = self.slideMultiViewController.view.frame.origin.y;
        self.tempTranslatedPoint = translatedPoint;
        self.gestureStateBegin = true;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"superViewGustureState" object:[NSNumber numberWithBool:true]];
    }
    
// when the food view is on the top, scroll it to show segment view

        // 60 is pretent to pan scroll bounce
        if (self.slideMultiViewController.view.frame.origin.y <sdNavigationBarHeight+sdSegmentViewHeight + 60  && self.slideMultiViewController.view.frame.origin.y>sdNavigationBarHeight ) {
            
            self.slideMultiViewController.view.frame = CGRectMake(0, self.slideMenuFrameY + translatedPoint.y, self.view.frame.size.width, self.view.frame.size.height - sdNavigationBarHeight-sdSegmentViewHeight);

        }
    
    if(self.slideMultiViewController.view.frame.origin.y <= sdNavigationBarHeight)
    {
        
        self.slideMultiViewController.view.frame = CGRectMake(0, sdNavigationBarHeight, self.view.frame.size.width, self.view.frame.size.height - sdNavigationBarHeight-sdSegmentViewHeight);
        if (self.gestureStateBegin) {
            self.tempTranslatedPoint = translatedPoint;
        }
        // when sroll segment view up out of screen
        if (velocity.y<0) {
            NSNumber *y;
            if (self.gestureStateBegin) {
                [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
                translatedPoint = [panGesture translationInView:self.view];
            }
            y = [NSNumber numberWithFloat:translatedPoint.y];
            
            if ([self.currentTitle  isEqualToString: @"Food"]) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"enableInteractionFood" object:y];
            }
            
        }else{
            NSNumber *y;
            y = [NSNumber numberWithFloat:translatedPoint.y];
            if ([self.currentTitle  isEqualToString: @"Food"]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"enableInteractionFood" object:y];
            }
            NSLog(@"velocity>0 y %f",[y floatValue]);
        }

        self.gestureStateBegin = false;
    }

    if (panGesture.state == UIGestureRecognizerStateEnded) {
        
        self.gestureStateBegin = false;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"superViewGustureState" object:[NSNumber numberWithBool:false]];

        
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
                [self adjustCartViewFrameY:-self.slideMultiViewController.view.frame.origin.y + self.slideMenuFrameInitY];
            }];
            
        }
        
        
    }
    
    [self hideSegmentView:self.slideMultiViewController.view.frame.origin.y];
    [self hideTopview:self.slideMultiViewController.view.frame.origin.y];
    if (self.slideMultiViewController.view.frame.origin.y<self.slideMenuFrameInitY) {
            [self adjustCartViewFrameY:-self.slideMultiViewController.view.frame.origin.y + self.slideMenuFrameInitY];
    }else{
        CGRect cartFrame = self.foodView.cartView.frame;
        self.foodView.cartView.frame = CGRectMake(cartFrame.origin.x, self.cartViewInitFrameY, cartFrame.size.width, cartFrame.size.height);
    }

    

//    CGRect frame = self.view.frame;
//    frame.size.height = self.superViewHeight;
//    self.view.frame = frame;
    NSLog(@"translatedPoint y:%f",translatedPoint.y);
    NSLog(@"speed y:%f",velocity.y);
//    NSLog(@"slide y: %f",self.slideMultiViewController.view.frame.origin.y);
//    NSLog(@"slide init y: %f",self.slideMenuFrameInitY);
//    NSLog(@"food view origin y: %f",self.foodView.view.frame.origin.y);
//    NSLog(@"food view size height: %f",self.foodView.view.frame.size.height);
//    NSLog(@"super view superViewHeight %f",self.superViewHeight);
//    NSLog(@"view frame height %f",self.view.frame.size.height);
    //NSLog(@"translatedPoint temp y:%f",self.tempTranslatedPoint.y);
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

-(void)adjustCartViewFrameY:(CGFloat)adjustValue{
    CGRect cartFrame = self.foodView.cartView.frame;
    CGFloat y = self.cartViewInitFrameY+adjustValue;
    self.foodView.cartView.frame = CGRectMake(cartFrame.origin.x, y, cartFrame.size.width, cartFrame.size.height);
}

-(void)updateUIandLoadShopData{
    UIImageView *shopImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 90, 90)];
    shopImageView.clipsToBounds = true;
    shopImageView.contentMode = UIViewContentModeScaleAspectFill;
    
        dispatch_async(dispatch_get_main_queue(), ^{
        shopImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.myShop.shopPicUrl]]];
    
        });
    UILabel *shopName = [[UILabel alloc]initWithFrame:CGRectMake(shopImageView.frame.size.width+shopImageView.frame.origin.x + 10, 5, self.view.frame.size.width - 150, 30)];
    shopName.text = self.myShop.shopName;
    
    [self.segmentView addSubview:shopImageView];
    [self.segmentView addSubview:shopName];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"superViewGustureState" object:[NSNumber numberWithBool:false]];

}

#pragma mark -- shopDelegate
-(void)shopFinishFetchData{
    
    [self updateUIandLoadShopData];
    NSLog(@"shop delegate in shop detailed");

    [[NSNotificationCenter defaultCenter]postNotificationName:@"shopFinishFetchData" object:[NSNumber numberWithBool:false]];

    [self loadFinished];
}




#pragma mark -- SlideMultiViewDelegate
// after scroll the slide view, do something.
-(void) slideButtionClicked:(NSString *)title{
    self.currentTitle = title;
    self.tempTranslatedPoint = CGPointMake(0, 0);
    if ([self.currentTitle isEqualToString:@"Comment"]) {
        // fetch comment
    }
    
}
@end
