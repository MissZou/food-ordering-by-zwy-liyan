//
//  Account.h
//  FOSinOC
//
//  Created by MoonSlides on 16/4/9.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import <UIKit/UIKit.h>
//static NSString *serviceName = @"com.HKU.FoodOrderingYystem";
//static NSString *serviceAccount = @"fosAccount";
//static NSString *servicePassword = @"fosPassword";
@class Account;
@protocol AccountDelegate

@optional
-(void)finishCreateAccount:(NSDictionary *)result withAccount:(Account *)myAccount;
-(void)finishFetchAccountData:(NSDictionary *)result withAccount:(Account *)myAccount;
-(void)finishRefresh;

@end

@interface Account : NSObject

@property(copy, nonatomic) NSString *serviceName;
@property(copy,nonatomic) NSString *serviceAccount;
@property(copy,nonatomic) NSString *servicePassword;
@property(copy, nonatomic) NSString *serviceToken;

@property(copy,nonatomic)NSString *email;
@property(copy,nonatomic)NSString *name;
@property(copy,nonatomic)NSString *phone;
@property(copy,nonatomic)NSString *password;
@property(copy,nonatomic)NSString *photoUrl;
@property(strong,nonatomic)NSMutableArray *deliverAddress;
@property(copy,nonatomic)NSString *accountId;
@property(strong,nonatomic)NSMutableArray *location;
@property(copy,nonatomic)NSString *token;

@property(weak)id <AccountDelegate> delegate;

typedef NS_ENUM(NSUInteger, httpMethod){
    GET = 0,
    POST,
    PUT,
    DELETE
};

+(Account *) sharedManager;
-(void) login:(Account *)model;
-(void)createAccount:(Account *)model;
-(void) checkLogin;
-(void) location:(enum httpMethod)httpMethod withLocation:(NSString *)location;
-(void)address:(httpMethod)httpMethod withAddress:(NSDictionary *)address;
@end
