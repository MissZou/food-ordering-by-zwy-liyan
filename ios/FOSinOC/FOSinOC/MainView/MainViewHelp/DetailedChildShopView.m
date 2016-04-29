//
//  DetailedChildShopView.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/26.
//  Copyright © 2016年 李龑. All rights reserved.
//
#define slideTitleHeight 40
#define navigationBarHeight 64

#import "DetailedChildShopView.h"

@interface DetailedChildShopView ()<UIScrollViewDelegate>
@property(strong,nonatomic) UIScrollView *shopScrollView;
@property(strong,nonatomic) UIView *headView;
@property(strong,nonatomic) UIView *billboardView;
@property(strong,nonatomic) UIView *basicInfoView;

@property(strong,nonatomic) UILabel *shopName;
@property(strong,nonatomic) UILabel *shopMark;
@property(strong,nonatomic) UIButton *favoriteButton;

@end

@implementation DetailedChildShopView

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor greenColor];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    [self initShopView];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[self initShopView];
}

-(void)initShopView{
    self.shopScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.superview.frame.size.height - slideTitleHeight)];
    self.shopScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 800);
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    self.shopName = [[UILabel alloc]init];
    self.shopName.text = @"shopName(@ some location)";
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10]};
    
    CGRect labelFrame = [self.shopName.text boundingRectWithSize:self.shopName.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute
     context:nil];
    self.shopName.frame = CGRectMake(10, 10, labelFrame.size.width, 25);
    
    self.shopMark = [[UILabel alloc]init];
    self.shopMark.text = @"5 start";
    labelFrame = [self.shopMark.text boundingRectWithSize:self.shopMark.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute
                                                    context:nil];
    self.shopMark.frame = CGRectMake(10, 40, labelFrame.size.width, 25);
    
    self.favoriteButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 60, 10, 55, 55)];
    [self.favoriteButton setTitle:@"Favorite" forState:UIControlStateNormal];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favoriteGreen.png"] forState:UIControlStateNormal];
    
    
    [self.headView addSubview:self.shopName];
    [self.headView addSubview:self.shopMark];
    [self.headView addSubview:self.favoriteButton];
    [self.shopScrollView addSubview:self.headView];
    [self.view addSubview:self.shopScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

@end
