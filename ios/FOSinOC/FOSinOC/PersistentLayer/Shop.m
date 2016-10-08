//
//  Shop.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/29.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "Shop.h"
#import "AFNetworking/AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>

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

-(void)reloadShop{
    self.shopID = nil;
    self.shopPicUrl = nil;
    self.shopName = nil;
    self.shopAddress = nil;
    self.shopCatagory = nil;
    self.shopItems = nil;
    self.startPrice = nil;
    self.shopMark = nil;
    self.distance = nil;
    self.shopComments = nil;
    self.shopImage = nil;
    
}

-(void)loadData:(NSDictionary *)data{
    if ([data valueForKey:@"shopName"] != nil) {
        self.shopName = [data valueForKey:@"shopName"];
    }
    if ([data valueForKey:@"shopPicUrl"] != nil) {
        self.shopPicUrl = [data valueForKey:@"shopPicUrl"];
    }
    if ([data valueForKey:@"shopAddress"] != nil) {
        self.shopCatagory = [data valueForKey:@"shopType"];
    }
    if ([data valueForKey:@"dish"] != nil) {
        self.shopItems = [data valueForKey:@"dish"];
    }
    if ([data valueForKey:@"shopId"] != nil) {
        self.shopID = [data valueForKey:@"shopId"];
    }
//    if ([data valueForKey:@"shopName"] != nil) {
//        self.shopName = [data valueForKey:@"shopName"];
//    }
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
            NSLog(@"%@", responseObject);
            if ([[responseObject valueForKey:@"success"] boolValue] == YES) {
                    [self.delegate finishSearchShops:responseObject];
            }else{
                NSLog(@"%@", responseObject);
            }
            
            
        } else {
            NSLog(@"%@", responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

-(void)fetchShopData:(NSString *)shopId{
    NSURL *url = [NSURL URLWithString:@"findshopbyid" relativeToURL:self.baseUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:shopId  forHTTPHeaderField:@"shopid"];
    
    [manager GET:[url absoluteString] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            //NSLog(@"shop data: %@",responseObject);
            if ([[responseObject valueForKey:@"success"] boolValue] == YES) {
                [self loadData:responseObject];
                [self.delegate shopFinishFetchData];
            }else{
                NSLog(@"%@", responseObject);
            }
            
        } else {
            NSLog(@"%@", responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"shopCatagory" : @"shopType"
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"dishs" : [Item class]
             };
}

-(void)fetchShopDataModelingByYYKit:(NSString *)shopId {
    NSURL *url = [NSURL URLWithString:@"findshopbyid" relativeToURL:self.baseUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:shopId  forHTTPHeaderField:@"shopid"];
    
    [manager GET:[url absoluteString] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            //NSLog(@"shop data: %@",responseObject);
            if ([[responseObject valueForKey:@"success"] boolValue] == YES) {
                //[self loadData:responseObject];
                [Shop yy_modelWithJSON:responseObject];
                
                [self.delegate shopFinishFetchData];
            }else{
                NSLog(@"%@", responseObject);
            }
            
        } else {
            NSLog(@"%@", responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}
@end
