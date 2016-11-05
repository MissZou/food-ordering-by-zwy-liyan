//
//  LeftMenuViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/12.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "Account.h"
@interface LeftMenuViewController ()
@property (weak, nonatomic) IBOutlet UIButton *greenButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(strong,nonatomic) Account *myAccount;
@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.greenButton.layer.shadowOpacity = 0.2;
    self.myAccount = [Account sharedManager];
//    self.nameLabel.layer.shadowOpacity = 1;
//    //self.nameLabel.layer.shadowOffset = CGSizeMake(-2.0, 0.0);
    self.nameLabel.text = self.myAccount.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)greenButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"orderListView" sender:nil];
}

-(BOOL)prefersStatusBarHidden{
    return true;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
