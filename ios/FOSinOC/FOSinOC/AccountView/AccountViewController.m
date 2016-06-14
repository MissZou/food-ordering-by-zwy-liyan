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
    [self.myAccount address:GET withAddress:nil];
    UITapGestureRecognizer *avatarTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTapEvent)];
    [self.avatar setUserInteractionEnabled:true];
    [self.avatar addGestureRecognizer:avatarTapGesture];
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

-(void)avatarTapEvent{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Change avatar" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        //[self dismissViewControllerAnimated:true completion:nil];
        [actionSheet dismissViewControllerAnimated:true completion:nil];
    }]];
    [self presentViewController:actionSheet animated:true completion:nil];
}



@end
