//
//  OrderDetailViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/9/9.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "OrderDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

static const CGFloat sdNavigationBarHeight = 64;
#define myBlack [UIColor colorWithRed:56/255.0 green:56/255.0 blue:56/255.0 alpha:1]
#define myBlackIron [UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1]
#define myBlackSteel [UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:1]



@interface OrderDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *detailedTable;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView {
    self.detailedTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - sdNavigationBarHeight) style:UITableViewStyleGrouped];
    self.detailedTable.delegate = self;
    self.detailedTable.dataSource = self;
    [self.detailedTable registerClass:[UITableViewCell self] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.detailedTable];
    self.detailedTable.sectionFooterHeight = 0.0;
    //self.detailedTable.separatorColor = [UIColor clearColor];
    //[self.detailedTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Order Detail";
    }
    else if (section == 1) {
        return @"Delivery Info";
    }
    return @"";
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 32, 32)];
            if ([self.orderStatus isEqualToString:@"created"]) {
                imageView.image = self.shopImage;
            }else {
                NSString *url = [NSString stringWithFormat:@"http://localhost:8080/%@",[[self.order valueForKey:@"shop"] valueForKey:@"shopPicUrl"]];
                [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"favoriteGreen.png"]];
            }
            imageView.layer.cornerRadius = 20;
            imageView.layer.masksToBounds = YES;
            [cell.contentView addSubview:imageView];
            UILabel *shopName = [[UILabel alloc]initWithFrame:CGRectMake(55, 5, self.view.frame.size.width - 55, 32)];
            shopName.text = [[self.order valueForKey:@"shop"] valueForKey:@"shopName"];
            shopName.textColor = myBlackSteel;
            shopName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
            [cell.contentView addSubview:shopName];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        if (indexPath.row == 1) {
            NSArray *array = [self.order valueForKey:@"items"];
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            for (int i = 0; i<array.count; i++) {
                UILabel *item = [[UILabel alloc]initWithFrame:CGRectMake(15, 5 + i*35, self.view.frame.size.width*0.4, 30)];
                item.textColor = myBlack;
                item.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                
                UILabel *muilti = [[UILabel alloc]initWithFrame:CGRectMake(25+self.view.frame.size.width * 0.4, 5 + i *35, 40, 30)];
                muilti.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                muilti.textColor = myBlackSteel;
                
                UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 70, 5 + i*35, 60, 30)];
                price.textColor = myBlack;
                price.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                item.text = [array[i] valueForKey:@"dishName"];
                muilti.text = [NSString stringWithFormat:@"x %@",[array[i] valueForKey:@"amount"]];
                price.text = [NSString stringWithFormat:@"%@ HKD",[array[i] valueForKey:@"price"]];
                
                [cell.contentView addSubview:item];
                [cell.contentView addSubview:muilti];
                [cell.contentView addSubview:price];
            }
            for (int i = 0; i<self.itemList.count; i++) {
                UILabel *item = [[UILabel alloc]initWithFrame:CGRectMake(15, 5 + i*35, self.view.frame.size.width*0.4, 30)];
                item.textColor = myBlack;
                item.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                
                UILabel *muilti = [[UILabel alloc]initWithFrame:CGRectMake(25+self.view.frame.size.width * 0.4, 5 + i *35, 40, 30)];
                muilti.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                muilti.textColor = myBlackSteel;
                
                UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 70, 5 + i*35, 60, 30)];
                price.textColor = myBlack;
                price.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    
                item.text = [self.itemList[i] valueForKey:@"dishName"];
                muilti.text = [NSString stringWithFormat:@"x %@",[self.itemList[i] valueForKey:@"amount"]];
                price.text = [NSString stringWithFormat:@"HKD %@",[self.itemList[i] valueForKey:@"price"]];
                [cell.contentView addSubview:item];
                [cell.contentView addSubview:muilti];
                [cell.contentView addSubview:price];
            }
            return cell;
        }
        if (indexPath.row == 2) {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            UILabel *total = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 130, 5, 110, 32)];
            if ([self.orderStatus isEqualToString:@"created"]) {
                total.text = [NSString stringWithFormat:@"Total HKD %d", (int)self.totalPrice];
            } else {
                total.text = [NSString stringWithFormat:@"Total HKD %@",[self.order valueForKey:@"price"]];
            }
            total.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
            total.textColor = myBlack;
            [cell.contentView addSubview:total];
            return cell;
        }
        
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 60, 30)];
        label.text = @"Address";
        label.textColor = myBlackSteel;
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(80, 5, 90, 30)];
        name.textColor = myBlack;
        name.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        UILabel *phone = [[UILabel alloc]initWithFrame:CGRectMake(175, 5, self.view.frame.size.width - 180, 30)];
        phone.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        phone.textColor = myBlack;
        UILabel *addr = [[UILabel alloc]initWithFrame:CGRectMake(15, 35, self.view.frame.size.width - 15, 30)];
        addr.textColor = myBlack;
        addr.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        if ([self.orderStatus isEqualToString:@"created"]) {
            name.text = [self.address valueForKey:@"name"];
            phone.text = [self.address valueForKey:@"phone"];
            addr.text = [self.address valueForKey:@"addr"];
        } else {
            name.text = [[self.order valueForKey:@"address"] valueForKey:@"name"];
            phone.text = [[self.order valueForKey:@"address"] valueForKey:@"phone"];
            addr.text = [[self.order valueForKey:@"address"] valueForKey:@"addr"];
        }
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:name];
        [cell.contentView addSubview:phone];
        [cell.contentView addSubview:addr];
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.text = @"1";
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return 80;
//    }
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        if ([self.orderStatus isEqualToString:@"created"]) {
            return self.itemList.count*40;
        } else {
            NSArray *array = [self.order valueForKey:@"items"];
            return 40*(array.count);
        }
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        return 75;
    }
    return 44;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
//        view.backgroundColor = [UIColor blueColor];
//        return view;
//    }
//    return nil;
//}

@end
