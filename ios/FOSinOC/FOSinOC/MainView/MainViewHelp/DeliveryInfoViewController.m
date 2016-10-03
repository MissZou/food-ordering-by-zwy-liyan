//
//  DeliveryInfoViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/9/9.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "DeliveryInfoViewController.h"
#import "Masonry.h"

static const CGFloat indicatorWidth = 40;
static const CGFloat sdNavigationBarHeight = 64;
static const CGFloat titleHeight = 64;

#define tableCellTag 1860
#define myBlackIron [UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1]
#define myBlackSteel [UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:1]

@interface DeliveryInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *deliveryTable;
@property (strong, nonatomic) UITableViewCell *cellCreateOrder;
@property (strong, nonatomic) UITableViewCell *cellPaidSuccess;
@property (strong, nonatomic) UITableViewCell *cellShipped;
@property (strong, nonatomic) UITableViewCell *cellConfirmed;
@property (strong, nonatomic) UIBezierPath *path;
@end

@implementation DeliveryInfoViewController

//- (void)loadView {
//    [super loadView];
//
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - titleHeight - sdNavigationBarHeight);
    self.deliveryTable.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //self.deliveryTable.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView {
    self.deliveryTable = [[UITableView alloc]init];
    self.deliveryTable.delegate = self;
    self.deliveryTable.dataSource = self;
    [self.deliveryTable registerClass:[UITableViewCell self] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.deliveryTable];
    // init static cells

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.orderStatus isEqualToString:@"created"] || [[self.order valueForKey:@"status"] isEqualToString:@"created"]) {
        return 2;
    }
    if ([[self.order valueForKey:@"status"] isEqualToString:@"shipped"]) {
        return 3;
    }
    if ([[self.order valueForKey:@"status"] isEqualToString:@"confirmed"]) {
        return 4;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UILabel *title = [[UILabel alloc]init];
    title.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    title.textColor = myBlackIron;
    //title.textAlignment = NSTextAlignmentCenter;
    UILabel *detail = [[UILabel alloc]init];
    detail.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    detail.textColor = [UIColor grayColor];
    //detail.numberOfLines = 0;
    
    UILabel *time = [[UILabel alloc]init];
    time.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    time.textColor = [UIColor grayColor];
    if (indexPath.row == 0) {
        self.cellCreateOrder = [[UITableViewCell alloc]init];
        self.cellCreateOrder.selectionStyle = UITableViewCellSelectionStyleNone;
        title.text = @"Order Created";
        detail.text = @"detail";
        [self.cellCreateOrder.contentView addSubview:title];
        [self.cellCreateOrder.contentView addSubview:detail];
        [self.cellCreateOrder.contentView addSubview:time];
        detail.preferredMaxLayoutWidth = self.cellCreateOrder.contentView.frame.size.width - 20;
        [detail setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"MM-dd HH:mm";
        if ([self.orderStatus isEqualToString:@"created"]) {
            time.text = [formatter stringFromDate:[NSDate date]];
        }else {
//            NSString *orignDateString = [self.order valueForKey:@"date"];
//            NSString *mmdd = [orignDateString substringWithRange:NSMakeRange(5, 5)];
//            NSString *hhss = [orignDateString substringWithRange:NSMakeRange(11, 5)];
//            NSString *newDateString = [NSString stringWithFormat:@"%@ %@",mmdd,hhss];
//            NSDate *tempDate = [formatter dateFromString:newDateString];
            NSDate *tempDate = [self dateISOStringToNSDate:[self.order valueForKey:@"date"]];
            NSDate *nowDate = [self getNowDateFromatAnDate:tempDate];
            time.text = [formatter stringFromDate: nowDate];
        }
        
        [time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cellCreateOrder.contentView.mas_top).with.offset(5);
            make.width.equalTo([NSNumber numberWithInt:100]);
            make.right.equalTo(self.cellCreateOrder.mas_right).with.offset(-10);
            make.height.equalTo(@30);
        }];
        [title mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.cellCreateOrder.contentView.mas_top).with.offset(5);
            make.left.equalTo(self.cellCreateOrder.contentView.mas_left).with.offset(10);
            make.right.equalTo(time.mas_left).with.offset(-10);
            make.height.equalTo(@30);
        }];
        [detail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(title.mas_bottom).with.offset(10);
            make.left.equalTo(title.mas_left);
            make.right.equalTo(self.cellCreateOrder.contentView.mas_right).with.offset(-10);
            make.height.equalTo(@30);
            //make.bottom.equalTo(self.cellCreateOrder.mas_bottom).with.offset(-10);
        }];
        return self.cellCreateOrder;
    }
    else if (indexPath.row == 1) {
        self.cellPaidSuccess = [[UITableViewCell alloc]init];
        self.cellPaidSuccess.selectionStyle = UITableViewCellSelectionStyleNone;
        title.text = @"Paid";
        detail.text = @"Wait to vender to ship";
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"MM-dd HH:mm";
        if ([self.orderStatus isEqualToString:@"created"]) {
            time.text = [formatter stringFromDate:[NSDate date]];
        }else {
            NSDate *tempDate = [self dateISOStringToNSDate:[self.order valueForKey:@"date"]];
            NSDate *nowDate = [self getNowDateFromatAnDate:tempDate];
            time.text = [formatter stringFromDate: nowDate];
        }
        [self.cellPaidSuccess.contentView addSubview:title];
        [self.cellPaidSuccess.contentView addSubview:detail];
        [self.cellPaidSuccess.contentView addSubview:time];
        [time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cellPaidSuccess.contentView.mas_top).with.offset(5);
            make.width.equalTo([NSNumber numberWithInt:100]);
            make.right.equalTo(self.cellPaidSuccess.mas_right).with.offset(-10);
            make.height.equalTo(@30);
        }];
        [title mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.cellPaidSuccess.contentView.mas_top).with.offset(5);
            make.left.equalTo(self.cellPaidSuccess.contentView.mas_left).with.offset(10);
            make.right.equalTo(time.mas_left).with.offset(-10);
            make.height.equalTo(@30);
        }];
        [detail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(title.mas_bottom).with.offset(10);
            make.left.equalTo(title.mas_left);
            make.right.equalTo(self.cellPaidSuccess.contentView.mas_right).with.offset(-10);
            make.height.equalTo(@30);
        }];
        return self.cellPaidSuccess;
    }
    else if (indexPath.row == 2) {
        self.cellShipped = [[UITableViewCell alloc]init];
        self.cellShipped.selectionStyle = UITableViewCellSelectionStyleNone;
        title.text = @"Shipped";
        detail.text = @"Your items is on the way";
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"MM-dd HH:mm";
        //time.text = [formatter stringFromDate:[NSDate date]];
        NSDate *tempDate = [self dateISOStringToNSDate:[self.order valueForKey:@"shippedDate"]];
        NSDate *nowDate = [self getNowDateFromatAnDate:tempDate];
        time.text = [formatter stringFromDate: nowDate];
        //time.text = [formatter stringFromDate:[self dateISOStringToNSDate:[self.order valueForKey:@"shippedDate"]]];
        [self.cellShipped.contentView addSubview:title];
        [self.cellShipped.contentView addSubview:detail];
        [self.cellShipped.contentView addSubview:time];
        [time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cellShipped.contentView.mas_top).with.offset(5);
            make.width.equalTo([NSNumber numberWithInt:100]);
            make.right.equalTo(self.cellShipped.mas_right).with.offset(-10);
            make.height.equalTo(@30);
        }];
        [title mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.cellShipped.contentView.mas_top).with.offset(5);
            make.left.equalTo(self.cellShipped.contentView.mas_left).with.offset(10);
            make.right.equalTo(time.mas_left).with.offset(-10);
            make.height.equalTo(@30);
        }];
        [detail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(title.mas_bottom).with.offset(10);
            make.left.equalTo(title.mas_left);
            make.right.equalTo(self.cellShipped.contentView.mas_right).with.offset(-10);
            make.height.equalTo(@30);
        }];
        return self.cellShipped;
    }
    else if (indexPath.row == 3) {
        self.cellConfirmed = [[UITableViewCell alloc]init];
        self.cellConfirmed.selectionStyle = UITableViewCellSelectionStyleNone;
        title.text = @"Shipped";
        detail.text = @"Have a nice day.";
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"MM-dd HH:mm";
        NSDate *tempDate = [self dateISOStringToNSDate:[self.order valueForKey:@"confirmedDate"]];
        NSDate *nowDate = [self getNowDateFromatAnDate:tempDate];
        time.text = [formatter stringFromDate: nowDate];
        [self.cellConfirmed.contentView addSubview:title];
        [self.cellConfirmed.contentView addSubview:detail];
        [self.cellConfirmed.contentView addSubview:time];
        [time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cellConfirmed.contentView.mas_top).with.offset(5);
            make.width.equalTo([NSNumber numberWithInt:100]);
            make.right.equalTo(self.cellConfirmed.mas_right).with.offset(-10);
            make.height.equalTo(@30);
        }];
        [title mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.cellConfirmed.contentView.mas_top).with.offset(5);
            make.left.equalTo(self.cellConfirmed.contentView.mas_left).with.offset(10);
            make.right.equalTo(time.mas_left).with.offset(-10);
            make.height.equalTo(@30);
        }];
        [detail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(title.mas_bottom).with.offset(10);
            make.left.equalTo(title.mas_left);
            make.right.equalTo(self.cellConfirmed.contentView.mas_right).with.offset(-10);
            make.height.equalTo(@30);
        }];
        return self.cellConfirmed;
    }

    else{
        
        return nil;
    }
    
    //return cell;
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
//        CGSize size = [self.cellCreateOrder.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//        NSLog(@"caculated h=%f", size.height + 1);
        //return size.height + 1;
        return 100;
    }
    else if (indexPath.row == 1) {
        return 100;
    }
    else if (indexPath.row == 2) {
        return 100;
    }
    else
    return 100;
}

- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

- (NSDate *)dateISOStringToNSDate:(NSString *)timeString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"MM-dd HH:mm";
    NSString *mmdd = [timeString substringWithRange:NSMakeRange(5, 5)];
    NSString *hhss = [timeString substringWithRange:NSMakeRange(11, 5)];
    NSString *newDateString = [NSString stringWithFormat:@"%@ %@",mmdd,hhss];
    NSDate *tempDate = [formatter dateFromString:newDateString];
    return tempDate;
}

@end
