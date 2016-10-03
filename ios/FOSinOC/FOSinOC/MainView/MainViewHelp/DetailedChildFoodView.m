//
//  DetailedChildFoodView.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/26.
//  Copyright © 2016年 李龑. All rights reserved.
//

#define catagoryTalbeWidth 80
#define slideTitleHeight 40
#define navigationBarHeight 64
#define segmentHeight 100
#define cartViewHeight 50
#define categoryCellHeight 60
#define foodCellHeight 90
#define foodCellPicHeight 65

#define tableCellTag 1460
#define myBlueColor [UIColor colorWithRed:69/255.0 green:83/255.0 blue:153/255.0 alpha:1]
#define myCategoryColor [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]
#define myGreenColor [UIColor colorWithRed:91/255.0 green:207/255.0 blue:122/255.0 alpha:1]
#define myGreenColorHighlight [UIColor colorWithRed:76/255.0 green:134/255.0 blue:91/255.0 alpha:1]
#define myBlackColor [UIColor colorWithRed:61/255.0 green:61/255.0 blue:61/255.0 alpha:1]
#define myRedColor [UIColor colorWithRed:213/255.0 green:64/255.0 blue:58/255.0 alpha:1]

#import "DetailedChildFoodView.h"
#import "Shop.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Account.h"
#import "ThrowLineTool.h"
#import "CartTableView.h"


@interface DetailedChildFoodView ()<UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate,AccountDelegate,ThrowLineToolDelegate,UIGestureRecognizerDelegate, CartTableViewDelegate>
@property(strong,nonatomic) UITableView *catagoryTable;
@property(strong,nonatomic) UITableView *foodTable;
@property(strong,nonatomic) UIImageView *categoryMarkView;
@property(strong,nonatomic) Shop *myShop;
@property(strong,nonatomic) Account *myAccount;

//@property(strong,nonatomic)UIView *cartView;

@property(assign,nonatomic)NSInteger lastSelectSection;
@property(assign,nonatomic)BOOL isSelectCatagory;
@property(assign, nonatomic)BOOL isLastCatagorySelected;
@property(assign,nonatomic)BOOL isSendContinueScrolling;
@property(assign,nonatomic)CGFloat maxOffset;
@property(assign,nonatomic)CGFloat minOffset;
@property(assign,nonatomic)CGFloat didSelectCatogoryFoodTableYRecord;
@property(assign,nonatomic)BOOL isScrollAtBottom;

@property(strong,nonatomic) UIPanGestureRecognizer *assistantGesture;
@property(assign,nonatomic) BOOL assistantGestureBegin;
@property(assign,nonatomic) CGPoint tempTranslatedPoint;
@property(assign,nonatomic) BOOL gestureStateBegin;
@property(assign,nonatomic) BOOL isSuperViewGustureStart;

@property(assign,nonatomic) CGFloat foodTableViewScrollOffset;
@property(assign,nonatomic)CGFloat slideViewFrameY;

//cart view
@property(strong,nonatomic) UIButton *buyButton;
@property(strong,nonatomic) UIButton *cartButton;
@property(strong,nonatomic) UILabel *cartBadge;
@property(strong,nonatomic) UILabel *totalPriceLabel;


@property(strong,nonatomic) UIView *parabolaView;
@property(assign,nonatomic) NSUInteger totalItemCount;
@property(assign,nonatomic) NSUInteger totalPrice;

@property(strong,nonatomic) UIBlurEffect *blurEffet;
@property(strong,nonatomic) UIVisualEffectView *blurEffectView;
@property(strong,nonatomic) UITapGestureRecognizer *tapGesture;
@property(strong,nonatomic) UITapGestureRecognizer *tapGesture2;

@property(strong,nonatomic) CartTableView *cartTableView;


@end

@implementation DetailedChildFoodView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myShop = [Shop sharedManager];
    self.myAccount = [Account sharedManager];
    
    [self initTableViews];
    [self initCartView];
    
    //notifications for table view behavior
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(triggerNotificationAction:) name:@"enableInteractionFood" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(superViewGustureState:) name:@"superViewGustureState" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slideViewFrameY:) name:@"slideViewFrameY" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopFinishFetchDataNotify) name:@"shopFinishFetchData" object:nil];
    // temporarily disable scroll
    //[self.foodTable setScrollEnabled:false];
    
    //assistantGuseture to pull down the tableview when it's stick to the top
    self.assistantGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(assistantScrollGesture:)];
    self.assistantGesture.delegate = self;
    [self.view addGestureRecognizer:self.assistantGesture];
    [self.assistantGesture setEnabled:false];
    self.assistantGestureBegin = false;
    //self.myAccount.delegate = self;
    //[self.myAccount cart:GET withShopId:nil  itemId:nil amount:nil  cartId:nil index:1 count:30];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewDidAppear:(BOOL)animated{
    
//    self.foodTable.frame = CGRectMake(catagoryTalbeWidth, 0, self.view.frame.size.width - catagoryTalbeWidth, self.view.frame.size.height  - navigationBarHeight - segmentHeight-cartViewHeight);
    //self.catagoryTable.frame = CGRectMake(0, 0,catagoryTalbeWidth, self.view.frame.size.height- navigationBarHeight - segmentHeight-cartViewHeight);
    self.maxOffset = 0;
    self.isSuperViewGustureStart = false;
    self.isScrollAtBottom = false;
    self.myAccount.delegate = self;
    [self.myAccount cart:GET withShopId:nil  itemId:nil amount:nil  cartId:nil index:1 count:30];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.myAccount.delegate = nil   ;
}

