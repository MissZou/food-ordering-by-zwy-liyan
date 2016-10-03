//
//  PlaceOrderViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/6/28.
//  Copyright © 2016年 李龑. All rights reserved.
//
#define myGreenColor [UIColor colorWithRed:91/255.0 green:207/255.0 blue:122/255.0 alpha:1]
#define myGreenColorHighlight [UIColor colorWithRed:76/255.0 green:134/255.0 blue:91/255.0 alpha:1]
#define myBlackColor [UIColor colorWithRed:61/255.0 green:61/255.0 blue:61/255.0 alpha:1]
#define myBlackIron [UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1]
#define myBlackSteel [UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:1]

#define bottomViewHeight 50
#define tableCellTag 1760

#define statusCreated @"created"
#define statusShipped @"shipped"
#define statusConfirmed @"confirmed"

#import "PlaceOrderViewController.h"
#import "Account.h"
#import "Shop.h"
#import "Order.h"

#import "ShopDetailedViewController.h"
#import "ChooseAddressViewController.h"
#import "WriteMessageViewController.h"
#import "OrderInfoViewController.h"

@interface PlaceOrderViewController ()<UITableViewDelegate,UITableViewDataSource,ChooseAddressViewDelegate,WriteMessageViewDelegate, AccountDelegate>
@property (strong,nonatomic) UIView *bottomView;
@property (strong,nonatomic) UIButton *payButton;
@property (assign,nonatomic) NSUInteger totalPrice;
@property (assign,nonatomic) NSUInteger totalItemCount;
@property (strong,nonatomic) UILabel *priceLabel;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) Account *myAccount;
@property (strong,nonatomic) Shop *myShop;
@property (strong,nonatomic) NSMutableArray *shopList;
@property (copy,nonatomic) NSString* message;
@property (strong,nonatomic)UILabel *messageLabel;
@property (strong,nonatomic) NSDictionary *address;
@property (strong, nonatomic) Order *order;
@end

@implementation PlaceOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self initBottomView];
    self.myAccount = [Account sharedManager];
    self.myAccount.delegate = self;
    self.myShop = [Shop sharedManager];
//    self.navigationController.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
//    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
//    self.navigationController.navigationBar.layer.shadowRadius = 4.0f;
//    self.navigationController.navigationBar.layer.shadowOpacity = 0.3f;
    UILabel *vcName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 30)];
    vcName.text = @"Place Order";
    vcName.textAlignment = NSTextAlignmentCenter;
    vcName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    vcName.textColor = myBlackIron;
    self.navigationItem.titleView = vcName;
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
    self.navigationItem.backBarButtonItem = backBarButton;
    self.message = nil;
    //[self.myAccount order:GET withShopId:nil items:nil price:0 address:nil message:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.myAccount.cartDetail.count >0) {
        [self cleanShopData];
        [self.tableView reloadData];
    }else{
        //No items in cart
        //NSLog(@"cart detailed %@",self.myAccount.cartDetail);
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initBottomView{
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - bottomViewHeight, self.view.frame.size.width, bottomViewHeight)];
    self.bottomView.backgroundColor = myBlackColor;
    
    self.priceLabel = [[UILabel alloc]init];
    //self.priceLabel.numberOfLines = 0;
    self.priceLabel.text = @"Total Price: $0";
    self.priceLabel.textColor = [UIColor whiteColor];
    self.priceLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    self.priceLabel.frame = CGRectMake(80, 10, 100, 30);
    
    self.payButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 120, 0, 120, bottomViewHeight)];
    [self.payButton setBackgroundColor:myGreenColor];
    [self.payButton setTitle:@"Pay" forState:UIControlStateNormal];
    [self.payButton addTarget:self action:@selector(payButtonHandle) forControlEvents:UIControlEventTouchUpInside];
    [self.payButton addTarget:self action:@selector(payButtonHighlight) forControlEvents:UIControlEventTouchDown];
    self.payButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];

    [self.bottomView addSubview:self.payButton];
    [self.bottomView addSubview:self.priceLabel];
    [self.view addSubview:self.bottomView];
    
}

