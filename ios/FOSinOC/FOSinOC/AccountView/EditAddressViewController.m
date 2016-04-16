//
//  EditAddressViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/16.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "EditAddressViewController.h"

@interface EditAddressViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (strong,nonatomic)UITapGestureRecognizer *tapGesture;
@property (strong,nonatomic)Account *myAccout;

@end

@implementation EditAddressViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.isEditing = false;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.deleteButton.layer.cornerRadius = 5.0;
    if (self.isEditing) {
        self.deleteButton.hidden = false;
        self.deleteButton.enabled = true;
        self.name.text = self.passName;
        self.phone.text = self.passPhone;
        self.address.text = self.passAddress;
    }else{
        self.deleteButton.hidden = true;
        self.deleteButton.enabled = false;
    }
    
    self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    self.myAccout = [Account sharedManager];
    self.myAccout.delegate = nil;
}

-(void)dismissKeyboard{
    [self.name resignFirstResponder];
    [self.phone resignFirstResponder];
    [self.address resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButton:(id)sender {
    [self dismissWithAnimation];
}

-(void)dismissWithAnimation{
    CATransition *transition = [CATransition new];
    transition.duration = 0.35;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromLeft;
    
    UIWindow *containerWindow = self.view.window;
    [containerWindow.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:false completion:nil];
}

- (IBAction)cancelButton:(id)sender {
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)deleteButton:(id)sender {
    if (self.name.text != nil && ![self.name.text isEqualToString:@""] && self.address.text != nil &&
        ![self.address.text isEqualToString:@""] && self.phone.text != nil && ![self.phone.text isEqualToString:@""]) {
        NSDictionary *address = @{@"name":self.name.text,@"address":self.address.text,@"phone":self.phone.text,@"type":@"1",@"_id":self.passAddrId};
        [self.myAccout address:DELETE withAddress:address];
        [self dismissWithAnimation];
    }

}
- (IBAction)addAddressButton:(id)sender {
    if (self.isEditing) {
        if (self.name.text != nil && ![self.name.text isEqualToString:@""] && self.address.text != nil &&
            ![self.address.text isEqualToString:@""] && self.phone.text != nil && ![self.phone.text isEqualToString:@""] && self.passAddrId != nil) {
            NSDictionary *address = @{@"name":self.name.text,@"address":self.address.text,@"phone":self.phone.text,@"type":@"1",@"_id":self.passAddrId};
            [self.myAccout address:POST withAddress:address];
            [self dismissWithAnimation];
        }
    }
    else{
        if (self.name.text != nil && ![self.name.text isEqualToString:@""] && self.address.text != nil &&
            ![self.address.text isEqualToString:@""] && self.phone.text != nil && ![self.phone.text isEqualToString:@""]) {
            NSDictionary *address = @{@"name":self.name.text,@"address":self.address.text,@"phone":self.phone.text,@"type":@"1"};
            [self.myAccout address:PUT withAddress:address];
            [self dismissWithAnimation];
        }

    }
    
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
