//
//  EditAddressViewController.h
//  FOSinOC
//
//  Created by MoonSlides on 16/4/16.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"
@interface EditAddressViewController : UIViewController<UITextFieldDelegate>
@property(copy,nonatomic)NSString *passName;
@property(copy,nonatomic)NSString *passPhone;
@property(copy,nonatomic)NSString *passAddress;
@property(copy,nonatomic)NSString *passAddrId;
@property(assign,nonatomic)BOOL isEditing;

@end
