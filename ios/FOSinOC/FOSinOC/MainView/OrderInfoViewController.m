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
#define myBlueColor [UIColor colorWithRed:69/255.0 green:83/255.0 blue:153/255.0 alpha:1]


static const CGFloat sdNavigationBarHeight = 64;

@interface OrderInfoViewController ()

@property (strong, nonatomic) SlideMultiViewController *slideMultiViewController;
@property (strong, nonatomic) OrderDetailViewController *orderDetailVC;
@property (strong, nonatomic) DeliveryInfoViewController *deliveryInfoVC;
@property (weak, nonatomic) IBOutlet UILabel *topViewTitle;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation OrderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSLog([self.shopName description]);
//    NSLog([self.address description]);
//    NSLog([self.itemList description]);
    NSLog(@"order data %@",self.order);
    [self initViewController];
    [self initNavigationBar];
    if ([self.orderStatus isEqualToString:@"created"]) {
    
    }
    else {
        self.topViewTitle.text = [[self.order valueForKey:@"shop"] valueForKey:@"shopName"];
        self.topView.layer.shadowOpacity = 0.5;
        self.topView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255 blue:248.0/255.0 alpha:1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleDone target:self action:@selector(onLibraryButtonClicked:)]];
    self.navigationItem.leftBarButtonItem.tintColor = myBlueColor;
    NSDictionary *attributeDict = @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]};
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:attributeDict forState:UIControlStateNormal];
}

-(void)onLibraryButtonClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)menuButtonHandle:(id)sender {
    CATransition *transition = [CATransition new];
    transition.duration = 0.35;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromLeft;
    
    UIWindow *containerWindow = self.view.window;
    [containerWindow.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:false completion:nil];
}

- (void)initNavigationBar {
    UILabel *naviTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    if (self.shopName) {
        naviTitle.text = self.shopName;
    } else {
        naviTitle.text = [[self.order valueForKey:@"shop"] valueForKey:@"shopName"];
    }
    naviTitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    naviTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = naviTitle;
    
}

- (void)initViewController {
    UIView *segmentView = [[UIView alloc]initWithFrame:CGRectMake(0, sdNavigationBarHeight, self.view.frame.size.width, 10)];
    [self.view addSubview:segmentView];
    //if I do not add segment view, then the slideMultiView will predefinded y -64 content offset, I ???
    
    self.orderDetailVC = [[OrderDetailViewController alloc]init];
    self.deliveryInfoVC = [[DeliveryInfoViewController alloc]init];
    self.deliveryInfoVC.orderStatus = self.orderStatus;
    self.orderDetailVC.orderStatus = self.orderStatus;
    self.orderDetailVC.order = self.order;
    self.deliveryInfoVC.order = self.order;
    self.orderDetailVC.itemList = self.itemList;
    self.orderDetailVC.shopImage = self.shopImage;
    self.orderDetailVC.totalPrice = self.totalPrice;
    self.orderDetailVC.address = self.address;
    
    NSArray *vcArray = @[self.deliveryInfoVC, self.orderDetailVC];
    NSArray *title = @[@"Delivery", @"Detail"];
    self.slideMultiViewController = [[SlideMultiViewController alloc]init];
    self.slideMultiViewController.view.frame = CGRectMake(0, sdNavigationBarHeight, self.view.frame.size.width, self.view.frame.size.height - sdNavigationBarHeight);
    [self addChildViewController:self.slideMultiViewController];
    [self.slideMultiViewController initSlideMultiView:vcArray withTitle:title];
    [self.view addSubview:self.slideMultiViewController.view];
    self.slideMultiViewController.isVerticalEnable = false;
    //[self.slideMultiViewController.contentScrollView setContentOffset:CGPointMake(0, 0)];
}

@end
