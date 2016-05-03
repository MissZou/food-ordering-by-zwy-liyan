//
//  DetailedChildCommentView.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/26.
//  Copyright © 2016年 李龑. All rights reserved.
//
#define shopMarkViewHeight 200

#import "DetailedChildCommentView.h"

@interface DetailedChildCommentView ()<UITableViewDelegate, UITableViewDataSource>
@property(strong,nonatomic)UIView *shopMarkView;
@property(strong,nonatomic)UITableView *commentTableView;
@property(assign,nonatomic)CGFloat maxOffset;
@end

@implementation DetailedChildCommentView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCommentView];
    // Do any additional setup after loading the view.
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableInteraction) name:@"disableInteractionComment" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(triggerNotificationAction:) name:@"enableInteractionComment" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    self.commentTableView.userInteractionEnabled = false;
}

-(void)initCommentView{
    self.commentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    [self.commentTableView registerClass:[UITableViewCell self] forCellReuseIdentifier:@"commentCell"];
    self.shopMarkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.commentTableView.frame.size.width, shopMarkViewHeight)];
    
    UILabel *mark = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, 75, 45)];
    //mark.center = self.shopMarkView.center;
    mark.text = @"5";
    mark.textColor = [UIColor redColor];
    mark.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:25];
    [self.shopMarkView addSubview:mark];
    
    UIView *separateView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, self.commentTableView.frame.size.width, 10)];
    separateView.backgroundColor = [UIColor grayColor];
    [self.shopMarkView addSubview:separateView];
    
    
    [self.commentTableView setTableHeaderView:self.shopMarkView];
    [self.view addSubview:self.commentTableView];
    
}

-(void)disableInteraction{
    self.commentTableView.userInteractionEnabled = false;
}

-(void)enableInteraction{
    self.commentTableView.userInteractionEnabled = true;
}

-(void) triggerNotificationAction:(NSNotification *) notification
{
    if ([notification.object isKindOfClass:[NSNumber class]])
    {
        [self enableInteraction];
        NSNumber *y = [notification object];
        //NSLog(@"continu to scroll child %f",[y floatValue]);
        [self.commentTableView setContentOffset:CGPointMake(0,  -[y floatValue])];
    }
    else
    {
        NSLog(@"Error, object not recognised.");
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y<0 ) {
        
        //self.foodTable.bounces = NO;
        [self disableInteraction];
        
        if (self.maxOffset > scrollView.contentOffset.y) {
            self.maxOffset = scrollView.contentOffset.y;
            NSNumber *y = [NSNumber numberWithFloat:self.maxOffset];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"mainContinueScrollingComment" object:y];
        }
    }
    else if(scrollView.contentOffset.y>0){
            [self enableInteraction];
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 25;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    
    cell.textLabel.text = @"comment";
    
    return cell;
}

@end