-(void)initTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - bottomViewHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell self] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tableView];
}

-(void)cleanShopData{
    self.shopList = [[NSMutableArray alloc]init];
    for (int i = 0; i<self.myAccount.cartDetail.count; i++) {
        if ([[self.myAccount.cartDetail[i] valueForKey:@"shopId"] isEqualToString:self.shopId]) {
            [self.shopList addObject:[self.myAccount.cartDetail[i] valueForKey:@"shopId"]];
            break;
        }
    }
    //[self.shopList addObject:[self.myAccount.cartDetail[0] valueForKey:@"shopId"]];
//    for (int i =0; i<self.myAccount.cartDetail.count; i++) {
//        BOOL isFindShop = false;
//        for (int j = 0; j<self.shopList.count; j++) {
//            
//            if ([self.shopList[j] isEqualToString:[self.myAccount.cartDetail[i] valueForKey:@"shopId"]]) {
//                isFindShop = true;
//                break;
//            }
//            
//            if (!isFindShop && j==self.shopList.count - 1) {
//                [self.shopList addObject:[self.myAccount.cartDetail[i] valueForKey:@"shopId"]];
//            }
//        }
//        
//    }
}

#pragma mark - Tableview delegate and Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3+self.shopList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;// first section for delivery address and delivery time
    }else if(section == 1){
        return 1; //payment online or offline
    }else if(section > 1 && section<2+self.shopList.count){
        return 2;// shop and items
    }else{
        return 2;// message
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    if ([cell.contentView subviews].count == 0) {
        if(indexPath.section == 0){
            if(indexPath.row == 0){
                UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 100, 24)];
                name.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                name.tag = tableCellTag+1;
                UILabel *address = [[UILabel alloc]initWithFrame:CGRectMake(20, 35, 100, 24)];
                address.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                address.tag = tableCellTag+2;
                UILabel *phone = [[UILabel alloc]initWithFrame:CGRectMake(125, 5, 100, 24)];
                phone.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                phone.tag = tableCellTag+3;
                UIImageView *separateLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
                separateLine.image = [UIImage imageNamed:@"markLineRed.png"];
                separateLine.clipsToBounds = true;
                separateLine.tag = tableCellTag + 11;
                if (self.myAccount.deliverAddress.count>0) {
                    self.address = self.myAccount.deliverAddress[0];
                    name.text = [self.myAccount.deliverAddress[0] valueForKey:@"name"];
                    address.text = [self.myAccount.deliverAddress[0] valueForKey:@"addr"];
                    phone.text = [self.myAccount.deliverAddress[0] valueForKey:@"phone"];
                }else{
                    name.text = @"Click to create address";
                    self.address = nil;
                }
                [cell.contentView addSubview:name];
                [cell.contentView addSubview:phone];
                [cell.contentView addSubview:address];
                [cell.contentView addSubview:separateLine];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else if(indexPath.row == 1){
                //cell.textLabel.text = @"delivery time";
            }
            
        } if(indexPath.section == 1){
            if (indexPath.row == 0) {
                UILabel *payment = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 100, 30)];
                payment.text = @"Payment";
                payment.tag = tableCellTag + 4;
                payment.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                
                UILabel *payment2 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100, 5, 100, 30)];
                payment2.text = @"Online";
                payment2.tag = tableCellTag + 5;
                payment2.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                [cell.contentView addSubview:payment];
                [cell.contentView addSubview:payment2];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
            }
        } if(indexPath.section > 1 && indexPath.section<2+self.shopList.count){
            if (indexPath.row == 0) {
                int itemCount = 0;
                for (int i = 0; i<self.myAccount.cartDetail.count; i++) {
                    if ([[self.myAccount.cartDetail[i] valueForKey:@"shopId"] isEqualToString:self.shopList[indexPath.section - 2]]) {
                        UILabel *itemName = [[UILabel alloc]initWithFrame:CGRectMake(20, 5 + itemCount*(5+24), 150, 24)];
                        itemName.tag = tableCellTag+6;
                        itemName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                        itemName.text = [self.myAccount.cartDetail[i] valueForKey:@"dishName"];
                        [cell.contentView addSubview:itemName];
                        
                        UILabel *amount = [[UILabel alloc]initWithFrame:CGRectMake(190, 5 + itemCount*(5+24), 80, 24)];
                        amount.tag = tableCellTag+7;
                        amount.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                        amount.text = [NSString stringWithFormat:@"x%@",[[self.myAccount.cartDetail[i] valueForKey:@"amount"] stringValue]];
                        
                        [cell.contentView addSubview:amount];
                        
                        UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(250, 5 + itemCount*(5+24), 100, 24)];
                        price.tag = tableCellTag+8;
                        price.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                        price.text = [NSString stringWithFormat:@"$ %@",[[self.myAccount.cartDetail[i] valueForKey:@"price"] stringValue]];
                        [cell.contentView addSubview:price];
                        
                        itemCount = itemCount+1;
                    }
                }
                
            }  if(indexPath.row == 1){
                UILabel *total = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100, 5, 100, 24)];
                total.tag = tableCellTag+9;
                total.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                NSInteger totalPrice = 0;
                for (int i = 0; i<self.myAccount.cartDetail.count; i++) {
                    if ([[self.myAccount.cartDetail[i] valueForKey:@"shopId"] isEqualToString:self.shopList[indexPath.section - 2]]) {
                       totalPrice = totalPrice + [[self.myAccount.cartDetail[i] valueForKey:@"price"] integerValue]*[[self.myAccount.cartDetail[i] valueForKey:@"amount"] integerValue];
                    }
                }
                self.totalPrice = totalPrice;
                NSString *priceText = [[NSNumber numberWithInteger:totalPrice] stringValue];
                total.text = [NSString stringWithFormat:@"Total $%@",priceText];
                [cell.contentView addSubview:total];
                
                
            }
        } if(indexPath.section == 2+self.shopList.count){
            if (indexPath.row == 0) {
                self.totalItemCount = 0;
                
                for (int i = 0; i<self.myAccount.cartDetail.count; i++) {
                    self.totalItemCount = self.totalItemCount + [[self.myAccount.cartDetail[i] valueForKey:@"amount"] integerValue];
                    
//                    self.totalPrice = self.totalPrice + [[self.myAccount.cartDetail[i] valueForKey:@"amount"] integerValue]*[[self.myAccount.cartDetail[i] valueForKey:@"price"] integerValue];
                }
                UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100, 5, 100, 24)];
                priceLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                priceLabel.text = [NSString stringWithFormat:@"All $%@",[[NSNumber numberWithUnsignedInteger:self.totalPrice] stringValue]];
                [cell.contentView addSubview:priceLabel];
            }else if(indexPath.row == 1){
                self.messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100, 5, 100, 24)];
                self.messageLabel.tag = tableCellTag + 10;
                self.messageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                
                if (self.message) {
                    self.messageLabel.text = self.message;
                    self.messageLabel.frame =CGRectMake(20, 5, self.view.frame.size.width - 40, 24);
                }else{
                    self.messageLabel.text = @"message";
                    self.messageLabel.frame =CGRectMake(self.view.frame.size.width - 100, 5, 100, 24);
                }
                [cell.contentView addSubview:self.messageLabel];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
    }else{
        if ([cell.contentView subviews].count) {
            for (UIView *subview in [cell.contentView subviews]) {
                [subview removeFromSuperview];
            }
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        if(indexPath.section == 0){
            if(indexPath.row == 0){
                UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 100, 24)];
                name.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                name.tag = tableCellTag+1;
                UILabel *address = [[UILabel alloc]initWithFrame:CGRectMake(20, 35, 100, 24)];
                address.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                address.tag = tableCellTag+2;
                UILabel *phone = [[UILabel alloc]initWithFrame:CGRectMake(125, 5, 100, 24)];
                phone.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                phone.tag = tableCellTag+3;
                UIImageView *separateLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
                separateLine.image = [UIImage imageNamed:@"markLineRed.png"];
                separateLine.clipsToBounds = true;
                separateLine.tag = tableCellTag + 11;
//                if (self.myAccount.deliverAddress.count>0) {
//                    name.text = [self.myAccount.deliverAddress[0] valueForKey:@"name"];
//                    address.text = [self.myAccount.deliverAddress[0] valueForKey:@"addr"];
//                    phone.text = [self.myAccount.deliverAddress[0] valueForKey:@"phone"];
//                }
                name.text = [self.address valueForKey:@"name"];
                address.text = [self.address valueForKey:@"addr"];
                phone.text = [self.address valueForKey:@"phone"];
                
                [cell.contentView addSubview:name];
                [cell.contentView addSubview:phone];
                [cell.contentView addSubview:address];
                [cell.contentView addSubview:separateLine];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else if(indexPath.row == 1){
                //cell.textLabel.text = @"delivery time";
                for (int i = 1; i<12; i++) {
                    UILabel *label = (UILabel *)[cell.contentView viewWithTag:tableCellTag+i];
                    [label removeFromSuperview];
                }
            }
            
        } if(indexPath.section == 1){
            if (indexPath.row == 0) {
                UILabel *payment = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 100, 30)];
                payment.text = @"Payment";
                payment.tag = tableCellTag + 4;
                payment.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                
                UILabel *payment2 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100, 5, 100, 30)];
                payment2.text = @"Online";
                payment2.tag = tableCellTag + 5;
                payment2.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                [cell.contentView addSubview:payment];
                [cell.contentView addSubview:payment2];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        } if(indexPath.section > 1 && indexPath.section<2+self.shopList.count){
            if (indexPath.row == 0) {
                int itemCount = 0;
                for (int i = 0; i<self.myAccount.cartDetail.count; i++) {
                    if ([[self.myAccount.cartDetail[i] valueForKey:@"shopId"] isEqualToString:self.shopList[indexPath.section - 2]]) {
                        //if ([cell.contentView viewWithTag:tableCellTag+6] == nil) {
                            UILabel *itemName = [[UILabel alloc]initWithFrame:CGRectMake(20, 5 + itemCount*(5+24), 150, 24)];
                            itemName.tag = tableCellTag+6;
                            itemName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                            itemName.text = [self.myAccount.cartDetail[i] valueForKey:@"dishName"];
                            [cell.contentView addSubview:itemName];
                        //}
                        
                        //if ([cell.contentView viewWithTag:tableCellTag+7] == nil) {
                        UILabel *amount = [[UILabel alloc]initWithFrame:CGRectMake(190, 5 + itemCount*(5+24), 80, 24)];
                        amount.tag = tableCellTag+7;
                        amount.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                        amount.text = [NSString stringWithFormat:@"x%@",[[self.myAccount.cartDetail[i] valueForKey:@"amount"] stringValue]];
                        [cell.contentView addSubview:amount];
                        //}
                        //if ([cell.contentView viewWithTag:tableCellTag+8] == nil) {
                        UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(250, 5 + itemCount*(5+24), 100, 24)];
                        price.tag = tableCellTag+8;
                        price.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                        price.text = [NSString stringWithFormat:@"$ %@",[[self.myAccount.cartDetail[i] valueForKey:@"price"] stringValue]];
                        [cell.contentView addSubview:price];
                        itemCount = itemCount+1;
                        //}
                    }
                }
                
            }  if(indexPath.row == 1){
            
                UILabel *total = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100, 5, 100, 24)];
                total.tag = tableCellTag+9;
                total.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                NSInteger totalPrice = 0;
                
                for (int i = 0; i<self.myAccount.cartDetail.count; i++) {
                    if ([[self.myAccount.cartDetail[i] valueForKey:@"shopId"] isEqualToString:self.shopList[indexPath.section - 2]]) {
                        
                        totalPrice = totalPrice + [[self.myAccount.cartDetail[i] valueForKey:@"price"] integerValue]*[[self.myAccount.cartDetail[i] valueForKey:@"amount"] integerValue];
                    }
                }
                self.totalPrice = totalPrice;
                NSString *priceText = [[NSNumber numberWithInteger:totalPrice] stringValue];
                total.text = [NSString stringWithFormat:@"Total $%@",priceText];
                [cell.contentView addSubview:total];
                
            }
        } if(indexPath.section == 2+self.shopList.count){
            if (indexPath.row == 0) {
                self.totalItemCount = 0;
                
                NSInteger totalPrice = 0;
                for (int i = 0; i<self.myAccount.cartDetail.count; i++) {
                    self.totalItemCount = self.totalItemCount + [[self.myAccount.cartDetail[i] valueForKey:@"amount"] integerValue];
                    
                    totalPrice = totalPrice + [[self.myAccount.cartDetail[i] valueForKey:@"price"] integerValue]*[[self.myAccount.cartDetail[i] valueForKey:@"amount"] integerValue];
                }
                UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100, 5, 100, 24)];
                priceLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                priceLabel.text = [NSString stringWithFormat:@"All $%@",[[NSNumber numberWithUnsignedInteger:self.totalPrice] stringValue]];
                [cell.contentView addSubview:priceLabel];
             
            }else if(indexPath.row == 1){
                self.messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100, 5, 100, 24)];
                self.messageLabel.tag = tableCellTag + 10;
                self.messageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                if (self.message) {
                    self.messageLabel.text = self.message;
                    self.messageLabel.frame =CGRectMake(20, 5, self.view.frame.size.width - 40, 24);
                }else{
                    self.messageLabel.text = @"message";
                    self.messageLabel.frame =CGRectMake(self.view.frame.size.width - 100, 5, 100, 24);
                }
                [cell.contentView addSubview:self.messageLabel];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }

    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section > 1 && section<2+self.shopList.count){
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        //headVieww.backgroundColor = [UIColor redColor];
        headView.userInteractionEnabled = true;
        headView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headViewTouchHandle:)];
        [headView addGestureRecognizer:tapGesture];
        
        
        UILabel *shopName = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, 120, 20)];
        shopName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        shopName.textColor = myBlackSteel;
        for (int i = 0; i<self.myAccount.cartDetail.count; i++) {
            if ([[self.myAccount.cartDetail[i] valueForKey:@"shopId"] isEqualToString:self.shopList[section -2]]) {// minus 2 is for the non-shop section 0,1
                shopName.text = [self.myAccount.cartDetail[i] valueForKey:@"shopName"];
                break;
            }
        }
        
        UIImageView *shopIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 20, 20)];
        shopIcon.clipsToBounds = true;
        shopIcon.image = [UIImage imageNamed:@"shopIcon"];
        
        [headView addSubview:shopIcon];
        [headView addSubview:shopName];
        return headView;
    }
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section > 1 && section<2+self.shopList.count){
        return 30;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 62;
        }
    }else if(indexPath.section > 1 && indexPath.section<2+self.shopList.count){
        CGFloat height = 0;
        if (indexPath.row == 0) {
            for (int i = 0; i<self.myAccount.cartDetail.count; i++) {
                if ([[self.myAccount.cartDetail[i] valueForKey:@"shopId"] isEqualToString:self.shopList[indexPath.section - 2]]) {
                    height = height+30;
                }
            }
            return height;
        }
        
    }
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self performSegueWithIdentifier:@"address" sender:self];
    }else if (indexPath.section == 2+self.shopList.count && indexPath.row == 1) {
        [self performSegueWithIdentifier:@"message" sender:self];
    }
}

