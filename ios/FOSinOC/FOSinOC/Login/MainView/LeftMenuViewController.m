//
//  LeftMenuViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/12.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "LeftMenuViewController.h"

@interface LeftMenuViewController ()
@property (weak, nonatomic) IBOutlet UIButton *greenButton;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.greenButton.layer.shadowOpacity = 0.2;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)greenButtonClicked:(id)sender {
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
