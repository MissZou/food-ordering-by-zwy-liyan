//
//  AccountAddressViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/15.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "AccountAddressViewController.h"
#import "AddressCell.h"
#import "EditAddressViewController.h"
#import "CustomizedSegueLeftToRight.h"
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
    
    
    self.topView.layer.shadowOffset = CGSizeMake(0.0, 5.0);
    self.topView.layer.shadowOpacity = 0.3;
    self.bottomView.layer.shadowOpacity = 0.3;
    self.bottomView.layer.shadowOffset = CGSizeMake(2.0, -3.0);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.myAccout.delegate = self;
    [self.myAccout checkLogin];
    NSLog(@"log did appear");
    
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
        cell.button.hidden = true;
        
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

        //cell.button.titleLabel.text = @"ppppp";
    }
    
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"UITableViewCellEditingStyleDelete edit");
        // Delete the row from the data source
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(void)prepareForSegue:(CustomizedSegueLeftToRight *)segue sender:(id)sender{
    if ([segue.identifier  isEqual: @"editAddress"]) {
        NSIndexPath *indexPath = sender;
        NSLog(@"%@",indexPath);
        EditAddressViewController *destinationViewController = segue.destinationViewController;
        NSArray *addr = self.myAccout.deliverAddress;
        destinationViewController.passName = [[addr objectAtIndex:indexPath.row] valueForKey:@"name"];
        destinationViewController.passPhone = [[addr objectAtIndex:indexPath.row] valueForKey:@"phone"];
        destinationViewController.passAddress = [[addr objectAtIndex:indexPath.row] valueForKey:@"addr"];
        destinationViewController.passAddrId = [[addr objectAtIndex:indexPath.row] valueForKey:@"_id"];
        destinationViewController.isEditing = true;
    }
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        NSLog(@"%@",indexPath);
                                        [self.tableView selectRowAtIndexPath:indexPath animated:false scrollPosition:UITableViewScrollPositionNone];
                                        [self performSegueWithIdentifier:@"editAddress" sender:indexPath];
                                        NSLog(@"Edit");
                                    }];
    button.backgroundColor = [UIColor grayColor]; //arbitrary color
    UITableViewRowAction *button2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                     {
                                         NSDictionary *addr = [self.myAccout.deliverAddress objectAtIndex:indexPath.row];
                                         if ([addr valueForKey:@"name"] != nil &&
                                             ![[addr valueForKey:@"name"] isEqualToString:@""] &&
                                             [addr valueForKey:@"phone"] != nil &&
                                             ![[addr valueForKey:@"phone"] isEqualToString:@""] &&
                                             [addr valueForKey:@"addr"] != nil &&
                                             ![[addr valueForKey:@"addr"] isEqualToString:@""] &&
                                             [addr valueForKey:@"_id"] != nil) {
                                             NSDictionary *address = @{@"name":[addr valueForKey:@"name"],@"address":[addr valueForKey:@"addr"],@"phone":[addr valueForKey:@"phone"],@"type":@"1",@"_id":[addr valueForKey:@"_id"]};
                                             [self.myAccout.deliverAddress removeObjectAtIndex:indexPath.row];
                                             [self.myAccout address:DELETE withAddress:address];
                                         }
                                         [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                         
                                         NSLog(@"Action to perform with Button2!");
                                     }];
    button2.backgroundColor = [UIColor redColor]; //arbitrary color
    
    return @[button, button2]; //array with all the buttons you want. 1,2,3, etc...
}

-(void)finishFetchAccountData:(NSDictionary *)result withAccount:(Account *)myAccount{
    [self.tableView reloadData];
}


@end
