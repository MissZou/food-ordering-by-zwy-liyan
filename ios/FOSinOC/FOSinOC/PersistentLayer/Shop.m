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

-(void)searchShopByLocation:(NSArray *)coordinate withdistance:(NSNumber *)distance{
    NSURL *url = [NSURL URLWithString:@"findshops" relativeToURL:self.baseUrl];
    NSDictionary *parameters = @{@"coordinate": coordinate, @"distance": distance};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:[url absoluteString] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *responseDict = responseObject;
            //NSLog(@"%@",responseDict);
            [self.delegate finishSearchShops:responseDict];
        } else {
            NSLog(@"%@", responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}



@end
