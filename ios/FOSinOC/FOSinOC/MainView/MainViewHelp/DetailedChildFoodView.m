//
//  DetailedChildFoodView.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/26.
//  Copyright © 2016年 李龑. All rights reserved.
//

#define catagoryTalbeWidth 80

#import "DetailedChildFoodView.h"

@interface DetailedChildFoodView ()<UITableViewDelegate, UITableViewDataSource>
@property(strong,nonatomic)UITableView *catagoryTable;
@property(strong,nonatomic)UITableView *foodTable;
@property(assign,nonatomic)NSInteger lastSelectSection;
@property(assign,nonatomic)BOOL isSelectCatagory;
@property(assign, nonatomic)BOOL isLastCatagorySelected;
@property(assign,nonatomic)BOOL isSendContinueScrolling;
@property(assign,nonatomic)CGFloat maxOffset;
@property(strong,nonatomic)UIPanGestureRecognizer *foodTablePanGesture;
//test
@property(strong,nonatomic)NSDictionary *foodlist;
@property(strong,nonatomic)NSArray *catagory;
@end

@implementation DetailedChildFoodView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *food1 = @[@"c1 food one",@"c1 food two",@"c1 food three",@"food four",@"food five"];
    NSArray *food2 = @[@"c2 food one",@"c2 food two",@"food three",@"food four",@"food five"];
    NSArray *food3 = @[@"c3 food one",@"c3 food two",@"food three",@"food four",@"food five"];
    NSArray *food4 = @[@"c4 food one",@"c4 food two",@"food three",@"food four",@"food five"];
    NSArray *food5 = @[@"c5 food one",@"c5 food two",@"food three",@"food four",@"food five"];
    NSDictionary *catagory = @{@"one":food1,@"two":food2,@"three":food3,@"four":food4,@"five":food5};
    self.foodlist = catagory;
    self.catagory = [self.foodlist allKeys];
    [self initTableViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableInteraction) name:@"disableInteraction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(triggerNotificationAction:) name:@"enableInteraction" object:nil];
    [self disableInteraction];
    self.foodTablePanGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(scrollFoodTalbe:)];
    //[self.foodTable addGestureRecognizer:self.foodTablePanGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//viewDidAppear called twice??
-(void)viewDidAppear:(BOOL)animated{
    //[self initTableViews];
    self.foodTable.frame = CGRectMake(catagoryTalbeWidth, 0, self.view.frame.size.width - catagoryTalbeWidth, self.view.frame.size.height);
    NSLog(@"%f",self.view.frame.size.height);
    NSLog(@"%f",self.foodTable.frame.size.height);
    
    self.isSendContinueScrolling = false;
    
}

-(void)disableInteraction{
    NSLog(@"Disable Interaction");
    self.foodTable.userInteractionEnabled =false;
    //self.catagoryTable.userInteractionEnabled =false;
}

-(void)enableInteraction{
    NSLog(@"Enable Interaction");
    self.maxOffset = 0;
    self.foodTable.userInteractionEnabled =true;
    self.isSendContinueScrolling = false;
    //self.catagoryTable.userInteractionEnabled =true;
}

-(void)initTableViews{
    self.lastSelectSection = -1;
    
    self.catagoryTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, catagoryTalbeWidth, self.view.frame.size.height) style:UITableViewStylePlain];
    [self.catagoryTable registerClass:[UITableViewCell self] forCellReuseIdentifier:@"catagoryCell"];
    self.catagoryTable.delegate = self;
    self.catagoryTable.dataSource = self;
    self.catagoryTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.catagoryTable.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.catagoryTable];
    
    self.foodTable = [[UITableView alloc]initWithFrame:CGRectMake(catagoryTalbeWidth, 0, self.view.frame.size.width - catagoryTalbeWidth, self.view.frame.size.height) style:UITableViewStylePlain];
    [self.foodTable registerClass:[UITableViewCell self] forCellReuseIdentifier:@"foodCell"];
    self.foodTable.delegate = self;
    self.foodTable.dataSource = self;
    
    [self.view addSubview:self.foodTable];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.catagoryTable) {
        return 1;
    } else{
        return self.foodlist.count;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.catagoryTable) {
        return [self.foodlist allKeys].count;
    } else{
        NSArray *foods = [self.foodlist valueForKey: self.catagory[section]];
        return foods.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.catagoryTable) {
        return 40;
    } else{
        return 70;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.catagoryTable) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"catagoryCell" forIndexPath:indexPath];
        cell.textLabel.text = self.catagory[indexPath.row];
        cell.contentView.backgroundColor = [UIColor grayColor];
        cell.textLabel.backgroundColor = [UIColor grayColor];
        return cell;

    } else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"foodCell" forIndexPath:indexPath];
        NSArray *food = [self.foodlist valueForKey:self.catagory[indexPath.section]];
        cell.textLabel.text = food[indexPath.row];
        return cell;
    }
}