-(void)disableInteraction{
//    NSLog(@"Disable Interaction");
    [self.foodTable setScrollEnabled:false];
    //[self.assistantGesture setEnabled:false];
    //self.catagoryTable.userInteractionEnabled =false;
    self.didSelectCatogoryFoodTableYRecord = 0;
    self.maxOffset = 0;
    //self.minOffset = 0;
}

-(void)enableInteraction{
  //  NSLog(@"Enable Interaction");
    //[self.assistantGesture setEnabled:true];
    self.maxOffset = 0;
    self.minOffset = 0;
    [self.foodTable setScrollEnabled:true];
    self.isSendContinueScrolling = false;
    //self.didSelectCatogoryFoodTableYRecord = 0;
    self.myAccount.delegate = self;
}

-(void)initTableViews{
    self.lastSelectSection = -1;
    
    //self.catagoryTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, catagoryTalbeWidth, self.view.frame.size.height - segmentHeight + slideTitleHeight) style:UITableViewStylePlain];
    self.catagoryTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, catagoryTalbeWidth, self.view.frame.size.height  - navigationBarHeight -slideTitleHeight - segmentHeight-cartViewHeight) style:UITableViewStylePlain];
    [self.catagoryTable registerClass:[UITableViewCell self] forCellReuseIdentifier:@"catagoryCell"];
    self.catagoryTable.delegate = self;
    self.catagoryTable.dataSource = self;
    self.catagoryTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.catagoryTable.cellLayoutMarginsFollowReadableWidth = false;
    //self.catagoryTable.layoutMargins=UIEdgeInsetsZero;
    //self.catagoryTable.preservesSuperviewLayoutMargins = false;
    self.catagoryTable.backgroundColor = myCategoryColor;
    [self.view addSubview:self.catagoryTable];
    //self.foodTable = [[UITableView alloc]initWithFrame:CGRectMake(catagoryTalbeWidth, 0, self.view.frame.size.width - catagoryTalbeWidth, self.view.frame.size.height- segmentHeight + slideTitleHeight ) style:UITableViewStylePlain];
    self.foodTable = [[UITableView alloc]initWithFrame:CGRectMake(catagoryTalbeWidth, 0, self.view.frame.size.width - catagoryTalbeWidth, self.view.frame.size.height-  navigationBarHeight -slideTitleHeight - segmentHeight-cartViewHeight) style:UITableViewStylePlain];
    [self.foodTable registerClass:[UITableViewCell self] forCellReuseIdentifier:@"foodCell"];
    self.foodTable.cellLayoutMarginsFollowReadableWidth = false;
    self.foodTable.delegate = self;
    self.foodTable.dataSource = self;
    

    [self.view addSubview:self.foodTable];
    
}

-(void)initCartView{
    //self.view.frame.size.height - cartViewHeight
    self.cartView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - navigationBarHeight-segmentHeight-slideTitleHeight-cartViewHeight, self.view.frame.size.width, cartViewHeight)];
    self.cartView.backgroundColor = myBlackColor;
