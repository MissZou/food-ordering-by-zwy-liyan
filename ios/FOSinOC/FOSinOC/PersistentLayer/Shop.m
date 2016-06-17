//
//  Shop.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/29.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "Shop.h"
#import "AFNetworking/AFNetworking.h"
static NSString *baseUrlString = @"http://localhost:8080/shop/";

@interface Shop ()

@property(strong,nonatomic) NSURL *baseUrl;

@end

@implementation Shop

static Shop *sharedManager = nil;

+(Shop *)sharedManager{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc]init];
    });
    return sharedManager;
}

-(id) init {
    if(self = [super init]){
        self.baseUrl = [NSURL URLWithString:baseUrlString];
    }
    return self;
}

-(void)searchShopByLocation:(NSArray *)location withdistance:(NSNumber *)distance{
    NSURL *url = [NSURL URLWithString:@"findshops" relativeToURL:self.baseUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    NSString *locationString1 = [location[0] valueForKey:@"description"];
    NSString *locationString = [[locationString1 stringByAppendingString:@","] stringByAppendingString:[location[1] valueForKey:@"description"]];
    //[locationString stringByAppendingString:[location[1] valueForKey:@"description"]];
    
    NSLog(@"location string %@",locationString);
    
    NSString *distanceString = [distance stringValue];
    [manager.requestSerializer setValue:locationString  forHTTPHeaderField:@"location"];
    [manager.requestSerializer setValue:distanceString  forHTTPHeaderField:@"distance"];
    
    
    
    
    [manager GET:[url absoluteString] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            //NSLog(@"%@", responseObject);
            [self.delegate finishSearchShops:responseObject];
            
        } else {
            NSLog(@"%@", responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}



@end