#pragma mark - Button Handle
- (NSMutableArray *)cleanItemData:(NSMutableArray *)items {
    NSMutableArray *cleanedItems = [[NSMutableArray alloc]init];
    for (int i = 0; i<items.count; i++) {
        NSDictionary *item = @{@"amount":[items[i] valueForKey:@"amount"],@"itemId":[items[i] valueForKey:@"_id"]};
        [cleanedItems addObject:item];
    }
    return cleanedItems;
}

- (void)payButtonHandle{
    [self.payButton setBackgroundColor:myGreenColor];
    NSMutableArray *itemsofThisShop = [[NSMutableArray alloc] init];
    for (int i = 0; i<self.myAccount.cartDetail.count; i++) {
        if ([[self.myAccount.cartDetail[i] valueForKey:@"shopId"] isEqualToString:self.shopId]) {
            [itemsofThisShop addObject:self.myAccount.cartDetail[i]];
        }
    }
    
    [self.myAccount order:PUT withShopId:self.shopId items:[self cleanItemData:itemsofThisShop] price:self.totalPrice address:self.address message:self.message];
    
    [self performSegueWithIdentifier:@"paysuccess" sender:nil];
    
}



-(void)payButtonHighlight{
    [self.payButton setBackgroundColor:myGreenColorHighlight];
}