//    
//    self.cartView.opaque = false;
//    self.cartView.alpha = 0.7;
//    
    self.buyButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 120, 0, 120, cartViewHeight)];
    //[self.buyButton setBackgroundColor:myGreenColor];
    [self.buyButton setBackgroundColor: [UIColor grayColor]];
    [self.buyButton setEnabled:false];
    [self.buyButton setTitle:@"CHECKOUT" forState:UIControlStateNormal];
    [self.buyButton addTarget:self action:@selector(buyButtonHandle) forControlEvents:UIControlEventTouchUpInside];
    [self.buyButton addTarget:self action:@selector(buyButtonHighlight) forControlEvents:UIControlEventTouchDown];
    self.buyButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    [self.cartView addSubview:self.buyButton];
    
    self.cartButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
    [self.cartButton setImage:[UIImage imageNamed:@"cart.png"] forState:UIControlStateNormal];
    self.cartButton.imageView.clipsToBounds = true;
    self.cartButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.cartButton setBackgroundColor:myBlackColor];
    [self.cartButton addTarget:self action:@selector(cartButtonHandle) forControlEvents:UIControlEventTouchUpInside];
    [self.cartView addSubview:self.cartButton];
    
    self.cartBadge = [[UILabel alloc]initWithFrame:CGRectMake(40, 2, 17, 17)];
    self.cartBadge.layer.cornerRadius = 8;
    self.cartBadge.layer.masksToBounds = true;
    self.cartBadge.backgroundColor = myRedColor;
    self.cartBadge.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    self.cartBadge.textAlignment = NSTextAlignmentCenter;
    self.cartBadge.textColor = [UIColor whiteColor];
    [self.cartView addSubview:self.cartBadge];
    
    self.totalPriceLabel = [[UILabel alloc]init];
    self.totalPriceLabel.numberOfLines = 0;
    self.totalPriceLabel.text = @"The totaol price:\n      $ 0";
    self.totalPriceLabel.textColor = [UIColor whiteColor];
    self.totalPriceLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    CGSize labelSize = [self.totalPriceLabel.text sizeWithAttributes:@{NSFontAttributeName:self.totalPriceLabel.font}];
    self.totalPriceLabel.frame = CGRectMake(80, 5, 100, labelSize.height);
    [self.cartView addSubview:self.totalPriceLabel];
    //self.parabolaView = [[UIView alloc]initWithFrame:CGRectMake(self.foodTable.frame.size.width - 50, foodCellHeight-30, 20, 20 )];
    self.parabolaView = [[UIView alloc]init];
    self.parabolaView.backgroundColor = myBlueColor;
    self.parabolaView.layer.cornerRadius = 10;
    self.parabolaView.alpha = 0.5;
    [ThrowLineTool sharedTool].delegate = self;
    
    [self.view addSubview:self.cartView];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.catagoryTable) {
        return 1;
    } else  {
        return self.itemList.count;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.catagoryTable) {
        return [self.itemList allKeys].count;
    } else{
        NSArray *foods = [self.itemList valueForKey: self.catagory[section]];
        return foods.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.catagoryTable) {
        return categoryCellHeight;
    } else{
        return foodCellHeight;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.catagoryTable) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"catagoryCell" forIndexPath:indexPath];
        
        
        cell.textLabel.text = self.catagory[indexPath.row];
        cell.contentView.backgroundColor = myCategoryColor;
        cell.textLabel.backgroundColor = myCategoryColor;
        cell.textLabel.font =[UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        cell.textLabel.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0];
        
        //UIImageView *separateLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, categoryCellHeight, self.catagoryTable.frame.size.width, 0.1)];
        //separateLine.image = [UIImage imageNamed:@"separateLine.png"];
        //separateLine.contentMode = UIViewContentModeScaleAspectFill;
        //[cell.contentView addSubview:separateLine];
        
        return cell;

    } else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"foodCell" forIndexPath:indexPath];
        NSArray *food = [self.itemList valueForKey:self.catagory[indexPath.section]];
        
        if ([cell.contentView subviews].count == 0) {
        //if (cell == nil) {
        
            UILabel *dishName = [[UILabel alloc]initWithFrame:CGRectMake(75, 0, self.foodTable.frame.size.width - foodCellPicHeight, 30)];
            dishName.text = [food[indexPath.row] valueForKey:@"dishName"];
            dishName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
            dishName.tag = tableCellTag+1;
            
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, foodCellPicHeight, foodCellPicHeight)];
            imageView.clipsToBounds = true;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [imageView sd_setImageWithURL:[NSURL URLWithString:[food[indexPath.row] valueForKey:@"dishPic"]] placeholderImage:[UIImage imageNamed:@"favoriteGreen.png"]];
            imageView.tag = tableCellTag+2;
            
            UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(75, foodCellHeight-30, self.foodTable.frame.size.width - foodCellPicHeight, 30)];
            //price.text =[[food[indexPath.row] valueForKey:@"price"] stringValue];
            price.text = [NSString stringWithFormat:@"%@%@",@"$: ",[[food[indexPath.row] valueForKey:@"price"] stringValue]];
            price.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
            price.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
            price.tag = tableCellTag+3;
            
            UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(self.foodTable.frame.size.width - 30, foodCellHeight-30, 20, 20 )];
            [addButton setImage:[UIImage imageNamed:@"plusBlue.png"] forState:UIControlStateNormal];
            //addButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
            addButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
            addButton.imageView.clipsToBounds = true;
            addButton.layer.cornerRadius = 2;
            addButton.layer.masksToBounds = true;
            [addButton addTarget:self action:@selector(addButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
            //addButton.backgroundColor = myBlueColor;
            addButton.tag = tableCellTag+4;
            
            UILabel *amount = [[UILabel alloc]initWithFrame:CGRectMake(self.foodTable.frame.size.width - 30, foodCellHeight-30, 20, 20 )];
            amount.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
            amount.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
            amount.textAlignment = NSTextAlignmentCenter;

            amount.tag = tableCellTag + 5;
            
            UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(self.foodTable.frame.size.width - 30, foodCellHeight-30, 20, 20 )];
            [deleteButton setImage:[UIImage imageNamed:@"minusBlue.png"] forState:UIControlStateNormal];
            deleteButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
            deleteButton.imageView.clipsToBounds = true;
            //deleteButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
            deleteButton.layer.cornerRadius = 2;
            deleteButton.layer.masksToBounds = true;
            [deleteButton addTarget:self action:@selector(deleteButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
            
            //deleteButton.backgroundColor = myBlueColor;
            deleteButton.tag = tableCellTag+6;
            
            
            for (int i=0; i<self.myAccount.cartDetail.count; i++) {
                if ([[food[indexPath.row] valueForKey:@"_id"] isEqualToString:[self.myAccount.cartDetail[i] valueForKey:@"_id"]]) {
                    amount.text = [[self.myAccount.cartDetail[i] valueForKey:@"amount"] stringValue];
                    if ([[self.myAccount.cartDetail[i] valueForKey:@"amount"] integerValue] != 0) {
                        deleteButton.frame = CGRectMake(self.foodTable.frame.size.width - 70, foodCellHeight-30, 20, 20 );
                        amount.frame = CGRectMake(self.foodTable.frame.size.width - 50, foodCellHeight-30, 20, 20 );
                    }
                }
            }
            
            
            [cell.contentView addSubview:dishName];
            [cell.contentView addSubview:imageView];
            [cell.contentView addSubview:price];
            
            [cell.contentView addSubview:amount];
            [cell.contentView addSubview:deleteButton];
            [cell.contentView addSubview:addButton];
            return cell;
        }else{
            
            UILabel *dishName = (UILabel *)[cell.contentView viewWithTag:tableCellTag+1];
            UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:tableCellTag+2];
            UILabel *price = (UILabel *)[cell.contentView viewWithTag:tableCellTag+3];
            UIButton *addButton = (UIButton *)[cell.contentView viewWithTag:tableCellTag+4];
            UILabel *amount = (UILabel *)[cell.contentView viewWithTag:tableCellTag+5];
            UIButton *deleteButton = (UIButton *)[cell.contentView viewWithTag:tableCellTag+6];
            dishName.text = [food[indexPath.row] valueForKey:@"dishName"];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[food[indexPath.row] valueForKey:@"dishPic"]] placeholderImage:[UIImage imageNamed:@"favoriteGreen.png"]];
            price.text = [NSString stringWithFormat:@"%@%@",@"$: ",[[food[indexPath.row] valueForKey:@"price"] stringValue]];
            [addButton addTarget:self action:@selector(addButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
            
            // error mark why add deleteButton.frame and amount.frame make the if condition work?
            deleteButton.frame = CGRectMake(self.foodTable.frame.size.width - 30, foodCellHeight-30, 20, 20 );
            amount.frame = CGRectMake(self.foodTable.frame.size.width - 30, foodCellHeight-30, 20, 20 );
            for (int i=0; i<self.myAccount.cartDetail.count; i++) {
                if ([[food[indexPath.row] valueForKey:@"_id"] isEqualToString:[self.myAccount.cartDetail[i] valueForKey:@"_id"]]) {
                    amount.text = [[self.myAccount.cartDetail[i] valueForKey:@"amount"] stringValue];
                    if ([[self.myAccount.cartDetail[i] valueForKey:@"amount"] integerValue] != 0) {
                        deleteButton.frame = CGRectMake(self.foodTable.frame.size.width - 70, foodCellHeight-30, 20, 20 );
                        amount.frame = CGRectMake(self.foodTable.frame.size.width - 50, foodCellHeight-30, 20, 20 );
                    }
                    else{
                        deleteButton.frame = CGRectMake(self.foodTable.frame.size.width - 30, foodCellHeight-30, 20, 20 );
                        amount.frame = CGRectMake(self.foodTable.frame.size.width - 30, foodCellHeight-30, 20, 20 );
                    }
                }
            }

            [deleteButton addTarget:self action:@selector(deleteButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        
        //cell.textLabel.text = [food[indexPath.row] valueForKey:@"dishName"];
        
    }
}

-(void)markClickedCatagory:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.catagoryTable cellForRowAtIndexPath:indexPath];
    if (self.categoryMarkView == nil) {
        self.categoryMarkView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 3, categoryCellHeight)];
        //self.categoryMarkView.backgroundColor = myBlueColor;
        self.categoryMarkView.image = [UIImage imageNamed:@"markViewBlue.png"];
        
        [cell.contentView addSubview:self.categoryMarkView];
    }
    [cell.contentView addSubview:self.categoryMarkView];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.catagoryTable) {
        self.isSelectCatagory = true;
        //the first row is make self.lastSelectSeciton = indexPath.row = 0, so plus one could let conditon be true
        if (self.lastSelectSection+1) {
            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.lastSelectSection inSection:0];
            UITableViewCell *cell = [self.catagoryTable cellForRowAtIndexPath:lastIndexPath];
            cell.contentView.backgroundColor = myCategoryColor;
            cell.textLabel.backgroundColor = myCategoryColor;
        }

        UITableViewCell *cell = [self.catagoryTable cellForRowAtIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor =[UIColor whiteColor];
        cell.textLabel.backgroundColor = [UIColor whiteColor];
        self.lastSelectSection = indexPath.row;
        NSInteger section = [self.catagory indexOfObject:cell.textLabel.text];
        

        
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:0 inSection:section];
        [self.foodTable scrollToRowAtIndexPath:indexPath2 atScrollPosition:UITableViewScrollPositionTop animated:YES];
        if (section +1 == self.catagory.count) {
            [self scrollViewDidEndScrollingAnimation:self.foodTable];
        }
        if (self.view.superview.frame.origin.y >64) {
            [self disableInteraction];
        }
        //[self markClickedCatagory:indexPath];
        
    } else if(tableView == self.foodTable){
        //select food
        NSArray *food = [self.itemList valueForKey:self.catagory[indexPath.section]];
        NSLog(@"%@",food[indexPath.row]);
        UITableViewCell *targetCell = [self.foodTable cellForRowAtIndexPath:indexPath];
        UIImageView *imageView = (UIImageView *)[targetCell.contentView viewWithTag:tableCellTag+2];
        [self.delegate detailedChildFoodDidSelectItem:food[indexPath.row] image:imageView.image shopId:self.myShop.shopID];
    }
    
}


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    self.isSelectCatagory = false;
    
}

