//
//  SortView.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/23.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "SortView.h"

@interface SortView()
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)NSArray *sortOperation;
@end

@implementation SortView

-(void)initSortView{
    self.sortOperation = @[@"Distance",@"Heat",@"Start Price"];
    [self drawSortView];
}

-(void)drawSortView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0) style:UITableViewStylePlain];
    self.tableView.delegate  = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell self] forCellReuseIdentifier:@"sortCell"];
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.frame =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }];
    [self addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortOperation.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sortCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.sortOperation[indexPath.row];
    
        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",self.sortOperation[indexPath.row]);
    [self.delegate sortOperation:self.sortOperation[indexPath.row]];
}

@end
