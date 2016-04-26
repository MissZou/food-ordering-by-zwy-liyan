//
//  SearchShopViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/26.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "SearchShopViewController.h"

@interface SearchShopViewController ()<UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate>
@property (strong, nonatomic)  UISearchBar *searchbar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;

@end

@implementation SearchShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.dismissButton setBackgroundColor:[UIColor colorWithRed:69/255.0 green:83/255.0 blue:153/255.0 alpha:1]];
    
    self.searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(self.dismissButton.frame.size.width, 20, self.view.frame.size.width - self.dismissButton.frame.size.width, 44)];
    self.searchbar.barTintColor = [UIColor colorWithRed:69/255.0 green:83/255.0 blue:153/255.0 alpha:1];
    self.searchbar.delegate = self;
    self.searchbar.backgroundColor = [UIColor clearColor];
    self.searchbar.translucent = NO;
    for (UIView *view in self.searchbar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]){
            [view removeFromSuperview];
            break;
        }
    }
    
    [self.view addSubview:self.searchbar];
    
    //self.tableView.frame = CGRectMake(0, 64,self.view.frame.size.width , 200);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    CATransition *transition = [CATransition new];
    transition.duration = 0.35;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromLeft;
    
    UIWindow *containerWindow = self.view.window;
    [containerWindow.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:false completion:nil];}

- (IBAction)dismissButton:(id)sender {
    CATransition *transition = [CATransition new];
    transition.duration = 0.35;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromLeft;
    
    UIWindow *containerWindow = self.view.window;
    [containerWindow.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:false completion:nil];}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = @"shop";
    return cell;
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