-(void) triggerNotificationAction:(NSNotification *) notification
{
    if ([notification.object isKindOfClass:[NSNumber class]])
    {
        [self enableInteraction];
        NSNumber *y = [notification object];
        NSLog(@"continu to scroll child %f",[y floatValue]);
        NSLog(@"food table content offset,%f",self.foodTable.contentOffset.y);
        //if (self.foodTable.contentOffset.y<160) {
            //self.isScrollAtBottom =true;
            [self.foodTable setContentOffset:CGPointMake(0,  -[y floatValue] + self.didSelectCatogoryFoodTableYRecord)];
//        }
        
    }
    else
    {
        NSLog(@"Error, object not recognised.");
    }
}

-(void) triggerNotificationDisable:(NSNotification *) notification
{
    if ([notification.object isKindOfClass:[NSNumber class]])
    {
        //[self enableInteraction];
        NSNumber *y = [notification object];
        NSLog(@"continu to scroll child %f",[y floatValue]);
        NSLog(@"food table content offset,%f",self.foodTable.contentOffset.y);
        if (self.foodTable.contentOffset.y >=0) {
            [self.foodTable setContentOffset:CGPointMake(0,  -[y floatValue] + self.didSelectCatogoryFoodTableYRecord)];
        }
    }
    else
    {
        NSLog(@"Error, object not recognised.");
    }
}

