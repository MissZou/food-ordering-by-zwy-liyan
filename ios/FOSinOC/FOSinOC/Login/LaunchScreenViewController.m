//
//  LaunchScreenViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/7.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "LaunchScreenViewController.h"
#import "SSKeychain/SSKeychain.h"
@interface LaunchScreenViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(strong, nonatomic) Account *myAccount;
@property(copy, nonatomic) NSString *email;
@property(copy,nonatomic) NSString *password;
@property(copy,nonatomic)NSString *token;
@end

@implementation LaunchScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.avatar.layer.masksToBounds = true;
    self.avatar.layer.cornerRadius = 5;
    self.avatar.layer.borderColor = [UIColor colorWithRed:83/255 green:98/255 blue:178/255 alpha:1].CGColor;
    self.avatar.layer.borderWidth = 2;
    
    self.nameLabel.hidden = true;
    self.avatar.hidden = true;
    
    self.myAccount = [Account sharedManager];
    self.myAccount.delegate = self;
    
    if([SSKeychain passwordForService:self.myAccount.serviceName account:self.myAccount.serviceToken]!=nil){
        self.myAccount.token = [SSKeychain passwordForService:self.myAccount.serviceName account:self.myAccount.serviceToken];
        [self.myAccount checkLogin];
    }else if([SSKeychain passwordForService:self.myAccount.serviceName account:self.myAccount.serviceAccount] != nil && [SSKeychain passwordForService:self.myAccount.serviceName account:self.myAccount.servicePassword] != nil){
        [self.myAccount checkLogin];
    }
//    NSString *email = [SSKeychain passwordForService:self.myAccount.serviceName account:self.myAccount.serviceAccount];
//    NSString *password = [SSKeychain passwordForService:self.myAccount.serviceName account:self.myAccount.servicePassword];
    //NSLog(@"%@,%@",email,password);
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([SSKeychain passwordForService:self.myAccount.serviceName account:self.myAccount.serviceToken]!=nil){
   
    }else {
        [self performSegueWithIdentifier:@"tutorial" sender:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)finishFetchAccountData:(NSDictionary *)result withAccount:(Account *)myAccount{
    
    if ([[result valueForKey:@"success"]boolValue] == YES) {


        if([result valueForKey:@"name"]!=nil)
        self.nameLabel.text = [NSString stringWithFormat:@"%@, %@",@"Welcom",[result valueForKey:@"name"]];
        
        if([result valueForKey:@"photoUrl"]!=nil)
            self.avatar.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[result valueForKey:@"photoUrl"]]]];
        self.avatar.hidden = false;
        [UIView animateWithDuration:0.0 animations:^{
            self.avatar.frame = CGRectMake(self.avatar.frame.origin.x, self.avatar.frame.origin.y-25, self.avatar.frame.size.width, self.avatar.frame.size.height);
        }completion:^(BOOL finished) {
            self.nameLabel.hidden = false;
            [UIView animateWithDuration:0.0 animations:^{
                self.nameLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y - 40, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height);
            }completion:^(BOOL finished){
                [self performSegueWithIdentifier:@"mainview" sender:nil];
            }];
        }];
    }
    else{
        [self performSegueWithIdentifier:@"tutorial" sender:nil];
    }
}

@end
