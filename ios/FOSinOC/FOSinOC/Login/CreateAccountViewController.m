//
//  CreateAccountViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/11.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "CreateAccountViewController.h"
#import "SSKeychain/SSKeychain.h"

@interface CreateAccountViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (strong,nonatomic) Account *myAccount;
@property (weak, nonatomic) IBOutlet UIButton *termsofService;
@property (weak, nonatomic) IBOutlet UIButton *privacyPolicy;

@end

@implementation CreateAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.email.delegate = self;
    self.password.delegate = self;
    self.phone.delegate = self;
    self.name.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    self.myAccount = [Account sharedManager];
    self.myAccount.delegate = self;
    
    self.name.layer.borderColor = [[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]CGColor];
    self.email.layer.borderColor = [[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]CGColor];
    self.phone.layer.borderColor = [[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]CGColor];
    self.password.layer.borderColor = [[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]CGColor];
    self.termsofService.titleLabel.attributedText = [[NSAttributedString alloc]initWithString:self.termsofService.currentTitle attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
    self.privacyPolicy.titleLabel.attributedText = [[NSAttributedString alloc]initWithString:self.privacyPolicy.currentTitle attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)dismissKeyboard{
    [self.email resignFirstResponder];
    [self.password resignFirstResponder];
    [self.name resignFirstResponder];
    [self.phone resignFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)createAccount:(id)sender {
    if(![self.name.text  isEqual: @""] && ![self.password.text  isEqual: @""] && ![self.email.text  isEqual: @""] && ![self.phone.text  isEqual: @""]){
        self.myAccount.email = self.email.text;
        self.myAccount.password = self.password.text;
        self.myAccount.name = self.name.text;
        self.myAccount.phone = self.phone.text;
        
        [self.myAccount createAccount:self.myAccount];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Please enter email and password!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)finishCreateAccount:(NSDictionary *)result withAccount:(Account *)myAccount{
    if ([[result valueForKey:@"success"]boolValue] == YES) {
        [SSKeychain setPassword:self.password.text forService:self.myAccount.serviceName account:self.myAccount.servicePassword];
        [SSKeychain setPassword:self.email.text forService:self.myAccount.serviceName account:self.myAccount.serviceAccount];
        
        
        if ([result valueForKey:@"token"] != nil){
            //NSLog(@"%@",[result valueForKey:@"token"]);
            [SSKeychain setPassword:[result valueForKey:@"token"] forService:self.myAccount.serviceName account:self.myAccount.serviceToken];
        }
        
        
        //NSLog(@"%@",result);
        [self performSegueWithIdentifier:@"mainview" sender:nil];
    }else{
        //NSLog(@"create account failed");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Login failed!" message:@"Email or password error!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        });
    }

}

@end
