//
//  ChooseAddressViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/6/29.
//  Copyright © 2016年 李龑. All rights reserved.
//

#define myBlackIron [UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1]
#define myBlackSteel [UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:1]
#define tableCellTag 1660

#import "ChooseAddressViewController.h"
#import "AddressCell.h"
#import "Account.h"
@interface ChooseAddressViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic) UITableView *tableView;
@property(strong,nonatomic) Account *myAccout;
@end

@implementation ChooseAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myAccout = [Account sharedManager];
    [self initViewController];
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.navigationController.navigationBar.layer.shadowRadius = 4.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = 0.3f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initViewController{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.tableView registerClass:[UITableViewCell self] forCellReuseIdentifier:@"cell"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.myAccout.deliverAddress count]) {
        return self.myAccout.deliverAddress.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if ([cell.contentView subviews].count == 0) {
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(22, 8, 140, 21)];
        name.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        name.textColor = myBlackIron;
        name.tag = tableCellTag+1;
        
        UILabel *phone = [[UILabel alloc]initWithFrame:CGRectMake(180, 8, 140, 21)];
        phone.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        phone.textColor = myBlackIron;
        phone.tag = tableCellTag+2;
        
        UILabel *address = [[UILabel alloc]initWithFrame:CGRectMake(21, 37, 280, 21)];
        address.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        address.textColor = myBlackIron;
        address.tag = tableCellTag+3;
        
        UIButton *defaultButton = [[UIButton alloc]initWithFrame:CGRectMake(350, 30, 30, 30)];
        [defaultButton setImage:[UIImage imageNamed:@"tickWhite.png"] forState:UIControlStateNormal];
        defaultButton.tag = tableCellTag + 4;
        
        
        if ([self.myAccout.deliverAddress count]) {
            NSDictionary *addr = self.myAccout.deliverAddress[indexPath.row];
            if ([addr valueForKey:@"name"]) {
                name.text = [addr valueForKey:@"name"];
            }
            if ([addr valueForKey:@"addr"]) {
                address.text = [addr valueForKey:@"addr"];
            }
            if ([addr valueForKey:@"phone"]) {
                phone.text = [addr valueForKey:@"phone"];
            }
        }
        [cell.contentView addSubview:name];
        [cell.contentView addSubview:phone];
        [cell.contentView addSubview:address];
        [cell.contentView addSubview:defaultButton];
        if (indexPath.row == 0) {
            cell.backgroundColor = [UIColor colorWithRed:250/255.0 green:114/255.0 blue:109/255.0 alpha:1];
            defaultButton.hidden = false;
            //cell.defaultButton.enabled = true;
        }else{
            cell.backgroundColor = [UIColor whiteColor];
            defaultButton.hidden = true;
            
        }
    }else{
        UILabel *name = (UILabel *)[cell.contentView viewWithTag:tableCellTag+1];
        UILabel *phone = (UILabel *)[cell.contentView viewWithTag:tableCellTag+2];
        UILabel *address = (UILabel *)[cell.contentView viewWithTag:tableCellTag+3];
        UIButton *defaultButton = (UIButton *)[cell.contentView viewWithTag:tableCellTag+4];
        if ([self.myAccout.deliverAddress count]) {
            NSDictionary *addr = self.myAccout.deliverAddress[indexPath.row];
            if ([addr valueForKey:@"name"]) {
                name.text = [addr valueForKey:@"name"];
            }
            if ([addr valueForKey:@"addr"]) {
                address.text = [addr valueForKey:@"addr"];
            }
            if ([addr valueForKey:@"phone"]) {
                phone.text = [addr valueForKey:@"phone"];
            }
        }
        if (indexPath.row == 0) {
            cell.backgroundColor = [UIColor colorWithRed:250/255.0 green:114/255.0 blue:109/255.0 alpha:1];
            defaultButton.hidden = false;
            //cell.defaultButton.enabled = true;
        }else{
            cell.backgroundColor = [UIColor whiteColor];
            defaultButton.hidden = true;
            
        }
    }
    
    return cell;
}
@end
