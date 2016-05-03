//
//  DetailedChildShopView.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/26.
//  Copyright © 2016年 李龑. All rights reserved.
//
<<<<<<< HEAD
#define slideTitleHeight 40
#define navigationBarHeight 64
#define headViewHeight 100
#define billboardViewHeight 100
#define basicInfoViewHeight 100
#define boxMargin 15
#define segmentViewHeight 100
=======
>>>>>>> parent of 153e679... implement comment view and some objects of detailed shop view

#import "DetailedChildShopView.h"

@interface DetailedChildShopView ()

@property(assign,nonatomic)CGFloat maxOffset;

@end

@implementation DetailedChildShopView

- (void)viewDidLoad {
    [super viewDidLoad];
<<<<<<< HEAD
    //self.view.backgroundColor = [UIColor greenColor];
//    [self.view setNeedsLayout];
//    [self.view layoutIfNeeded];
    [self initShopView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(triggerNotificationAction:) name:@"enableInteractionShop" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[self initShopView];
    self.shopScrollView.userInteractionEnabled = false;
}

-(void)disableInteraction{
    self.shopScrollView.userInteractionEnabled = false;
}

-(void)enableInteraction{
    self.shopScrollView.userInteractionEnabled = true;
}

-(void)initShopView{
    self.shopScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - slideTitleHeight)];
    self.shopScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 800);
    self.shopScrollView.delegate = self;
    self.shopScrollView.backgroundColor = [UIColor grayColor];
//headview=============================
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(boxMargin, boxMargin, self.view.frame.size.width  - boxMargin*2, headViewHeight)];
    self.shopName = [[UILabel alloc]init];
    self.shopName.text = @"shopName(@ some location)";
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10]};
    
    CGRect labelFrame = [self.shopName.text boundingRectWithSize:self.shopName.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute
     context:nil];
    self.shopName.frame = CGRectMake(10, 10, 150, 25);
    
    self.shopMark = [[UILabel alloc]init];
    self.shopMark.text = @"5 start";
    labelFrame = [self.shopMark.text boundingRectWithSize:self.shopMark.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute
                                                    context:nil];
    self.shopMark.frame = CGRectMake(10, 40, 150, 25);
    
    self.favoriteButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 60-boxMargin, 10, 55, 55)];
    [self.favoriteButton setTitle:@"Favorite" forState:UIControlStateNormal];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favoriteGreen.png"] forState:UIControlStateNormal];
    
    [self.headView addSubview:self.shopName];
    [self.headView addSubview:self.shopMark];
    [self.headView addSubview:self.favoriteButton];
    
//==billboard view=======================================
    //self.billboardView = [[UIView alloc]initWithFrame:CGRectMake(boxMargin, self.headView.frame.origin.y + headViewHeight, self.view.frame.size.width - 2*boxMargin, billboardViewHeight)];
    
    UITextView *billboardText = [[UITextView alloc]initWithFrame:CGRectMake(boxMargin, self.headView.frame.origin.y + headViewHeight, self.view.frame.size.width - 2*boxMargin, billboardViewHeight)];
    
    billboardText.text = @"Mealtimes are more than food. They’re time to relax. Sometimes that means recharging all by yourself, other times it’s about connecting with friends and family. However you eat dinner, we’re here to make it as easy as it is delicious.";
    
    [self.shopScrollView addSubview:self.headView];
    [self.shopScrollView addSubview:billboardText];
    [self.view addSubview:self.shopScrollView];
    
}

=======
    self.view.backgroundColor = [UIColor greenColor];
    
}

>>>>>>> parent of 153e679... implement comment view and some objects of detailed shop view
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

<<<<<<< HEAD
-(void) triggerNotificationAction:(NSNotification *) notification
{
    if ([notification.object isKindOfClass:[NSNumber class]])
    {
        [self enableInteraction];
        NSNumber *y = [notification object];
        //NSLog(@"continu to scroll child %f",[y floatValue]);
        [self.shopScrollView setContentOffset:CGPointMake(0,  -[y floatValue]-segmentViewHeight)];
    }
    else
    {
        NSLog(@"Error, object not recognised.");
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"shop offset %f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y<0 ) {
        
        [self disableInteraction];
        
        if (self.maxOffset > scrollView.contentOffset.y) {
            self.maxOffset = scrollView.contentOffset.y;
            NSNumber *y = [NSNumber numberWithFloat:self.maxOffset];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"mainContinueScrollingShop" object:y];
        }
    }
    else if(scrollView.contentOffset.y>0){
        [self enableInteraction];
    }

=======
-(void)viewDidAppear:(BOOL)animated{
    
>>>>>>> parent of 153e679... implement comment view and some objects of detailed shop view
}

@end