-(void)superViewGustureState:(NSNotification *) notification{
    if ([notification.object isKindOfClass:[NSNumber class]])
    {
        NSNumber *number = [notification object];
        self.isSuperViewGustureStart = [number boolValue];
        //NSLog(self.isSuperViewGustureStart? @"isSuperViewGustureStart true":@"isSuperViewGustureStart no");
    }
}

-(void)slideViewFrameY:(NSNotification *) notification{
    if ([notification.object isKindOfClass:[NSNumber class]])
    {
        NSNumber *number = [notification object];
        self.slideViewFrameY = [number floatValue];
        if (self.slideViewFrameY < segmentHeight+navigationBarHeight) {
            [self.assistantGesture setEnabled:true];
        }
        else{
            [self.assistantGesture setEnabled:false];

        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.catagoryTable) {
        if (scrollView.contentOffset.y<=0) {

            
        }
        else{
           
        }
        
    }else if(scrollView == self.foodTable){
//        CGPoint translatedPoint = [[self.foodTable panGestureRecognizer] translationInView:self.view];
//        CGPoint velocity = [[self.foodTable panGestureRecognizer ]velocityInView:self.view];
//        NSLog(@"child food talbe offset %f",scrollView.contentOffset.y);
//        NSLog(@"shop translatedPoint y:%f",translatedPoint.y);
//        NSLog(@"speed y:%f",velocity.y);
        
        self.foodTableViewScrollOffset = scrollView.contentOffset.y;
        if (self.isSelectCatagory) {
            self.didSelectCatogoryFoodTableYRecord = scrollView.contentOffset.y;
        }
        
        /*to detect the bottom of table view */
//        CGRect bounds = scrollView.bounds;
//        CGSize size = scrollView.contentSize;
//        UIEdgeInsets inset = scrollView.contentInset;
//        float y = self.foodTableViewScrollOffset + bounds.size.height - inset.bottom;
//        float h = size.height;
//
//        
//        float reload_distance = 10;
//        if(y > h + reload_distance) {
//            NSLog(@"load more rows");
//            self.isScrollAtBottom = true;
//        }else{
//            self.isScrollAtBottom = false;
//        }
//        
        if (scrollView.contentOffset.y<=0 ) {
            // temporarily disable scroll
            //[self disableInteraction];
            //scrollview will have bounce and the contentoffset will change to opposite direction, so use a maxoffest to keep the scroll direction
            NSNumber *y;
//            NSLog(@"foodTableViewScrollOffset %f",self.foodTableViewScrollOffset);
//            NSLog(@"max offset %f",self.maxOffset);
//            NSLog(@"min offset %f",self.minOffset);
            if (self.maxOffset > scrollView.contentOffset.y) {
                
                self.maxOffset = scrollView.contentOffset.y;
                y = [NSNumber numberWithFloat:self.maxOffset];
                CGPoint velocity = [self.foodTable.panGestureRecognizer velocityInView:self.foodTable];
                NSValue *velocityInValue = [NSValue valueWithCGPoint:velocity];
                NSArray *scrollParam = [NSArray arrayWithObjects:y,velocityInValue, nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"mainContinueScrollingShop" object:scrollParam];

            }
//            if (fabs(self.minOffset) < fabs(scrollView.contentOffset.y)) {
//                
//                self.minOffset = scrollView.contentOffset.y;
//                y = [NSNumber numberWithFloat:self.minOffset];
//                //y = [NSNumber numberWithFloat:scrollView.contentOffset.y];
//                CGPoint velocity = [self.foodTable.panGestureRecognizer velocityInView:self.foodTable];
//                NSValue *velocityInValue = [NSValue valueWithCGPoint:velocity];
//                NSArray *scrollParam = [NSArray arrayWithObjects:y,velocityInValue, nil];
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"mainContinueScrollingShop" object:scrollParam];
//            }
        }
        else if(scrollView.contentOffset.y>0){
//            if (!self.isSelectCatagory) {
//            [self enableInteraction];
//            }
//            
//            self.isSendContinueScrolling = false;
//            self.foodTable.bounces = YES;
        }
        
        if ([self.foodTable indexPathsForVisibleRows].count != 0) {
            NSIndexPath *firstVisibleIndexPath = [[self.foodTable indexPathsForVisibleRows] objectAtIndex:0];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:firstVisibleIndexPath.section inSection:0];
            if (self.lastSelectSection+1) {
                NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.lastSelectSection inSection:0];
                UITableViewCell *cell = [self.catagoryTable cellForRowAtIndexPath:lastIndexPath];
                if (!self.isSelectCatagory) {
                    cell.contentView.backgroundColor = myCategoryColor;
                    cell.textLabel.backgroundColor = myCategoryColor;
                }
            }
            
            UITableViewCell *cell = [self.catagoryTable cellForRowAtIndexPath:indexPath];
            if (!self.isSelectCatagory) {
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.textLabel.backgroundColor = [UIColor whiteColor];
            }
            self.lastSelectSection = indexPath.row;
            [self markClickedCatagory:indexPath];
        }
        
        
    }
}

