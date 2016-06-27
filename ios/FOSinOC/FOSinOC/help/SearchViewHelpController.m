//
//  SearchViewHelp.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/13.
//  Copyright © 2016年 李龑. All rights reserved.
//
#define tableCellTag 1360
#import "SearchViewHelpController.h"
#import "AFNetworking/AFNetworking.h"

@interface SearchViewHelpController()
@property(strong,nonatomic) Account *myAccount;
@property(strong,nonatomic) NSArray *suggestedLocations;
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
    return [self.suggestedLocations count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40*1.5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchTableCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:150.0/255.0 green:150/255.0 blue:150/255.0 alpha:0.5];
    if ([cell.contentView subviews].count == 0) {
           UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 280, 40)];
    textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.text = [self.suggestedLocations[indexPath.row] valueForKey:@"name"];
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.tag = tableCellTag+1;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 20, 20)];
    imageView.image = [UIImage imageNamed:@"addGreen.png"];
    [cell.contentView addSubview:imageView];
    [cell.contentView addSubview:textLabel]; 
    }
    else{
        UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag: tableCellTag+1];
        textLabel.text =[self.suggestedLocations[indexPath.row] valueForKey:@"name"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.delegate finishSearchLocationWithLocation:self.suggestedLocations[indexPath.row]];

}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSDictionary *parameters = @{@"location": searchText};
    NSString *URLString = @"http://localhost:8080/search/findlocation";
    //NSString *baseUrlString = @"http://localhost:8080/search/";
    
    [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request =  [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
    
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            //NSLog(@"%@",responseObject);
            self.suggestedLocations =[responseObject valueForKey:@"res"];
//            for(NSDictionary *loc in self.suggestedLocations){
//                NSLog(@"%@",[loc valueForKey:@"name"]);
//                NSLog(@"%@",[loc valueForKey:@"location"]);
//                
//            }
            [self.delegate finishSearchLocationWithResult:self.suggestedLocations];
        }
    }];
    [dataTask resume];
    
}



@end
