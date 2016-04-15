//
//  AccountAddressViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/15.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "AccountAddressViewController.h"
#import "AddressCell.h"

@interface AccountAddressViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic) Account *myAccout;


@end

@implementation AccountAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myAccout = [Account sharedManager];
    self.myAccout.delegate = self;
    
    self.topView.layer.shadowOffset = CGSizeMake(0.0, 5.0);
    self.topView.layer.shadowOpacity = 0.3;
    self.bottomView.layer.shadowOpacity = 0.3;
    self.bottomView.layer.shadowOffset = CGSizeMake(2.0, -3.0);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"address" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.backgroundColor = [UIColor colorWithRed:250/255.0 green:114/255.0 blue:109/255.0 alpha:1];
        //cell.defaultButton.hidden = false;
        //cell.defaultButton.enabled = true;
    }else{
        cell.backgroundColor = [UIColor whiteColor];
        //cell.defaultButton.hidden = false;
        //cell.defaultButton.enabled = true;
    }
    if ([self.myAccout.deliverAddress count]) {
        NSDictionary *addr = self.myAccout.deliverAddress[indexPath.row];
        if ([addr valueForKey:@"name"]) {
            cell.name.text = [addr valueForKey:@"name"];
        }
        if ([addr valueForKey:@"addr"]) {
            cell.address.text = [addr valueForKey:@"addr"];
        }
        if ([addr valueForKey:@"phone"]) {
            cell.phone.text = [addr valueForKey:@"phone"];
        }
        
        cell.button.titleLabel.text = @"ppppp";
    }
    
    
    return cell;
}
@end
