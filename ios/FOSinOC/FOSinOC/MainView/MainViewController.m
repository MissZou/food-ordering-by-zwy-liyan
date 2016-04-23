//
//  MainViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/12.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "MainViewController.h"
#import "Account.h"
@interface MainViewController ()
@property(strong,nonatomic) Account *myAccount;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnCart;
@property (weak, nonatomic) IBOutlet UIButton *dropDownLocatonSender;

@property (weak, nonatomic) IBOutlet UITableView *mainViewTableView;
@property (weak, nonatomic) IBOutlet UIView *scrollHeadView;



//property for dropDownView
@property (strong,nonatomic)UITapGestureRecognizer *tapToCloseDropDown;
@property (strong,nonatomic)UIBlurEffect *blurEffet;
@property (strong,nonatomic)UIVisualEffectView *blurEffectView;


@property CGFloat cellHeight;
@property (strong,nonatomic) DropDownView *dropDownLocation;

//property for searchbar view
@property (strong,nonatomic)UIVisualEffectView *blurEffectViewForSearch;
@property (strong,nonatomic)UISearchController *searchController;
@property (strong,nonatomic)UITableView *searchTableView;
@property (strong,nonatomic)UITapGestureRecognizer *tapToCloseSearchController;

//delegate and datasource in other controller
@property (strong,nonatomic) SearchViewHelpController *searchViewHelpController;

//mainViewTalbeView
@property (copy,nonatomic) NSString *textLabel;
@property(strong,nonatomic) NSArray *catagory;
@property(weak,nonatomic) UIScrollView *catagoryScrollView;

@property (strong,nonatomic)UIView *coverView;
@property (strong,nonatomic)CatagoryView *catagoryView;
@property (strong,nonatomic)UITapGestureRecognizer *tapToCloseMainViewMenu;
//@property(strong,nonatomic) SlideButtonView *slideButtonView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myAccount = [Account sharedManager];
    self.myAccount.delegate = nil;
    [self.myAccount checkLogin];
    self.searchViewHelpController = [[SearchViewHelpController alloc]init];
    self.searchViewHelpController.delegate = self;
    self.mainViewTableView.delegate = self;
    self.mainViewTableView.dataSource = self;
    
    self.cellHeight = 40;
    
    self.view.layer.shadowOpacity = 0.8;

    self.bottomView.layer.shadowOpacity = 0.8;
    self.bottomView.layer.shadowOffset = CGSizeMake(2.0, 0.0);
    
    //init for dropDownView
    self.blurEffet = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:self.blurEffet];
    self.tapToCloseDropDown = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDropDownView)];
    [self.blurEffectView addGestureRecognizer:self.tapToCloseDropDown];
    
    //init for searchController
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    
    self.definesPresentationContext = true;
    self.searchController.dimsBackgroundDuringPresentation = false;
    self.blurEffectViewForSearch = [[UIVisualEffectView alloc] initWithEffect:self.blurEffet];
    self.tapToCloseSearchController = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchBarCancelButtonClicked)];
    
    //slide button

    self.catagory = @[@"MAIN DISHES",@"SIDS",@"DESSERTS",@"BRESKFAST",@"DRINKS",@"EXTRAS"];
    //self.slideButtonView = [[SlideButtonView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    //    [self.slideButtonView addTitle:self.catagory];
    //    self.slideButtonView.delegate = self;

    self.tapToCloseMainViewMenu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMainViewMenu)];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGFloat dummyViewHeight = 40;
    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mainViewTableView.bounds.size.width, dummyViewHeight)];
    self.mainViewTableView.tableHeaderView = dummyView;
    self.mainViewTableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0);
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)menuButton:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"toggleMenu" object:nil];
}
- (IBAction)chooseLocationBtn:(id)sender {
    [self.myAccount checkLogin];
    NSMutableArray *locations = [self.myAccount.location mutableCopy];
    [locations insertObject:@"New location" atIndex:0];
    
    if (self.dropDownLocation == nil) {
        CGFloat dropDownFrameHeight = self.cellHeight * (CGFloat)locations.count;
        self.dropDownLocation = [DropDownView initDropDownView:self.dropDownLocatonSender cellHeight:self.cellHeight viewHeight:dropDownFrameHeight Array:locations];
        self.dropDownLocation.delegate = self;
        self.blurEffectView.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + self.topView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.topView.frame.size.height);
        [self.view addSubview:self.blurEffectView];
        [self.view addGestureRecognizer:self.tapToCloseDropDown];
    } else{
        [self.dropDownLocation hideDropDownView];
        self.dropDownLocation = nil;
        [self.blurEffectView removeFromSuperview];
        [self.view removeGestureRecognizer:self.tapToCloseDropDown];
    }
}

