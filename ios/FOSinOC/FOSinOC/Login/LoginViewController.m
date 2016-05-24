//
//  LoginViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/9.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "LoginViewController.h"

#import "SSKeychain/SSKeychain.h"
@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet NSObject *dimissButton;
@property (weak, nonatomic) IBOutlet UIButton *btnForgetPw;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (strong,nonatomic) Account *myAccount;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureLayout];
    self.userName.delegate = self;
    self.password.delegate = self;
    self.myAccount = [Account sharedManager];
    self.myAccount.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.myAccount.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)configureLayout{
    self.userName.layer.borderWidth = 1.0;
    self.password.layer.borderWidth = 1.0;
    self.userName.layer.borderColor = [[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]CGColor];
    self.password.layer.borderColor = [[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]CGColor];
    self.btnRegister.layer.borderWidth = 1.0;
    self.btnRegister.layer.borderColor = [[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1]CGColor];
    self.btnRegister.layer.cornerRadius = 4.0;
    
}

- (IBAction)dismissButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)loginButtonClicked:(id)sender {
    // test
    //[self performSegueWithIdentifier:@"mainview" sender:nil];
    if(![self.userName.text  isEqual: @""] && ![self.password.text  isEqual: @""]){
        self.myAccount.email = self.userName.text;
        self.myAccount.password = self.password.text;
        [self.myAccount login:self.myAccount];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Please enter email and password!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }

//    NSString *password = [SSKeychain passwordForService:self.myAccount.serviceName account:self.userName.text];
//    NSArray *userName = [SSKeychain accountsForService:self.myAccount.serviceName];
    //NSLog(@"userName=",@"%@",@"/npassword",@"%",password);
//    NSDictionary *dict = [userName objectAtIndex:0];
//    NSString *userName = [dict valueForKey:"acct"];
    //NSLog(@"password = %@", [dict valueForKey:@"acct"]);
}

-(void)dismissKeyboard{
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)finishFetchAccountData:(NSDictionary *)result withAccount:(Account *)myAccount{
   
    //BOOL success = [result valueForKey:@"success"];
    //NSLog([[[result valueForKey:@"success"] class] description]);
    
    if ([[result valueForKey:@"success"]boolValue] == YES) {
        
        [SSKeychain setPassword:self.password.text forService:self.myAccount.serviceName account:self.myAccount.servicePassword];
        [SSKeychain setPassword:self.userName.text forService:self.myAccount.serviceName account:self.myAccount.serviceAccount];
        
        if ([result valueForKey:@"token"] != nil){
           // NSLog(@"%@",[result valueForKey:@"token"]);
            [SSKeychain setPassword:[result valueForKey:@"token"] forService:self.myAccount.serviceName account:self.myAccount.serviceToken];
        }

        [self performSegueWithIdentifier:@"mainview" sender:nil];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Login failed!" message:@"Email or password error!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        });
    }
    return true;
}

@end
