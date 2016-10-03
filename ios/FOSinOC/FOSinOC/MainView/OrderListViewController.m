//
//  OrderListViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/9/27.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "OrderListViewController.h"
#import "Account.h"
#import "Order.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "OrderInfoViewController.h"

#define tableCellTag 1800
#define myBlackIron [UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1]
#define myBlackSteel [UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:1]

@interface OrderListViewController ()<UITableViewDelegate, UITableViewDataSource, AccountDelegate>
@property (strong, nonatomic) UITableView *orderTableView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) UIActivityIndicatorView *mySpinner;
@property (strong, nonatomic) Account *myAccount;
@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initActivityIndicator];
    [self.mySpinner startAnimating];
    self.myAccount = [Account sharedManager];
    self.myAccount.delegate = self;
    [self.myAccount getOrderAtIndex:1 withCount:20];
    self.topView.layer.shadowOpacity = 0.5;
    self.topView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255 blue:248.0/255.0 alpha:1];
    self.orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.orderTableView registerClass:[UITableViewCell self] forCellReuseIdentifier:@"cell"];
    self.orderTableView.delegate = self;
    self.orderTableView.dataSource = self;

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    if (self.myAccount.order.count == 0) {
//        UILabel *noOrderLabel = [[UILabel alloc]init];
//        noOrderLabel.frame = CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width - 60, 60);
//        noOrderLabel.center = self.view.center;
//        noOrderLabel.text = @"No Order";
//        [self.view addSubview:noOrderLabel];
//    }else {
//        [self.view addSubview:self.orderTableView];
//    }
}


-(void)initActivityIndicator{
    self.mySpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.mySpinner];
    self.mySpinner.center = self.view.center;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be rec如果改用strong关键字，可能造成什么问题reated.
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myAccount.order.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if ([cell.contentView subviews].count == 0) {
        
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 40, 40)];
        [icon sd_setImageWithURL:[[self.myAccount.order[indexPath.row] valueForKey:@"shop"] valueForKey:@"shopPicUrl"] placeholderImage:[UIImage imageNamed:@"favoriteGreen.png"]];
        icon.layer.cornerRadius = 20;
        icon.layer.masksToBounds = YES;
        icon.layer.shouldRasterize = YES;
        icon.layer.rasterizationScale = [UIScreen mainScreen].scale;
        icon.tag = tableCellTag + 1;
        [cell.contentView addSubview:icon];
        UILabel *shopName = [[UILabel alloc]init];
        shopName.frame = CGRectMake(60, 5, self.view.frame.size.width - 20, 40);
        shopName.text = [[self.myAccount.order[indexPath.row] valueForKey:@"shop"] valueForKey:@"shopName"];
        shopName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        //shopName.textColor = myBlackSteel;
        shopName.tag = tableCellTag + 2;
        [cell.contentView addSubview:shopName];
        NSArray *items = [self.myAccount.order[indexPath.row] valueForKey:@"items"];
        UILabel *item1 = [[UILabel alloc]initWithFrame:CGRectMake(70, 55, self.view.frame.size.width - 90, 30)];
        item1.textColor = myBlackIron;
        item1.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        item1.tag = tableCellTag + 3;
        if (items.count > 0 && [items[0] valueForKey:@"dishName"]) {
            item1.text = [items[0] valueForKey:@"dishName"];
            [cell.contentView addSubview:item1];
        }
        UILabel *item2 = [[UILabel alloc]initWithFrame:CGRectMake(70, 90, self.view.frame.size.width - 90, 30)];
        item2.textColor = myBlackIron;
        item2.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        item2.tag = tableCellTag + 4;
        if (items.count > 1 && [items[1] valueForKey:@"dishName"]) {
            item2.text = [items[1] valueForKey:@"dishName"];
            [cell.contentView addSubview:item2];
        }
        UILabel *detail = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2+40, 125, self.view.frame.size.width/2-40, 30)];
        detail.tag = tableCellTag + 5;
        //NSString *detailString = [NSString stringWithFormat:@"%lu items, %@ HKD", (unsigned long)items.count,[self.myAccount.order[indexPath.row] valueForKey:@"price"]];
        NSString *detailString = [NSString stringWithFormat:@"%lu items, %@ HKD", (unsigned long)items.count,[self.myAccount.order[indexPath.row] valueForKey:@"price"]];
        detail.text = detailString;
        detail.textColor = myBlackIron;
        detail.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        [cell.contentView addSubview:detail];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else{
        UIImageView *icon = [cell.contentView viewWithTag:tableCellTag + 1];
        [icon sd_setImageWithURL:[[self.myAccount.order[indexPath.row] valueForKey:@"shop"] valueForKey:@"shopPicUrl"] placeholderImage:[UIImage imageNamed:@"favoriteGreen.png"]];
        UILabel *shopName = [cell.contentView viewWithTag:tableCellTag + 2];
        shopName.text = [[self.myAccount.order[indexPath.row] valueForKey:@"shop"] valueForKey:@"shopName"];
        NSArray *items = [self.myAccount.order[indexPath.row] valueForKey:@"items"];
        UILabel *item1 = [cell.contentView viewWithTag:tableCellTag + 3];
        if (items.count > 0 && [items[0] valueForKey:@"dishName"]) {
            item1.text = [items[0] valueForKey:@"dishName"];
        }
        UILabel *item2 = [cell.contentView viewWithTag:tableCellTag + 4];
        if (items.count > 1 && [items[1] valueForKey:@"dishName"]) {
            item2.text = [items[1] valueForKey:@"dishName"];
        }
        UILabel *detail = [cell.contentView viewWithTag:tableCellTag + 5];
        NSString *detailString = [NSString stringWithFormat:@"%lu items, %@ HKD", (unsigned long)items.count,[self.myAccount.order[indexPath.row] valueForKey:@"price"]];
        detail.text = detailString;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    
//}

- (void)finishRefreshAccountData {
    [self.mySpinner stopAnimating];
    if (self.myAccount.order.count == 0) {
        UILabel *noOrderLabel = [[UILabel alloc]init];
        noOrderLabel.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, self.view.frame.size.width - 60, 60);
        //noOrderLabel.center = self.view.center;
        noOrderLabel.text = @"No Order";
        [self.view addSubview:noOrderLabel];
    }else {
        [self.view addSubview:self.orderTableView];
    }
    [self.orderTableView reloadData];
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 155;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"orderInfo" sender:indexPath];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"orderInfo"]) {
        NSIndexPath *indexPath = sender;
        OrderInfoViewController *destinationVC = segue.destinationViewController;
        Order *order = self.myAccount.order[indexPath.row];
        destinationVC.order = order;
    }
}

@end
