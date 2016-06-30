//
//  CartTableView.m
//  FOSinOC
//
//  Created by MoonSlides on 16/6/26.
//  Copyright © 2016年 李龑. All rights reserved.
//

#define cellHeight 50
#define headerViewHeight 40
#define navigationBarHeight 64
#define tableCellTag 1560

#define myBlueColor [UIColor colorWithRed:69/255.0 green:83/255.0 blue:153/255.0 alpha:1]


#import "CartTableView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Account.h"
#import "Shop.h"

@interface CartTableView()<UITableViewDelegate,UITableViewDataSource,AccountDelegate>



@property (strong,nonatomic)UIBlurEffect *blurEffet;
@property (strong,nonatomic)UIVisualEffectView *blurEffectView;
@property (assign,nonatomic)CGFloat tableHeight;
@property(assign,nonatomic) NSUInteger totalItemCount;
@property(assign,nonatomic) NSUInteger itemCount;

@property (strong,nonatomic)Account *myAccount;
@property (strong,nonatomic) Shop *myShop;


@end

@implementation CartTableView

-(void)initCartTableView:(NSArray *)cartDetail{
    
    self.cartDetail = [cartDetail mutableCopy];
    [self initTableView];
    self.myAccount = [Account sharedManager];
    self.myShop = [Shop sharedManager];
    
}


-(void)initTableView{
    self.tableView = [[UITableView alloc]init];
     self.tableHeight = cellHeight * (self.cartDetail.count) + headerViewHeight;
    if (self.tableHeight > [UIScreen mainScreen].bounds.size.height - navigationBarHeight ) {
        self.tableHeight = [UIScreen mainScreen].bounds.size.height - navigationBarHeight;
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - self.tableHeight, self.frame.size.width, self.tableHeight);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell self] forCellReuseIdentifier:@"cartCell"];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, headerViewHeight)];
    headView.backgroundColor = [UIColor redColor];
    self.tableView.tableHeaderView = headView;
    //[self addSubview:headView];
    [self addSubview:self.tableView];
    
    self.tableView.frame = CGRectMake(0, self.tableHeight, self.frame.size.width, 0);
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.frame = CGRectMake(0, 0, self.frame.size.width, self.tableHeight);
    }completion:^(BOOL finished){
        
    }];
}

