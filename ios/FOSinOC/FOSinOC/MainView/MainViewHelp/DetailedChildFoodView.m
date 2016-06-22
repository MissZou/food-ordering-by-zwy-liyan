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
#import "DetailedChildFoodView.h"
#import "Shop.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DetailedChildFoodView ()<UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate >
@property(strong,nonatomic) UITableView *catagoryTable;
@property(strong,nonatomic) UITableView *foodTable;
@property(strong,nonatomic) UIImageView *categoryMarkView;
@property(strong,nonatomic) Shop *myShop;
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
@property(strong,nonatomic) UILabel *totalPrice;

@end

@implementation DetailedChildFoodView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myShop = [Shop sharedManager];

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
    //[self.catagoryTable setSeparatorColor:[UIColor blueColor]];
    
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
    self.cartView.backgroundColor = [UIColor blackColor];
//    
//    self.cartView.opaque = false;
//    self.cartView.alpha = 0.7;
//    
    self.buyButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 120, 0, 120, cartViewHeight)];
    [self.buyButton setBackgroundColor:[UIColor greenColor]];
    [self.buyButton setTitle:@"buy" forState:UIControlStateNormal];
    [self.buyButton addTarget:self action:@selector(buyButtonHandle) forControlEvents:UIControlEventTouchUpInside];
    [self.buyButton addTarget:self action:@selector(buyButtonHighlight) forControlEvents:UIControlEventTouchDown];
    self.buyButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25];
    [self.cartView addSubview:self.buyButton];
    
    self.cartButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
    [self.cartButton setImage:[UIImage imageNamed:@"cart.png"] forState:UIControlStateNormal];
    self.cartButton.imageView.clipsToBounds = true;
    self.cartButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.cartButton setBackgroundColor:[UIColor blackColor]];
    [self.cartButton addTarget:self action:@selector(cartButtonHandle) forControlEvents:UIControlEventTouchUpInside];
    [self.cartView addSubview:self.cartButton];
    
    self.cartBadge = [[UILabel alloc]initWithFrame:CGRectMake(40, 2, 17, 17)];
    self.cartBadge.layer.cornerRadius = 8;
    self.cartBadge.layer.masksToBounds = true;
    self.cartBadge.backgroundColor = [UIColor redColor];
    [self.cartView addSubview:self.cartBadge];
    
    self.totalPrice = [[UILabel alloc]initWithFrame:CGRectMake(80, 5, 80, 40)];
    self.totalPrice.text = @"$ 0";
    self.totalPrice.textColor = [UIColor whiteColor];
    self.totalPrice.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25];
    [self.cartView addSubview:self.totalPrice];
    
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
        
        UIImageView *separateLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, categoryCellHeight, self.catagoryTable.frame.size.width, 0.1)];
        separateLine.image = [UIImage imageNamed:@"separateLine.png"];
        separateLine.contentMode = UIViewContentModeScaleAspectFill;
        //[cell.contentView addSubview:separateLine];
        
        return cell;

    } else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"foodCell" forIndexPath:indexPath];
        NSArray *food = [self.itemList valueForKey:self.catagory[indexPath.section]];
        
        if ([cell.contentView subviews].count == 0) {
            
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
            [addButton setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
            addButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
            addButton.layer.cornerRadius = 2;
            addButton.layer.masksToBounds = true;
            [addButton addTarget:self action:@selector(addButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
            addButton.backgroundColor = myBlueColor;
            addButton.tag = tableCellTag+4;
            
            [cell.contentView addSubview:dishName];
            [cell.contentView addSubview:imageView];
            [cell.contentView addSubview:price];
            [cell.contentView addSubview:addButton];
            return cell;
        }else{
            UILabel *dishName = (UILabel *)[cell.contentView viewWithTag:tableCellTag+1];
            UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:tableCellTag+2];
            UILabel *price = (UILabel *)[cell.contentView viewWithTag:tableCellTag+3];
            UIButton *addButton = (UIButton *)[cell.contentView viewWithTag:tableCellTag+4];
            
            dishName.text = [food[indexPath.row] valueForKey:@"dishName"];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[food[indexPath.row] valueForKey:@"dishPic"]] placeholderImage:[UIImage imageNamed:@"favoriteGreen.png"]];
            price.text = [NSString stringWithFormat:@"%@%@",@"$: ",[[food[indexPath.row] valueForKey:@"price"] stringValue]];
            [addButton addTarget:self action:@selector(addButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
            
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
    NSLog(@"@%ld",indexPath.row);
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
        [self markClickedCatagory:indexPath];
        
    } else if(tableView == self.foodTable){
        //select food
        NSArray *food = [self.itemList valueForKey:self.catagory[indexPath.section]];
        NSLog(@"%@",food[indexPath.row]);
        
        [self.delegate DetailedChildFoodDidSelectFood:@"foodId"];
        
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
    return true;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqual: @"foodDetailSegue"]) {
        
    }
    
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
        NSLog(@"food array %@",food[0]);
        [self tableView:self.catagoryTable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        self.isSelectCatagory = false;
    }
    

}


-(void)buyButtonHandle{
    NSLog(@"buyButtonHandle");
    [self.buyButton setBackgroundColor:[UIColor greenColor]];
}

-(void)buyButtonHighlight{
    [self.buyButton setBackgroundColor:[UIColor redColor]];
}

-(void)cartButtonHandle{
    NSLog(@"cartButtonHandle");
    NSLog(self.cartView.opaque?@"opaque yes":@"opaque no");
    NSLog(@"cart view alpha %f",self.cartView.alpha);
}

-(void)addButtonHandle:(id)sender{
    CGPoint location = [sender convertPoint:CGPointZero toView:self.foodTable];
    NSIndexPath *indexPath = [self.foodTable indexPathForRowAtPoint:location];
    //UITableViewCell *swipeCell = [self.foodTable cellForRowAtIndexPath:indexPath];
    
    NSLog(@"Selected row: %ld,%ld", (long)indexPath.section,(long)indexPath.row);
    NSArray *food = [self.itemList valueForKey:self.catagory[indexPath.section]];
    NSLog(@"select food %@",food[indexPath.row]);
    
    
}
@end
