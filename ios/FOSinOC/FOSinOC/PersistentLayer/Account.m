//
//  Account.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/9.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "Account.h"
#import "SSKeychain/SSKeychain.h"
#import "AFNetworking/AFNetworking.h"



static NSString *baseUrlString = @"http://localhost:8080/user/";

@interface Account ()

@property(strong,nonatomic) NSURL *baseUrl;



@end

@implementation Account
 static Account *sharedManager = nil;

+(Account *)sharedManager{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc]init];
    });
    return sharedManager;
}

-(void)reloadAccount{
    self.email = nil;
    self.name = nil;
    self.phone = nil;
    self.name = nil;
    self.location = nil;
    self.deliverAddress = nil;
    self.photoUrl = nil;
    self.accountId = nil;
    self.token = nil;
    
}

-(id) init {
    if(self = [super init]){
        self.baseUrl = [NSURL URLWithString:baseUrlString];
        self.serviceName = @"com.HKU.FoodOrderingYystem";
        self.serviceAccount = @"fosAccount";
        self.servicePassword = @"fosPassword";
        self.serviceToken = @"fosToken";
        
    }
    return self;
}

-(void)updateAccount:(NSDictionary *)result{
//    NSLog([[[result valueForKey:@"token"] class] description]);
//    NSLog([[[result valueForKey:@"email"] class] description]);
//    NSLog([[[result valueForKey:@"name"] class] description]);
//    NSLog([[[result valueForKey:@"phone"] class] description]);
//    NSLog([[[result valueForKey:@"accountId"] class] description]);
//    NSLog([[[result valueForKey:@"photoUrl"] class] description]);
    
    
    if([result valueForKey:@"token"] != nil){
        self.token = [result valueForKey:@"token"];
    }
    if([result valueForKey:@"email"] != nil){
        self.email = [result valueForKey:@"email"];
    }
    if([result valueForKey:@"name"] != nil){
        self.name = [result valueForKey:@"name"];
    }
    if([result valueForKey:@"phone"] != nil){
        self.phone = [result valueForKey:@"phone"];
    }
    if([result valueForKey:@"accountId"] != nil){
        self.accountId = [result valueForKey:@"accountId"];
    }
    if([result valueForKey:@"photoUrl"] != nil){
        self.photoUrl = [result valueForKey:@"photoUrl"];
    }
    if([[result valueForKey:@"address"] count]){
        BOOL isFoundDefault = false;
        self.deliverAddress = [[result valueForKey:@"address"] mutableCopy];
        NSUInteger count = 0;
        //NSLog(@"%lu",(unsigned long)[self.deliverAddress count]);
        //NSLog(@"%@",self.deliverAddress);
        for(NSDictionary *addr in self.deliverAddress){
            
            if([[addr valueForKey:@"type"]integerValue] == 0){
                isFoundDefault = true;
                break;
            }else{
                if(count < [self.deliverAddress count]){
                    count +=1;
                }
                else{
                    //isFoundDefault = true;
                    break;
                }
                
            }
            
        }
        //NSLog(@"%d",count);
        if (isFoundDefault) {
            [self.deliverAddress insertObject:self.deliverAddress[count] atIndex:0];
            [self.deliverAddress removeObjectAtIndex:count+1];
        }
        
   
    }
    if([result valueForKey:@"location"]!=nil){
        self.location = [result valueForKey:@"location"];
    }
    
    [self.delegate finishRefreshAccountData];
}

-(void)createAccount:(Account *)model {
    NSURL *url = [NSURL URLWithString:@"register" relativeToURL:self.baseUrl];
    NSDictionary *parameters = @{@"email": model.email, @"password": model.password,@"name":model.name, @"phone":model.phone};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:[url absoluteString] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
//            NSLog(@"%@",responseObject);
            [self.delegate finishCreateAccount:responseObject withAccount:Account.sharedManager];
        } else {
            NSLog(@"%@", responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];

}