-(void)assistantScrollGesture:(UIPanGestureRecognizer *)panGesture{
    CGPoint velocity = [panGesture velocityInView:self.view];
    CGPoint translatedPoint = [panGesture translationInView:self.view];
//    NSLog(@"assistant speed y:%f",velocity.y);
//    NSLog(@"foodTableViewScrollOffset %f",self.foodTableViewScrollOffset);
//    NSLog(@"assistant translatedPoint y:%f",translatedPoint.y);
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        self.gestureStateBegin = true;
        self.assistantGestureBegin = true;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"childViewGustureStateBegin" object:[NSNumber numberWithBool:true]];
    }
    NSLog(@"slide y: %f",_slideViewFrameY);
    if (velocity.y>0  && self.foodTable.isScrollEnabled == false
        && _slideViewFrameY<segmentHeight+navigationBarHeight) {
        
        if ( self.gestureStateBegin == true) {
            if (self.slideViewFrameY<navigationBarHeight+segmentHeight) {
                
            }
            
            self.gestureStateBegin = false;
            self.tempTranslatedPoint = translatedPoint;
        }
        
        NSLog(@"assistant temp y:%f",self.tempTranslatedPoint.y);
    }
    else{
        
        [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
    }
    
    if (self.isSuperViewGustureStart == false  &&self.foodTableViewScrollOffset <= 0 &&velocity.y>0 && self.foodTable.isScrollEnabled == false && self.slideViewFrameY<segmentHeight+navigationBarHeight) {
        
        //NSLog(@"assistant scroll");
        NSLog(@"assistant scroll %f",- translatedPoint.y + _tempTranslatedPoint.y);
        if (-translatedPoint.y + self.tempTranslatedPoint.y > -(segmentHeight+navigationBarHeight)) {
            NSNumber *y = [NSNumber numberWithFloat: - translatedPoint.y + _tempTranslatedPoint.y];
            //NSNumber *y = [NSNumber numberWithFloat: - translatedPoint.y];
            CGPoint velocity = [self.foodTable.panGestureRecognizer velocityInView:self.foodTable];
            NSValue *velocityInValue = [NSValue valueWithCGPoint:velocity];
            NSArray *scrollParam = [NSArray arrayWithObjects:y,velocityInValue, nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"mainContinueScrollingShop" object:scrollParam];

            
            
        }
    }
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        self.assistantGestureBegin = false;
        //self.tempTranslatedPoint = CGPointMake(0, 0);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"childViewGustureStateBegin" object:[NSNumber numberWithBool:false]];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.catagoryTable) {
        return nil;
    }else{
        return self.catagory[section];
    }
}



-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return false;
}

#pragma mark -- load data into tableview
-(void)shopFinishFetchDataNotify{
    //NSLog(@"chilf food %@",[self.myShop.shopItems class]);
    
    if (self.myShop.shopItems.count !=0) {
        self.itemList = self.myShop.shopItems;
        self.catagory = [self.itemList allKeys];
        [self.catagoryTable reloadData];
        [self.foodTable reloadData];
        NSArray *food = [self.itemList valueForKey:self.catagory[0]];
        //NSLog(@"food array %@",food[0]);
        [self.catagoryTable.delegate tableView:self.catagoryTable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [self markClickedCatagory:[NSIndexPath indexPathForRow:0 inSection:0]];
        self.isSelectCatagory = false;
    }
    

}


-(void)buyButtonHandle{
    NSLog(@"buyButtonHandle");
    [self.buyButton setBackgroundColor:myGreenColor];
    [self.delegate detailedChildFoodCheckout];
}

-(void)buyButtonHighlight{
    [self.buyButton setBackgroundColor:myGreenColorHighlight];
}

-(void)cartButtonHandle{
    
    if (self.cartTableView == nil && self.myAccount.cartDetail.count != 0) {
        //UIView *rootView = [[self.view.window subviews] objectAtIndex:0];
        //UIView *rootView = [[[[self.view.window subviews] objectAtIndex:0] subviews] objectAtIndex:0];
        UIView *rootView = self.view.window;
        self.cartTableView = [[CartTableView alloc]initWithFrame:CGRectMake(0, rootView.frame.size.height - cartViewHeight, self.view.frame.size.width, 0)];
        NSMutableArray *itemsofThisShop = [[NSMutableArray alloc] init];
        for (int i = 0; i<self.myAccount.cartDetail.count; i++) {
            if ([[self.myAccount.cartDetail[i] valueForKey:@"shopId"] isEqualToString:self.shopID]) {
                [itemsofThisShop addObject:self.myAccount.cartDetail[i]];
            }
        }
        [self.cartTableView initCartTableView:itemsofThisShop];
        self.cartTableView.delegate = self;
        self.blurEffet = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:self.blurEffet];
        self.blurEffectView.frame = CGRectMake(0, 0, self.view.frame.size.width, rootView.frame.size.height - cartViewHeight);
        //self.blurEffectView.alpha = 0.6;
        self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureHandle:)];
        [self.blurEffectView addGestureRecognizer:self.tapGesture];
        
        //[rootView insertSubview:self.blurEffectView atIndex:0];
        
        [rootView addSubview:self.blurEffectView];
        [rootView addSubview:self.cartTableView];

        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"changePanGestureStatu" object:nil];
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }else{
        [self hideCartTableView];
    }
}

