//
//  DeliveryInfoViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/9/9.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "DeliveryInfoViewController.h"

static const CGFloat indicatorWidth = 40;
static const CGFloat sdNavigationBarHeight = 64;
static const CGFloat titleHeight = 64;

@interface DeliveryInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *deliveryTable;
@end

@implementation DeliveryInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self initView];
    self.view.backgroundColor = [UIColor redColor];
    NSLog(@"delivery view frame");
    NSLog(@"%f,%f",self.view.frame.size.width,self.view.frame.size.height);
    [self initView];
    //self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - slideTitleHeight - sdNavigationBarHeight);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //[self initView];
    self.deliveryTable.frame = CGRectMake(indicatorWidth, 0, self.view.frame.size.width - indicatorWidth, self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView {
    self.deliveryTable = [[UITableView alloc]initWithFrame:CGRectMake(indicatorWidth, 0, self.view.frame.size.width - indicatorWidth, self.view.frame.size.height)];
    self.deliveryTable.delegate = self;
    self.deliveryTable.dataSource = self;
    [self.deliveryTable registerClass:[UITableViewCell self] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.deliveryTable];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 25;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    return cell;
}

@end