-(void)hideDropDownView{
    [self.dropDownLocation hideDropDownView];
    self.dropDownLocation = nil;
    [self.blurEffectView removeFromSuperview];
    [self.view removeGestureRecognizer:self.tapToCloseDropDown];

}

#pragma mark - DropDowView Delegate

-(void)dropDownMenuClicked:(DropDownView *)sender{
    [self.blurEffectView removeFromSuperview];
    if ([sender.choosedString isEqualToString:@"New location"]) {
        [self doSearch];
    }else{
        //NSLog(@"%@",sender.choosedString);
    }
    NSLog(@"you choose %@",sender.choosedString);
    self.dropDownLocation = nil;
}

-(void)dropDownMenuDelete:(DropDownView *)sender withString:(NSString *)string{
    //delete method
    [self.myAccount location:DELETE withLocation:string];
    self.dropDownLocation.dropDownTableView.frame = CGRectMake(0, 0, self.dropDownLocatonSender.superview.frame.size.width, self.cellHeight * (CGFloat)self.myAccount.location.count);
    [self.dropDownLocatonSender setTitle:@"Choose location ▾" forState:UIControlStateNormal];
}

#pragma mark - searchController 

-(void)doSearch{
    [self initSearchTableView];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchTableView removeFromSuperview];
    [self.blurEffectViewForSearch removeFromSuperview];
    [self.searchController.searchBar removeFromSuperview];
    
    
}

-(void)searchBarCancelButtonClicked{
    [self.searchTableView removeFromSuperview];
    [self.blurEffectViewForSearch removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) updateSearchResultsForSearchController:(UISearchController *)searchController{
    
}

#pragma mark - searchTableView

-(void)initSearchTableView{
    
    self.searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.topView.frame.size.height+20, self.view.frame.size.width, 2*self.cellHeight*1.5)];// 2 is results number
    self.blurEffectViewForSearch.frame = CGRectMake(self.view.bounds.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    //self.blurEffectViewForSearch.userInteractionEnabled = NO;
    [self.blurEffectViewForSearch addGestureRecognizer:self.tapToCloseSearchController];
    [self.searchTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"searchTableCell"];
    self.searchTableView.delegate = self.searchViewHelpController;
    self.searchTableView.dataSource = self.searchViewHelpController;

    //self.searchTableView.allowsSelection = YES;
    
    
    [self presentViewController:self.searchController animated:YES completion:^{
        [self.view addSubview:self.blurEffectViewForSearch];
        [self.searchController.view addSubview:self.searchTableView];
    }];
    
}

#pragma mark - searchTableView delegate & datasource