-(void)cartTableViewDidFinishDismissAnimation{
    [self.cartTableView removeFromSuperview];
    self.cartTableView = nil;
}

-(void)tapGestureHandle:(UIGestureRecognizer *)gestureRecognizer{
    //CGPoint p = [gestureRecognizer locationInView:self.view];
    //NSLog(@"tap point %f  %f",p.x,p.y);
    [self hideCartTableView];
}

-(void)hideCartTableView{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changePanGestureStatu" object:nil];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self.blurEffectView removeFromSuperview];
    self.tapGesture = nil;
    self.blurEffectView = nil;
    self.blurEffet = nil;
    [self.cartTableView dismissCartTableViewAnimation];
}


-(void)addButtonHandle:(id)sender{
    CGPoint location = [sender convertPoint:CGPointZero toView:self.foodTable];
    
    [self addItemToCart:location];
    
}
-(void)deleteButtonHandle:(id)sender{
    
    CGPoint location = [sender convertPoint:CGPointZero toView:self.foodTable];
    [self deleteItemOfCart:location];
}


- (void)throwLineToolanimationDidFinish
{
    [self.parabolaView removeFromSuperview];
}

-(void)addItemToCart:(CGPoint )addButtonLocation{
    NSIndexPath *indexPath = [self.foodTable indexPathForRowAtPoint:addButtonLocation];
    UITableViewCell *targetCell = [self.foodTable cellForRowAtIndexPath:indexPath];
    
    CGRect cellFrame = [self.view convertRect:targetCell.frame fromView:self.foodTable];
    CGRect cartButtonFrame = [self.view convertRect:self.cartButton.frame fromView:self.cartView];
     self.parabolaView.frame = CGRectMake(cellFrame.size.width+cellFrame.origin.x - 50, cellFrame.origin.y + foodCellHeight - 30, 20, 20 );
    CGFloat height = self.parabolaView.frame.origin.y;
    
    //NSLog(@"Selected row: %ld,%ld", (long)indexPath.section,(long)indexPath.row);
    NSArray *food = [self.itemList valueForKey:self.catagory[indexPath.section]];
    //NSLog(@"select food %@",food[indexPath.row]);
    BOOL isFindItem = false;
    
    // to find item already in cart and modify the count
    for (int i = 0; i<self.myAccount.cartDetail.count; i++) {

        if ([self.myShop.shopID isEqualToString: [self.myAccount.cartDetail[i] valueForKey:@"shopId"]] &&
            [[food[indexPath.row] valueForKey:@"_id"] isEqualToString:[self.myAccount.cartDetail[i] valueForKey:@"_id"]]) {
            isFindItem = true;
            NSInteger amount = [[self.myAccount.cartDetail[i] valueForKey:@"amount"] integerValue];
            amount = amount+1;
            NSNumber *amountOjb = [NSNumber numberWithInteger:amount];
            
            [self.myAccount cart:POST withShopId:self.myShop.shopID  itemId:[food[indexPath.row] valueForKey:@"_id"] amount:amountOjb  cartId:[self.myAccount.cartDetail[i] valueForKey:@"cartId"] index:0 count:0];
           
            [self.view addSubview:self.parabolaView];
            
            
            [[ThrowLineTool sharedTool] throwObject:self.parabolaView from:self.parabolaView.center to:CGPointMake(cartButtonFrame.origin.x+cartButtonFrame.size.width/2, cartButtonFrame.origin.y+cartButtonFrame.size.height/2) height:-height+60 duration:0.5];
            self.totalItemCount = self.totalItemCount + 1;
            UILabel *amountLable = (UILabel *)[targetCell.contentView viewWithTag:tableCellTag+5];
            
        
            dispatch_async(dispatch_get_main_queue(), ^{
                self.cartBadge.text = [[NSNumber numberWithUnsignedInteger:self.totalItemCount] stringValue];
                if ([[food[indexPath.row] valueForKey:@"_id"] isEqualToString:[self.myAccount.cartDetail[i] valueForKey:@"_id"]]) {
                    amountLable.text = [amountOjb stringValue];
                    
                }
            });
        }
    }
    
    //add new item to cart
    if (!isFindItem) {
        isFindItem = true;
        NSNumber *amountOjb = [NSNumber numberWithInteger:1];
        [self.view addSubview:self.parabolaView];
        [self.myAccount cart:PUT withShopId:self.myShop.shopID  itemId:[food[indexPath.row] valueForKey:@"_id"] amount:amountOjb  cartId:nil index:0 count:0];
        [[ThrowLineTool sharedTool] throwObject:self.parabolaView from:self.parabolaView.center to:CGPointMake(cartButtonFrame.origin.x+cartButtonFrame.size.width/2, cartButtonFrame.origin.y+cartButtonFrame.size.height/2) height:-height+60 duration:0.5];
        self.totalItemCount = self.totalItemCount + 1;
        
        UILabel *amount = (UILabel *)[targetCell.contentView viewWithTag:tableCellTag+5];
        UIButton *deleteButton = (UIButton *)[targetCell.contentView viewWithTag:tableCellTag+6];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.cartBadge.text = [[NSNumber numberWithUnsignedInteger:self.totalItemCount] stringValue];
           
            amount.text = @"1";
            [UIView animateWithDuration:0.3 animations:^{ //2.0
                deleteButton.frame = CGRectMake(self.foodTable.frame.size.width - 70, foodCellHeight-30, 20, 20 );
                amount.frame = CGRectMake(self.foodTable.frame.size.width - 50, foodCellHeight-30, 20, 20 );
            }completion:^(BOOL finished){
                
            }];
            
        });
        
     
    }
}

