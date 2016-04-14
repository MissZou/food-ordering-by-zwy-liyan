//
//  LeftViewTableController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/12.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "LeftViewTableController.h"
#import "SSKeychain/SSKeychain.h"
@interface LeftViewTableController ()
@property(strong,nonatomic)NSArray *menuOptions;
@property(strong, nonatomic)Account *myAccount;
@end

@implementation LeftViewTableController

-(id)init{
    if (self = [super init]) {
        self.menuOptions = @[@"Account",@"Schedule",@"Favorite",@"Log out"];
        self.myAccount = [Account sharedManager];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuOptions = @[@"Account",@"Schedule",@"Favorite",@"Log out"];
    self.myAccount = [Account sharedManager];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(BOOL)prefersStatusBarHidden{
//    return YES;
//}

-(void)logout{
    [SSKeychain deletePasswordForService:self.myAccount.serviceName account:self.myAccount.serviceToken];
    [SSKeychain deletePasswordForService:self.myAccount.serviceName account:self.myAccount.servicePassword];
    [SSKeychain deletePasswordForService:self.myAccount.serviceName account:self.myAccount.serviceAccount];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return self.menuOptions.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.tableLabel.text = self.menuOptions[indexPath.row];
    return cell;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    LeftMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    return cell.bounds.size.height;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            NSLog(@"account");
            [self performSegueWithIdentifier:@"accountView" sender:nil];
            break;
        case 1:
            NSLog(@"Schedule");
            break;
        case 2:
            NSLog(@"favorite");
            break;
        case 3:
            [self logout];
            NSLog(@"log out");
            break;
        default:
            break;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
