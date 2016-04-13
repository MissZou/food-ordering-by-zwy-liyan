//
//  SearchViewHelp.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/13.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "SearchViewHelpController.h"

@interface SearchViewHelpController()
@property(strong,nonatomic) Account *myAccount;

@end

@implementation SearchViewHelpController

-(id)init{
    if(self = [super init]){
        self.myAccount = [Account sharedManager];
    }
    return self;
}

-(void) updateSearchResultsForSearchController:(UISearchController *)searchController{
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40*1.5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchTableCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:150.0/255.0 green:150/255.0 blue:150/255.0 alpha:0.5];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 100, 40)];
    textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.text = @"search result";
    textLabel.textAlignment = NSTextAlignmentLeft;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 20, 20)];
    imageView.image = [UIImage imageNamed:@"addGreen.png"];
    [cell.contentView addSubview:imageView];
    [cell.contentView addSubview:textLabel];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *locations = self.myAccount.location;
    [self.delegate finishSearchWithResult:locations[indexPath.row]];
    //NSLog(@"delegate %@",locations[indexPath.row]);
}
@end