-(void)markClickedCatagory:(NSIndexPath *) indexPath{
    if (self.lastSelectSection+1) {
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.lastSelectSection inSection:0];
        UITableViewCell *cell = [self.catagoryTable cellForRowAtIndexPath:lastIndexPath];
        cell.contentView.backgroundColor = [UIColor grayColor];
        cell.textLabel.backgroundColor = [UIColor grayColor];
    }
    UITableViewCell *cell = [self.catagoryTable cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.backgroundColor = [UIColor whiteColor];
    self.lastSelectSection = indexPath.row;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.catagoryTable) {
        self.isSelectCatagory = true;
        //the first row is make self.lastSelectSeciton = indexPath.row = 0, so plus one could let conditon be true
        if (self.lastSelectSection+1) {
            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.lastSelectSection inSection:0];
            UITableViewCell *cell = [self.catagoryTable cellForRowAtIndexPath:lastIndexPath];
            cell.contentView.backgroundColor = [UIColor grayColor];
            cell.textLabel.backgroundColor = [UIColor grayColor];
        }

        UITableViewCell *cell = [self.catagoryTable cellForRowAtIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.textLabel.backgroundColor = [UIColor whiteColor];
        self.lastSelectSection = indexPath.row;
        NSInteger section = [self.catagory indexOfObject:cell.textLabel.text];
        

        
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:0 inSection:section];
        [self.foodTable scrollToRowAtIndexPath:indexPath2 atScrollPosition:UITableViewScrollPositionTop animated:YES];
        if (section +1 == self.catagory.count) {
            [self scrollViewDidEndScrollingAnimation:self.foodTable];
        }
    } else{
        //select food
    }
}

-(void)scrollFoodTalbe:(UIPanGestureRecognizer *)panGesture{
    CGPoint velocity = [panGesture velocityInView:self.view];
    CGPoint translatedPoint = [panGesture translationInView:self.view];
    NSLog(@"translated y:%f",translatedPoint.y);
    NSLog(@"food speed y:%f",velocity.y);
    NSLog(@"food slide y: %f",self.foodTable.contentOffset.y);
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
        //NSLog(@"continu to scroll child %f",[y floatValue]);
        [self.foodTable setContentOffset:CGPointMake(0,  -[y floatValue])];
    }
    else
    {
        NSLog(@"Error, object not recognised.");
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.catagoryTable) {
        if (scrollView.contentOffset.y<=0) {
            //[self disableInteraction];
//            NSNumber *y = [NSNumber numberWithFloat:scrollView.contentOffset.y];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"mainContinueScrolling" object:y];
            
        }
        else{
           // [self enableInteraction];
        }
        
    }else{
        //NSLog(@"child %f",scrollView.contentOffset.y);

        if (scrollView.contentOffset.y<0 ) {
            //self.foodTable.bounces = NO;
            [self disableInteraction];
            
            if (self.maxOffset > scrollView.contentOffset.y) {
                
                self.maxOffset = scrollView.contentOffset.y;
                
                //[self.foodTable setContentOffset:CGPointMake(0, 0)];
                self.isSendContinueScrolling = true;
                NSNumber *y = [NSNumber numberWithFloat:self.maxOffset];
                //NSLog(@"maxoffset %f", [y floatValue]);
                [[NSNotificationCenter defaultCenter]postNotificationName:@"mainContinueScrolling" object:y];
                if (scrollView.contentOffset.y < -20) {
                    //[self.foodTable setContentOffset:CGPointMake(0, 0)];
                }
            }
            

            
        }
        else if(scrollView.contentOffset.y>0){
            
            [self enableInteraction];
            self.isSendContinueScrolling = false;
            self.foodTable.bounces = YES;
        }
        
        
        NSIndexPath *firstVisibleIndexPath = [[self.foodTable indexPathsForVisibleRows] objectAtIndex:0];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:firstVisibleIndexPath.section inSection:0];
        if (self.lastSelectSection+1) {
            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.lastSelectSection inSection:0];
            UITableViewCell *cell = [self.catagoryTable cellForRowAtIndexPath:lastIndexPath];
            if (!self.isSelectCatagory) {
                cell.contentView.backgroundColor = [UIColor grayColor];
                cell.textLabel.backgroundColor = [UIColor grayColor];
            }
        }
        
        UITableViewCell *cell = [self.catagoryTable cellForRowAtIndexPath:indexPath];
        if (!self.isSelectCatagory) {
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.textLabel.backgroundColor = [UIColor whiteColor];
        }
        self.lastSelectSection = indexPath.row;
        
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.catagoryTable) {
        return nil;
    }else{
        return self.catagory[section];
    }
}

@end