-(void)dismissCartTableViewAnimation{
    //self.tableView.frame = CGRectMake(0, 0, self.frame.size.width, self.tableHeight);
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.frame = CGRectMake(0, self.tableHeight+self.tableView.frame.origin.y, self.frame.size.width, 0);
        
    }completion:^(BOOL finished){
        [self.delegate cartTableViewDidFinishDismissAnimation];
        
    }];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cartDetail.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return false;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cartCell" forIndexPath:indexPath];
    if ([cell.contentView subviews].count == 0) {
        //if (cell == nil) {
        
        UILabel *dishName = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 100, 40)];
        dishName.text = [self.cartDetail[indexPath.row] valueForKey:@"dishName"];
        dishName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        dishName.tag = tableCellTag+1;
     
        UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 150, 10, 50, 30)];
        //price.text =[[food[indexPath.row] valueForKey:@"price"] stringValue];
        price.text = [NSString stringWithFormat:@"%@%@",@"$: ",[[self.cartDetail[indexPath.row] valueForKey:@"price"] stringValue]];
        price.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        price.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        price.tag = tableCellTag+3;
        
        UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 30, 15, 20, 20 )];
        [addButton setImage:[UIImage imageNamed:@"plusBlue.png"] forState:UIControlStateNormal];
        //addButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        addButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        addButton.imageView.clipsToBounds = true;
        addButton.layer.cornerRadius = 2;
        addButton.layer.masksToBounds = true;
        [addButton addTarget:self action:@selector(addButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        //addButton.backgroundColor = myBlueColor;
        addButton.tag = tableCellTag+4;
        
        UILabel *amount = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 30, 15, 20, 20 )];
        amount.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        amount.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        amount.textAlignment = NSTextAlignmentCenter;
        
        amount.tag = tableCellTag + 5;
        
        UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 30, 15, 20, 20 )];
        [deleteButton setImage:[UIImage imageNamed:@"minusBlue.png"] forState:UIControlStateNormal];
        deleteButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        deleteButton.imageView.clipsToBounds = true;
        
        deleteButton.layer.cornerRadius = 2;
        deleteButton.layer.masksToBounds = true;
        [deleteButton addTarget:self action:@selector(deleteButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        
        //deleteButton.backgroundColor = myBlueColor;
        deleteButton.tag = tableCellTag+6;
        
        
        for (int i=0; i<self.myAccount.cartDetail.count; i++) {
            if ([[self.cartDetail[indexPath.row] valueForKey:@"_id"] isEqualToString:[self.myAccount.cartDetail[i] valueForKey:@"_id"]]) {
                amount.text = [[self.myAccount.cartDetail[i] valueForKey:@"amount"] stringValue];
                if ([[self.myAccount.cartDetail[i] valueForKey:@"amount"] integerValue] != 0) {
                    deleteButton.frame = CGRectMake(self.frame.size.width - 70, 15, 20, 20 );
                    amount.frame = CGRectMake(self.frame.size.width - 50, 15, 20, 20 );
                }
            }
        }
        
        
        [cell.contentView addSubview:dishName];
        
        [cell.contentView addSubview:price];
        
        [cell.contentView addSubview:amount];
        [cell.contentView addSubview:deleteButton];
        [cell.contentView addSubview:addButton];
        return cell;
    }else{
        
        UILabel *dishName = (UILabel *)[cell.contentView viewWithTag:tableCellTag+1];

        UILabel *price = (UILabel *)[cell.contentView viewWithTag:tableCellTag+3];
        UIButton *addButton = (UIButton *)[cell.contentView viewWithTag:tableCellTag+4];
        UILabel *amount = (UILabel *)[cell.contentView viewWithTag:tableCellTag+5];
        UIButton *deleteButton = (UIButton *)[cell.contentView viewWithTag:tableCellTag+6];
        dishName.text = [self.cartDetail[indexPath.row] valueForKey:@"dishName"];
        price.text = [NSString stringWithFormat:@"%@%@",@"$: ",[[self.cartDetail[indexPath.row] valueForKey:@"price"] stringValue]];
        [addButton addTarget:self action:@selector(addButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        
        // error mark why add deleteButton.frame and amount.frame make the if condition work?
        deleteButton.frame = CGRectMake(self.frame.size.width - 30, 15, 20, 20 );
        amount.frame = CGRectMake(self.frame.size.width - 30, 15, 20, 20 );
        for (int i=0; i<self.myAccount.cartDetail.count; i++) {
            if ([[self.cartDetail[indexPath.row] valueForKey:@"_id"] isEqualToString:[self.myAccount.cartDetail[i] valueForKey:@"shopId"]]) {
                amount.text = [[self.myAccount.cartDetail[i] valueForKey:@"amount"] stringValue];
                if ([[self.myAccount.cartDetail[i] valueForKey:@"amount"] integerValue] != 0) {
                    deleteButton.frame = CGRectMake(self.frame.size.width - 70, 15, 20, 20 );
                    amount.frame = CGRectMake(self.frame.size.width - 50, 15, 20, 20 );
                }
                else{
                    deleteButton.frame = CGRectMake(self.frame.size.width - 30, 15, 20, 20 );
                    amount.frame = CGRectMake(self.frame.size.width - 30, 15, 20, 20 );
                }
            }
        }
        
        [deleteButton addTarget:self action:@selector(deleteButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }

}

-(void)deleteItemOfCart:(CGPoint )addButtonLocation{
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:addButtonLocation];
    UITableViewCell *targetCell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSInteger amount = [[self.myAccount.cartDetail[indexPath.row] valueForKey:@"amount"] integerValue];
    UILabel *amountLable = (UILabel *)[targetCell.contentView viewWithTag:tableCellTag+5];
    
    if (amount > 1) {
        amount = amount - 1;
        NSNumber *amountOjb = [NSNumber numberWithInteger:amount];
        
        [self.myAccount cart:POST withShopId:self.myShop.shopID  itemId:[self.myAccount.cartDetail[indexPath.row] valueForKey:@"_id"] amount:amountOjb  cartId:[self.myAccount.cartDetail[indexPath.row] valueForKey:@"cartId"] index:0 count:0];
        
        self.totalItemCount = self.totalItemCount - 1;
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // To do update cartBadge text here
            amountLable.text = [amountOjb stringValue];
        });
    }else if(amount == 1){
        
        UIButton *deleteButton = (UIButton *)[targetCell.contentView viewWithTag:tableCellTag+6];
        
        [UIView animateWithDuration:0.3 animations:^{ //2.0
            deleteButton.frame = CGRectMake(self.frame.size.width - 30, 15, 20, 20 );
            amountLable.frame = CGRectMake(self.frame.size.width - 30, 15, 20, 20 );
        }completion:^(BOOL finished){
            
            [self.cartDetail removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            
            [self.myAccount cart:DELETE withShopId:self.myShop.shopID  itemId:[self.myAccount.cartDetail[indexPath.row] valueForKey:@"_id"] amount:nil  cartId:[self.myAccount.cartDetail[indexPath.row] valueForKey:@"cartId"] index:0 count:0];
            self.tableHeight = cellHeight * (self.cartDetail.count) + headerViewHeight;
            CGRect frame = self.tableView.frame;

            [UIView animateWithDuration:0.5 animations:^{
                self.tableView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, self.tableHeight);
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y+cellHeight, self.frame.size.width, self.tableHeight);
            }];
            
        }];
        
        
    }
    
    


}
-(void)addItemToCart:(CGPoint )addButtonLocation{
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:addButtonLocation];
    UITableViewCell *targetCell = [self.tableView cellForRowAtIndexPath:indexPath];

    //NSLog(@"select food %@",food[indexPath.row]);
    
    
    // to find item already in cart and modify the count
    
    NSInteger amount = [[self.myAccount.cartDetail[indexPath.row] valueForKey:@"amount"] integerValue];
    amount = amount+1;
    NSNumber *amountOjb = [NSNumber numberWithInteger:amount];
    
    [self.myAccount cart:POST withShopId:self.myShop.shopID  itemId:[self.myAccount.cartDetail[indexPath.row] valueForKey:@"_id"] amount:amountOjb  cartId:[self.myAccount.cartDetail[indexPath.row] valueForKey:@"cartId"] index:0 count:0];
    
    self.totalItemCount = self.totalItemCount + 1;
    UILabel *amountLable = (UILabel *)[targetCell.contentView viewWithTag:tableCellTag+5];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // To do update cartBadge text here
            amountLable.text = [amountOjb stringValue];
    });
}

-(void)addButtonHandle:(id)sender{
    CGPoint location = [sender convertPoint:CGPointZero toView:self.tableView];
    
    [self addItemToCart:location];
    
}
-(void)deleteButtonHandle:(id)sender{
    
    CGPoint location = [sender convertPoint:CGPointZero toView:self.tableView];
    [self deleteItemOfCart:location];
}
@end
