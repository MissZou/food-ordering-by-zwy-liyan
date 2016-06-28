//
//  FoodViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/5/26.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "FoodViewController.h"
#import "UINavigationBar+Awesome.h"
#import "Account.h"
#import "ThrowLineTool.h"

#define topImageHeight 150
#define segmentViewHeight 80
#define cartViewHeight 50
#define naviBarChangePoint 50

#define myBlueColor [UIColor colorWithRed:69/255.0 green:83/255.0 blue:153/255.0 alpha:1]
#define myCategoryColor [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]
#define myGreenColor [UIColor colorWithRed:91/255.0 green:207/255.0 blue:122/255.0 alpha:1]
#define myGreenColorHighlight [UIColor colorWithRed:76/255.0 green:134/255.0 blue:91/255.0 alpha:1]
#define myBlackColor [UIColor colorWithRed:61/255.0 green:61/255.0 blue:61/255.0 alpha:1]
#define myRedColor [UIColor colorWithRed:213/255.0 green:64/255.0 blue:58/255.0 alpha:1]

@interface FoodViewController()<UITableViewDelegate,UITableViewDataSource,ThrowLineToolDelegate>
@property(strong,nonatomic) UILabel* itemName;
@property(strong,nonatomic) UITableView *tableView;
@property(strong,nonatomic) UIImageView *topView;

//cart view
@property(strong,nonatomic)UIView *cartView;
@property(strong,nonatomic) UIButton *buyButton;
@property(strong,nonatomic) UIButton *cartButton;
@property(strong,nonatomic) UILabel *cartBadge;
@property(strong,nonatomic) UILabel *totalPrice;

@property(copy,nonatomic) NSString *lastSelectItem;
@property(strong,nonatomic) UIView *parabolaView;
@property(assign,nonatomic) NSUInteger totalItemCount;
@property(assign,nonatomic) NSUInteger itemCount;
@property(assign,nonatomic) BOOL syncCartData;

@end

@implementation FoodViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initNavigationBar];
    [self initTableView];
    //[self initCartView];
    NSLog(@"%@",self.shopId);
    NSLog(@"item _id %@",[self.item valueForKey:@"_id"]);
    
//    UIImageView *imageView = [[UIImageView alloc]init];
//    imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, 240);
//    imageView.image = self.itemImage;
//    [self.view addSubview:imageView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.itemName.alpha = 0;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;
    [self.navigationController.navigationBar lt_reset];
}

-(void)initTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    //self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell self] forCellReuseIdentifier:@"cell"];
    
    
    
    self.topView = [[UIImageView alloc]init];
    self.topView.frame = CGRectMake(0, 0, self.view.frame.size.width, topImageHeight);
    self.topView.image = self.itemImage;
    self.topView.contentMode = UIViewContentModeScaleAspectFill;
    self.topView.clipsToBounds = true;

    //[self.tableView insertSubview:self.topView atIndex:0];
    UIView *buttonView = [[UIView alloc]init];
    buttonView.frame = CGRectMake(0, 0, self.view.frame.size.width, 80);
    buttonView.backgroundColor = [UIColor blueColor];
    [self.tableView addSubview:self.topView];
    [self.tableView addSubview:buttonView];
    self.tableView.contentInset = UIEdgeInsetsMake(topImageHeight , 0, 0, 0);
    [self.view addSubview:self.tableView];
}



-(void)initNavigationBar{
    self.itemName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.itemName.text = [self.item valueForKey:@"dishName"];
    self.itemName.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = self.itemName;
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBarBackground"]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    
    [navigationBar setShadowImage:[UIImage new]];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    NSLog(@"off set y %f",point.y);
    if (point.y <= -topImageHeight-64) {
        //CGRect rect = [self.tableView viewWithTag:101].frame;
        CGRect rect = self.topView.frame;
        rect.origin.y = point.y;
        rect.size.height = -point.y;
        self.topView.frame = rect;
    }
    
    CGFloat offsetY = point.y;
    //UIColor *colour = [UIColor redColor];
    UIColor *color = [UIColor whiteColor];
    if (offsetY > naviBarChangePoint) {
        CGFloat alpha = MIN(1, 1 - ((naviBarChangePoint + 64 - point.y) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        self.itemName.alpha = alpha;
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        self.itemName.alpha = 0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 10;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 120.0;
    }else{
        return 20.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld--%ld", indexPath.section, indexPath.row];
    
    return cell;
}
@end
