//
//  FoodViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/5/26.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "FoodViewController.h"

@interface FoodViewController()
@property(strong,nonatomic) UILabel* foodName;
@end

@implementation FoodViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initNavigationBar];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(void)initNavigationBar{
    
    self.foodName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.foodName.text = @"foodName";
    self.foodName.textAlignment = NSTextAlignmentCenter;
    //self.foodName.backgroundColor = [UIColor redColor];
    
    self.navigationItem.titleView = self.foodName;
   
    //[self.navigationItem setBackBarButtonItem:backBarButton];
}
@end