-(void)deleteItemOfCart:(CGPoint )addButtonLocation{
    NSIndexPath *indexPath = [self.foodTable indexPathForRowAtPoint:addButtonLocation];
    UITableViewCell *targetCell = [self.foodTable cellForRowAtIndexPath:indexPath];
    
    CGRect cellFrame = [self.view convertRect:targetCell.frame fromView:self.foodTable];
    self.parabolaView.frame = CGRectMake(cellFrame.size.width+cellFrame.origin.x - 50, cellFrame.origin.y + foodCellHeight - 30, 20, 20 );
    
    
    
    NSArray *food = [self.itemList valueForKey:self.catagory[indexPath.section]];
    
    BOOL isFindItem = false;
    
    
    for (int i = 0; i<self.myAccount.cartDetail.count; i++) {
        if ([self.myShop.shopID isEqualToString: [self.myAccount.cartDetail[i] valueForKey:@"shopId"]] &&
            [[food[indexPath.row] valueForKey:@"_id"] isEqualToString:[self.myAccount.cartDetail[i] valueForKey:@"_id"]]) {
            isFindItem = true;
            NSInteger amount = [[self.myAccount.cartDetail[i] valueForKey:@"amount"] integerValue];
            UILabel *amountLable = (UILabel *)[targetCell.contentView viewWithTag:tableCellTag+5];
            
            if (amount>=1) {
                amount = amount-1;
            }
            NSNumber *amountOjb = [NSNumber numberWithInteger:amount];
            if (amount == 0) {
                UIButton *deleteButton = (UIButton *)[targetCell.contentView viewWithTag:tableCellTag+6];
               
                
                [UIView animateWithDuration:0.3 animations:^{ //2.0
                    deleteButton.frame = CGRectMake(self.foodTable.frame.size.width - 30, foodCellHeight-30, 20, 20 );
                    amountLable.frame = CGRectMake(self.foodTable.frame.size.width - 30, foodCellHeight-30, 20, 20 );
                }completion:^(BOOL finished){
                    
                }];
                [self.myAccount cart:DELETE withShopId:self.myShop.shopID  itemId:[food[indexPath.row] valueForKey:@"_id"] amount:nil  cartId:[self.myAccount.cartDetail[i] valueForKey:@"cartId"] index:0 count:0];
            }else{
                

                [self.myAccount cart:POST withShopId:self.myShop.shopID  itemId:[food[indexPath.row] valueForKey:@"_id"] amount:amountOjb  cartId:[self.myAccount.cartDetail[i] valueForKey:@"cartId"] index:0 count:0];

            }
            for (int i=0; i<self.myAccount.cartDetail.count; i++) {
                if ([[food[indexPath.row] valueForKey:@"_id"] isEqualToString:[self.myAccount.cartDetail[i] valueForKey:@"_id"]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        amountLable.text = [amountOjb stringValue];
                    });
                }
            }
            
            self.totalItemCount = self.totalItemCount - 1;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.cartBadge.text = [[NSNumber numberWithUnsignedInteger:self.totalItemCount] stringValue];
            });
        }
    }
    
    //delete item
    
}

-(void)updateCartView{
    self.totalItemCount = 0;
    self.totalPrice = 0;
    for (int i = 0; i<self.myAccount.cartDetail.count; i++) {
        if ([[self.myAccount.cartDetail[i] valueForKey:@"shopId"] isEqualToString:self.shopID]) {
            self.totalItemCount = self.totalItemCount + [[self.myAccount.cartDetail[i] valueForKey:@"amount"] integerValue];
            self.totalPrice = self.totalPrice + [[self.myAccount.cartDetail[i] valueForKey:@"amount"] integerValue]*[[self.myAccount.cartDetail[i] valueForKey:@"price"] integerValue];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.cartBadge.text = [[NSNumber numberWithUnsignedInteger:self.totalItemCount] stringValue];
        self.totalPriceLabel.text = [NSString stringWithFormat:@"The totaol price:\n      $ %lu",(unsigned long)self.totalPrice];
    });
    NSMutableArray *itemsofThisShop = [[NSMutableArray alloc] init];
    for (int i = 0; i<self.myAccount.cartDetail.count; i++) {
        if ([[self.myAccount.cartDetail[i] valueForKey:@"shopId"] isEqualToString:self.shopID]) {
            [itemsofThisShop addObject:self.myAccount.cartDetail[i]];
        }
    }
    if (itemsofThisShop.count == 0) {
        [self.buyButton setBackgroundColor:[UIColor grayColor]];
        [self.buyButton setEnabled:false];
    }else{
        [self.buyButton setBackgroundColor:myGreenColor];
        [self.buyButton setEnabled:true];
    }
    
}

-(void)finishRefreshAccountData{
    [self updateCartView];
    [self.foodTable reloadData];
    self.tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureHandle:)];
    [self.blurEffectView addGestureRecognizer:self.tapGesture2];
    self.cartTableView.cartDetail = self.myAccount.cartDetail;
    [self.cartTableView.tableView reloadData];
}
#pragma mark -- UIGestureDelegate



@end