-(void) login:(Account *)model{
    NSURL *url = [NSURL URLWithString:@"login" relativeToURL:self.baseUrl];
    NSDictionary *parameters = @{@"email": model.email, @"password": model.password};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:[url absoluteString] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
       if ([responseObject isKindOfClass:[NSDictionary class]]) {
           NSDictionary *responseDict = responseObject;
           [self.delegate finishFetchAccountData:responseDict withAccount:Account.sharedManager];
       } else {
           NSLog(@"%@", responseObject);
       }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

-(void) checkLogin{
    NSURL *url = [NSURL URLWithString:@"account" relativeToURL:self.baseUrl];
    if (self.token != nil){
        NSDictionary *parameters = @{@"token": self.token};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
        [manager POST:[url absoluteString] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                //NSLog(@"%@", responseObject);
                [self updateAccount:responseObject];
                [self.delegate finishFetchAccountData:responseObject withAccount:Account.sharedManager];
            } else {
                NSLog(@"%@", responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    }
    else {
        NSURL *url = [NSURL URLWithString:@"login" relativeToURL:self.baseUrl];
        
        NSString *email = [SSKeychain passwordForService:self.serviceName account:self.serviceAccount];
        NSString *password = [SSKeychain passwordForService:self.serviceName account:self.servicePassword];
            if(email !=nil && password !=nil){
            NSDictionary *parameters = @{@"email": email, @"password": password};

            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
            
            [manager POST:[url absoluteString] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    [self updateAccount:responseObject];
                    [self.delegate finishFetchAccountData:responseObject withAccount:Account.sharedManager];
                } else {
                    NSLog(@"%@", responseObject);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@", error);
            }];

        }
    }

}

-(void) location:(httpMethod)httpMethod withLocation:(NSDictionary *)location{
    
        NSString *token = self.token;
        NSDictionary *parameters = @{@"token": token, @"name": [location valueForKey:@"name"],@"location":[location valueForKey:@"location"]};
        //NSLog(@"%@",token);
    
        NSURL *url = [NSURL URLWithString:@"account/location" relativeToURL:self.baseUrl];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        if (httpMethod == PUT) {
        [manager PUT:[url absoluteString] parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                [self updateAccount:responseObject];
                [self.delegate finishFetchAccountData:responseObject withAccount:Account.sharedManager];
            } else {
                NSLog(@"%@", responseObject);
            }

        }failure:^(NSURLSessionDataTask * _Nonnull task, NSError *error){
            NSLog(@"%@", error);
        }];
    }
    else if (httpMethod == DELETE){
        [manager DELETE:[url absoluteString] parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                [self updateAccount:responseObject];
                [self.delegate finishFetchAccountData:responseObject withAccount:Account.sharedManager];
            } else {
                NSLog(@"%@", responseObject);
            }
            
        }failure:^(NSURLSessionDataTask * _Nonnull task, NSError *error){
            NSLog(@"%@", error);
        }];
    }
}

-(void)address:(httpMethod)httpMethod withAddress:(NSDictionary *)address{
    NSString *token = self.token;
    NSDictionary *parameters;
    if (httpMethod == POST) {
         parameters = @{@"token": token, @"address": [address valueForKey:@"address"],@"phone":
                                         [address valueForKey:@"phone"],@"name":[address valueForKey:@"name"],@"type":[address valueForKey:@"type"],@"addrId":[address valueForKey:@"_id"]};
    }else{
        parameters = @{@"token": token, @"address": [address valueForKey:@"address"],@"phone":
                                         [address valueForKey:@"phone"],@"name":[address valueForKey:@"name"],@"type":[address valueForKey:@"type"]};
    }
    
    
    NSURL *url = [NSURL URLWithString:@"account/address" relativeToURL:self.baseUrl];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    if (httpMethod == PUT) {
        [manager PUT:[url absoluteString] parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                [self updateAccount:responseObject];
                [self.delegate finishFetchAccountData:responseObject withAccount:Account.sharedManager];
            } else {
                NSLog(@"%@", responseObject);
            }
            
        }failure:^(NSURLSessionDataTask * _Nonnull task, NSError *error){
            NSLog(@"%@", error);
        }];
    }
    else if (httpMethod == DELETE){
        [manager DELETE:[url absoluteString] parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                [self updateAccount:responseObject];
                [self.delegate finishFetchAccountData:responseObject withAccount:Account.sharedManager];
            } else {
                NSLog(@"%@", responseObject);
            }
            
        }failure:^(NSURLSessionDataTask * _Nonnull task, NSError *error){
            NSLog(@"%@", error);
        }];
    }
    else if(httpMethod == POST){
        [manager POST:[url absoluteString] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                [self updateAccount:responseObject];
                [self.delegate finishFetchAccountData:responseObject withAccount:Account.sharedManager];
            } else {
                NSLog(@"%@", responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    }
}


@end
