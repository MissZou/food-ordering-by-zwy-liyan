//
//  CartTableView.m
//  FOSinOC
//
//  Created by MoonSlides on 16/6/26.
//  Copyright © 2016年 李龑. All rights reserved.
//

#define cellHeight 40
#define navigationBarHeight 64
#define tableCellTag 1560

#import "CartTableView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Account.h"

@interface CartTableView()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic) UITableView *tableView;
@property(strong,nonatomic) NSArray *cartDetail;

@property (strong,nonatomic)UIBlurEffect *blurEffet;
@property (strong,nonatomic)UIVisualEffectView *blurEffectView;
@property (strong,nonatomic)Account *myAccount;
@property (assign,nonatomic)CGFloat tableHeight;


@end

@implementation CartTableView

-(void)initCartTableView:(NSArray *)cartDetail{
    NSLog(@"%@",cartDetail);
    self.cartDetail = cartDetail;
    [self initTableView];
    self.myAccount = [Account sharedManager];
}


-(void)initTableView{
    self.tableView = [[UITableView alloc]init];
     self.tableHeight = cellHeight * self.cartDetail.count;
    if (self.tableHeight > [UIScreen mainScreen].bounds.size.height - navigationBarHeight ) {
        self.tableHeight = [UIScreen mainScreen].bounds.size.height - navigationBarHeight;
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - self.tableHeight, self.frame.size.width, self.tableHeight);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell self] forCellReuseIdentifier:@"cartCell"];
    [self addSubview:self.tableView];
    
    self.tableView.frame = CGRectMake(0, self.tableHeight, self.frame.size.width, 0);
    [UIView animateWithDuration:0.7 animations:^{
        self.tableView.frame = CGRectMake(0, 0, self.frame.size.width, self.tableHeight);
    }completion:^(BOOL finished){
        
    }];
}

-(void)dismissCartTableViewAnimation{
        
    [UIView animateWithDuration:0.7 animations:^{
        self.tableView.frame = CGRectMake(0, self.tableHeight, self.frame.size.width, 0);
        
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cartCell" forIndexPath:indexPath];
    if ([cell.contentView subviews].count == 0) {
        //if (cell == nil) {
        
        UILabel *dishName = [[UILabel alloc]initWithFrame:CGRectMake(cellHeight, 0, 60, 30)];
        dishName.text = [self.cartDetail[indexPath.row] valueForKey:@"dishName"];
        dishName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        dishName.tag = tableCellTag+1;
     
        UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(75, 0, 50, 30)];
        //price.text =[[food[indexPath.row] valueForKey:@"price"] stringValue];
        price.text = [NSString stringWithFormat:@"%@%@",@"$: ",[[self.cartDetail[indexPath.row] valueForKey:@"price"] stringValue]];
        price.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        price.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        price.tag = tableCellTag+3;
        
        UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 30, 0, 20, 20 )];
        [addButton setImage:[UIImage imageNamed:@"plusBlue.png"] forState:UIControlStateNormal];
        //addButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        addButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        addButton.imageView.clipsToBounds = true;
        addButton.layer.cornerRadius = 2;
        addButton.layer.masksToBounds = true;
        [addButton addTarget:self action:@selector(addButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        //addButton.backgroundColor = myBlueColor;
        addButton.tag = tableCellTag+4;
        
        UILabel *amount = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 30, 0, 20, 20 )];
        amount.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        amount.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        amount.textAlignment = NSTextAlignmentCenter;
        
        amount.tag = tableCellTag + 5;
        
        UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 30, 0, 20, 20 )];
        [deleteButton setImage:[UIImage imageNamed:@"minusBlue.png"] forState:UIControlStateNormal];
        deleteButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        deleteButton.imageView.clipsToBounds = true;
        //deleteButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        deleteButton.layer.cornerRadius = 2;
        deleteButton.layer.masksToBounds = true;
        [deleteButton addTarget:self action:@selector(deleteButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        
        //deleteButton.backgroundColor = myBlueColor;
        deleteButton.tag = tableCellTag+6;
        
        
        for (int i=0; i<self.myAccount.cart.count; i++) {
            if ([[self.cartDetail[indexPath.row] valueForKey:@"_id"] isEqualToString:[self.myAccount.cart[i] valueForKey:@"itemId"]]) {
                amount.text = [[self.myAccount.cart[i] valueForKey:@"amount"] stringValue];
                if ([[self.myAccount.cart[i] valueForKey:@"amount"] integerValue] != 0) {
                    deleteButton.frame = CGRectMake(self.frame.size.width - 70, 0, 20, 20 );
                    amount.frame = CGRectMake(self.frame.size.width - 50, 0, 20, 20 );
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
        deleteButton.frame = CGRectMake(self.frame.size.width - 30, 0, 20, 20 );
        amount.frame = CGRectMake(self.frame.size.width - 30, 0, 20, 20 );
        for (int i=0; i<self.myAccount.cart.count; i++) {
            if ([[self.cartDetail[indexPath.row] valueForKey:@"_id"] isEqualToString:[self.myAccount.cart[i] valueForKey:@"itemId"]]) {
                amount.text = [[self.myAccount.cart[i] valueForKey:@"amount"] stringValue];
                if ([[self.myAccount.cart[i] valueForKey:@"amount"] integerValue] != 0) {
                    deleteButton.frame = CGRectMake(self.frame.size.width - 70, 0, 20, 20 );
                    amount.frame = CGRectMake(self.frame.size.width - 50, 0, 20, 20 );
                }
                else{
                    deleteButton.frame = CGRectMake(self.frame.size.width - 30, 0, 20, 20 );
                    amount.frame = CGRectMake(self.frame.size.width - 30, 0, 20, 20 );
                }
            }
        }
        
        [deleteButton addTarget:self action:@selector(deleteButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }

}

@end