-(void)headViewTouchHandle:(UITapGestureRecognizer *)tapGesture{
    CGPoint pointInView = [tapGesture locationInView:self.view];
    CGPoint pointInTable = [tapGesture locationInView:self.tableView];
    NSLog(@"in view %f %f",pointInView.x, pointInView.y);
    NSLog(@"in view %f %f",pointInTable.x, pointInTable.y);
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:pointInTable];
    NSLog(@"clicked section %ld",indexPath.section);
    [self performSegueWithIdentifier:@"showshop" sender:self.shopList[indexPath.section - 2]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqual: @"showshop"]) {
        ShopDetailedViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.shopID = sender;
    } else if ([segue.identifier isEqual: @"address"]) {
        ChooseAddressViewController *destinationVC = segue.destinationViewController;
        destinationVC.delegate = self;
    }else if ([segue.identifier isEqual: @"message"]) {
        WriteMessageViewController *destinationVC = segue.destinationViewController;
        destinationVC.delegate = self;
        destinationVC.message = self.message;
    } else if ([segue.identifier isEqualToString:@"paysuccess"]) {
        NSMutableArray *itemsofThisShop = [[NSMutableArray alloc] init];
        for (int i = 0; i<self.myAccount.cartDetail.count; i++) {
            if ([[self.myAccount.cartDetail[i] valueForKey:@"shopId"] isEqualToString:self.shopId]) {
                [itemsofThisShop addObject:self.myAccount.cartDetail[i]];
                
            }
        }
        OrderInfoViewController *destinationVC = segue.destinationViewController;
        destinationVC.itemList = [itemsofThisShop copy];
        destinationVC.shopName = self.shopName;
        destinationVC.shopImage = self.shopImage;
        destinationVC.address = self.address;
        destinationVC.orderStatus = statusCreated;
        destinationVC.totalPrice = (long *)self.totalPrice;
    }
}

-(void)ChooseAddressViewDidSelectedAddressWithName:(NSString *)name phone:(NSString *)phone address:(NSString *)address addrDict:(NSDictionary *)addrDict{
    self.address = addrDict;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:tableCellTag+1];
    UILabel *phoneLabel = (UILabel *)[cell.contentView viewWithTag:tableCellTag+3];
    UILabel *addressLabel = (UILabel *)[cell.contentView viewWithTag:tableCellTag+2];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        nameLabel.text = name;
        phoneLabel.text = phone;
        addressLabel.text = address;
    });
}

-(void)WriteMessageViewFinishEnterWithMessage:(NSString *)message{
    self.message = message;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.messageLabel.text = message;
        self.messageLabel.frame =CGRectMake(20, 5, self.view.frame.size.width - 40, 24);
    });
}

@end
