//
//  MainViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/12.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnCart;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.shadowOpacity = 0.8;
    self.topView.layer.shadowOpacity = 0.8;
    self.topView.layer.shadowOffset = CGSizeMake(2.0, 0.0);
    self.bottomView.layer.shadowOpacity = 0.8;
    self.bottomView.layer.shadowOffset = CGSizeMake(2.0, 0.0);

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)menuButton:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"toggleMenu" object:nil];
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
