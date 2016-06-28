//
//  PlaceOrderViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/6/28.
//  Copyright © 2016年 李龑. All rights reserved.
//
#define myGreenColor [UIColor colorWithRed:91/255.0 green:207/255.0 blue:122/255.0 alpha:1]
#define myGreenColorHighlight [UIColor colorWithRed:76/255.0 green:134/255.0 blue:91/255.0 alpha:1]
#define myBlackColor [UIColor colorWithRed:61/255.0 green:61/255.0 blue:61/255.0 alpha:1]
#define bottomViewHeight 50

#import "PlaceOrderViewController.h"
#import "Account.h"
#import "Shop.h"

@interface PlaceOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic) UIView *bottomView;
@property(strong,nonatomic) UIButton *payButton;
@property(assign,nonatomic) NSUInteger *totalPrice;
@property(strong,nonatomic) UILabel *priceLabel;
@property(strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic)Account *myAccount;
@property (strong,nonatomic) Shop *myShop;

@end

@implementation PlaceOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self initBottomView];
    self.myAccount = [Account sharedManager];
    self.myShop = [Shop sharedManager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initBottomView{
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - bottomViewHeight, self.view.frame.size.width, bottomViewHeight)];
    self.bottomView.backgroundColor = myBlackColor;
    
    self.priceLabel = [[UILabel alloc]init];
    //self.priceLabel.numberOfLines = 0;
    self.priceLabel.text = @"Total Price: $0";
    self.priceLabel.textColor = [UIColor whiteColor];
    self.priceLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    self.priceLabel.frame = CGRectMake(80, 10, 100, 30);
    
    self.payButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 120, 0, 120, bottomViewHeight)];
    [self.payButton setBackgroundColor:myGreenColor];
    [self.payButton setTitle:@"Pay" forState:UIControlStateNormal];
    [self.payButton addTarget:self action:@selector(payButtonHandle) forControlEvents:UIControlEventTouchUpInside];
    [self.payButton addTarget:self action:@selector(payButtonHighlight) forControlEvents:UIControlEventTouchDown];
    self.payButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];

    [self.bottomView addSubview:self.payButton];
    [self.bottomView addSubview:self.priceLabel];
    [self.view addSubview:self.bottomView];
    
}

-(void)initTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - bottomViewHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell self] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tableView];
}
#pragma mark - Tableview delegate and Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;// first section for delivery address and delivery time
    }else if(section == 1){
        return 1; //payment online or offline
    }else if(section == 2){
        return 1;// shop and items
    }else{
        return 1;// leave message
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            cell.textLabel.text = @"address";
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"delivery time";
        }
            
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

#pragma mark - Button Handle

-(void)payButtonHandle{
    [self.payButton setBackgroundColor:myGreenColor];
}

-(void)payButtonHighlight{
    [self.payButton setBackgroundColor:myGreenColorHighlight];
}
@end
