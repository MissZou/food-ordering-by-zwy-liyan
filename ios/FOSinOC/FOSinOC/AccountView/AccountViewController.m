//
//  AccountViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/14.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "AccountViewController.h"
#import "Account.h"

@interface AccountViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;


@property (strong,nonatomic) Account *myAccount;

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myAccount = [Account sharedManager];
    self.topView.layer.shadowOpacity = 0.3;
    self.avatar.layer.masksToBounds = true;
    self.avatar.layer.cornerRadius = 10.0;
    
    self.addressButton.layer.cornerRadius = 5.0;
    self.addressButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.addressButton.layer.borderWidth = 1.0;
    
    if (self.myAccount.photoUrl != nil) {
        self.avatar.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.myAccount.photoUrl]]];
    }
    if (self.myAccount.name != nil) {
        self.name.text = self.myAccount.name;
    }
    self.email.text = self.myAccount.email;
    
    //NSLog(@"%@",self.myAccount.deliverAddress);
    // Do any additional setup after loading the view.
    [self.myAccount address:GET withAddress:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismissAccountView:(id)sender {
    CATransition *transition = [CATransition new];
    transition.duration = 0.35;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromLeft;
    
    UIWindow *containerWindow = self.view.window;
    [containerWindow.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:false completion:nil];
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
