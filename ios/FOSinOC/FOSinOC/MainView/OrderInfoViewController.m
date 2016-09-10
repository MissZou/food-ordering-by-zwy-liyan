//
//  OrderInfoViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/9/8.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "OrderInfoViewController.h"
#import "SlideMultiViewController.h"
#import "OrderDetailViewController.h"
#import "DeliveryInfoViewController.h"


static const CGFloat sdNavigationBarHeight = 64;

@interface OrderInfoViewController ()

@property (strong, nonatomic) SlideMultiViewController *slideMultiViewController;
@property (strong, nonatomic) OrderDetailViewController *orderDetailVC;
@property (strong, nonatomic) DeliveryInfoViewController *deliveryInfoVC;

@end

@implementation OrderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSLog([self.shopName description]);
//    NSLog([self.address description]);
//    NSLog([self.itemList description]);
    
    [self initViewController];
    [self initNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self initViewController];
}

- (void)initNavigationBar {
    UILabel *naviTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    naviTitle.text = self.shopName;
    naviTitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    naviTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = naviTitle;
}

- (void)initViewController {
    UIView *segmentView = [[UIView alloc]initWithFrame:CGRectMake(0, sdNavigationBarHeight, self.view.frame.size.width, 10)];
    [self.view addSubview:segmentView];
    //if I do not add segment view, then the slideMultiView will predefinded y -64 content offset, I ???
    
    NSArray *title = @[@"Delivery", @"Detail"];
    self.orderDetailVC = [[OrderDetailViewController alloc]init];
    //self.orderDetailVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - slideTitleHeight - sdNavigationBarHeight);
    self.deliveryInfoVC = [[DeliveryInfoViewController alloc]init];
    //self.deliveryInfoVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - slideTitleHeight - sdNavigationBarHeight);
    NSArray *vcArray = @[self.deliveryInfoVC, self.orderDetailVC];
    self.slideMultiViewController = [[SlideMultiViewController alloc]init];
    self.slideMultiViewController.view.frame = CGRectMake(0, sdNavigationBarHeight, self.view.frame.size.width, self.view.frame.size.height - sdNavigationBarHeight);
    [self addChildViewController:self.slideMultiViewController];
    [self.slideMultiViewController initSlideMultiView:vcArray withTitle:title];
    [self.view addSubview:self.slideMultiViewController.view];
    self.slideMultiViewController.isVerticalEnable = false;
    //[self.slideMultiViewController.contentScrollView setContentOffset:CGPointMake(0, 0)];
}

@end
