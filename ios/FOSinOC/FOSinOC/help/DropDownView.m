//
//  DropDownView.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/13.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "DropDownView.h"

@interface DropDownView()
{

}
@property(strong,nonatomic)UIButton *senderBtn;
@property(assign,nonatomic)CGFloat tableViewCellHeight;
-(id)initDropDownViewConveniennce:(UIButton *)button :(CGFloat)cellHeight :(CGFloat)viewHeight :(NSMutableArray *)array;

@end



@implementation DropDownView

-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
    }
        return self;
}

+(id)initDropDownView:(UIButton *)button cellHeight:(CGFloat)cellHeight viewHeight:(CGFloat)viewHeight Array:(NSMutableArray *)array{
    return [[self alloc]initDropDownViewConveniennce:button :cellHeight :viewHeight :array];
}

-(id)initDropDownViewConveniennce:(UIButton *)button :(CGFloat)cellHeight :(CGFloat)viewHeight :(NSMutableArray *)array{
    if(self = [super init]){
        self.senderBtn = button;
        self.tableViewCellHeight = cellHeight;
        self.dropDownList = array;
        [self showDropDownView:viewHeight withArray:self.dropDownList];
    }
    return self;
}

-(void)showDropDownView:(CGFloat)viewHeight withArray:(NSMutableArray *)array{
    
    CGRect rect = self.senderBtn.superview.frame;
    self.frame = CGRectMake(rect.origin.x, rect.origin.y+rect.size.height, rect.size.width, 0);
    self.layer.masksToBounds = false;
    
    self.dropDownTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, 0)];
    self.dropDownTableView.delegate = self;
    self.dropDownTableView.dataSource = self;
    self.dropDownTableView.backgroundColor = [UIColor colorWithRed:0.239 green:0.239 blue:0.239 alpha:1];
    self.dropDownTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.dropDownTableView registerClass:[UITableViewCell self] forCellReuseIdentifier:@"dropDownCell"];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.frame = CGRectMake(rect.origin.x, rect.origin.y+rect.size.height, rect.size.width, viewHeight);
    self.dropDownTableView.frame = CGRectMake(0, 0, rect.size.width, viewHeight);
    [UIView commitAnimations];
    [self.senderBtn.superview.superview.superview addSubview:self];
    [self addSubview:self.dropDownTableView];
}

-(void)hideDropDownView{
    CGRect rect = self.senderBtn.superview.frame;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.frame = CGRectMake(rect.origin.x, rect.origin.y+rect.size.height, rect.size.width, 0);
    self.dropDownTableView.frame = CGRectMake(0, 0, rect.size.width, 0);
    [UIView commitAnimations];
}

#pragma mark - Table view


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dropDownList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.tableViewCellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dropDownCell" forIndexPath:indexPath];
    if(indexPath.row != 0){
        cell.textLabel.text = self.dropDownList[indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        cell.textLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    } else{
        cell.textLabel.text = self.dropDownList[indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.layer.backgroundColor = [UIColor colorWithRed:32/255.0 green:197/255.0 blue:174/255.0 alpha:1].CGColor;
        cell.backgroundColor = [UIColor colorWithRed:32/255.0 green:197/255.0 blue:174/255.0 alpha:1];

    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self hideDropDownView];
    UITableViewCell *cell = [self.dropDownTableView cellForRowAtIndexPath:indexPath];
    NSString *btnTitle = [NSString stringWithFormat:@"%@ ▾",cell.textLabel.text];
    [self.senderBtn setTitle:btnTitle forState:UIControlStateNormal];
    self.choosedString = self.dropDownList[indexPath.row];
    [self.delegate dropDownMenuClicked:self];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return false;
    }
    return true;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        NSString *deleteString = self.dropDownList[indexPath.row];
        [self.dropDownList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //[tableView deleteRowsAtIndexPaths:[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.delegate dropDownMenuDelete:self withString:deleteString];
    }
}

@end