-(void)finishSearchWithResult:(NSString *)result{
    NSLog(@"search result %@",result);
    self.textLabel = result;
    [self.mainViewTableView reloadData];
    [self searchBarCancelButtonClicked];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.catagory.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (self.textLabel!=nil) {
        cell.shopName.text = self.textLabel;
    }
    else
    cell.shopName.text = @"muc fooooood";
    
    UIView *bgColorView = [UIView new];
    bgColorView.backgroundColor = [UIColor colorWithRed:121/255.0 green:146/255.0 blue:199/255.0 alpha:1];
    [cell setSelectedBackgroundView:bgColorView];
    cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewRowActionStyleDefault) {
        //NSLog(@"UITableViewRowActionStyleDefault");
        // Delete the row from the data source
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = @"Favorite";
    return title;
}
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Favorite" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
    
                                        NSLog(@"Favorite");
                                    }];
    button.backgroundColor = [UIColor redColor]; //arbitrary color
    UITableViewRowAction *button2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Button 2" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                     {
                                         
                                         NSLog(@"Action to perform with Button2!");
                                     }];
    button2.backgroundColor = [UIColor grayColor]; //arbitrary color
    
    return @[button, button2]; //array with all the buttons you want. 1,2,3, etc...
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //self.mainViewTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:18];
    //[label setFont:[UIFont boldSystemFontOfSize:12]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1];
    NSString *string =[self.catagory objectAtIndex:section];
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    
    [view setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
    return view;
}

#pragma mark -- scroll button for table view

//-(void)slideButtionClicked:(NSString *)title{
//    NSInteger setcion = [self.catagory indexOfObject:title];
//   NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:setcion];
//    [self.mainViewTableView scrollToRowAtIndexPath:indexPath
//                     atScrollPosition:UITableViewScrollPositionTop
//                             animated:YES];
//}

#pragma mark -- scroll button for table view change button marked when scrolling

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSIndexPath *firstVisibleIndexPath = [[self.mainViewTableView indexPathsForVisibleRows] objectAtIndex:0];
//    NSInteger section = firstVisibleIndexPath.section;
//    [self.slideButtonView markButtonSelected:section];
//}
- (IBAction)catagoryClicked:(id)sender {
    NSLog(@"catagory clicked");
    NSDictionary *fastFood = @{@"All":@246,@"Famous Brand":@128,@"Over Rice":@115,@"Noodes":@27,@"Pot Food":@24,@"Dumplings":@12};
    NSDictionary *feature = @{@"All":@138,@"Sea Food":@58,@"Sichuan":@37,@"Toast Fish":@27,@"Guangdong":@14,@"Muslim":@12};
    NSDictionary *foreigner = @{@"All":@43,@"Korea":@25,@"Japan":@13,@"West":@8,@"Spaghetti":@1};
    NSDictionary *dessert = @{@"All":@172,@"Local":@53,@"Barbeque":@44,@"Sids":@43};
    NSDictionary *drink = @{@"All":@84,@"Juice":@53,@"Cafee":@31};
    NSDictionary *catagory2 = @{@"All Shop":@500,@"fastFood":fastFood,@"feature":feature,@"foreigner":foreigner,@"dessert":dessert,@"drink":drink};
    
    NSLog(@"%@",catagory2);
    
    
    
    if (self.coverView == nil && self.catagoryView == nil) {
        self.coverView = [[UIView alloc]initWithFrame:CGRectMake(0, self.scrollHeadView.frame.size.height + self.scrollHeadView.frame.origin.y, self.view.frame.size.width, self.mainViewTableView.frame.size.height)];
        CatagoryView *catagoryView = [[CatagoryView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.coverView.frame.size.height*0.6)];
        self.catagoryView = catagoryView;
        [self.catagoryView initCatagoryView:catagory2];
        
        [self.view addSubview:self.coverView];
        [self.coverView addSubview:self.catagoryView];
        [self.coverView addGestureRecognizer:self.tapToCloseMainViewMenu];
    }
}
- (IBAction)SortClicked:(id)sender {
    
}
- (IBAction)filterClicked:(id)sender {
}

-(void)hideMainViewMenu{
    [self.coverView removeFromSuperview];
    self.coverView = nil;
    self.catagoryView = nil;
    
}

//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    return true;
//}

@end
