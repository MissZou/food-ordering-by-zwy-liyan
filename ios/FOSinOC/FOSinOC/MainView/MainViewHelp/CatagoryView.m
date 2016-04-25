//
//  CatagoryView.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/22.
//  Copyright © 2016年 李龑. All rights reserved.
//

#define buttonDefaultSpace             10
#define buttonDefaultTag               1060
#define buttonDefaulHeight              45
#define buttonDefaulWidth              70
#define bottomButtonHeight             30
#define tableCellTag                   1160
#import "CatagoryView.h"

@interface CatagoryView()
@property (strong,nonatomic) NSDictionary *catagory;
@property (strong,nonatomic)NSArray *catagoryName;
@property (strong,nonatomic) UIScrollView *catagoryScrollView;
@property (strong,nonatomic)UITableView *tableView;
@property (strong,nonatomic)NSString *tableContentSection;
@property (strong,nonatomic) NSDictionary *subCatagoryDict;
@property (strong,nonatomic) NSArray *subCatagoryName;
@property (strong,nonatomic) NSMutableArray *subCatagoryNumber;

@property(assign,nonatomic)NSInteger lastSelected;
@end

@implementation CatagoryView

-(void)initCatagoryView:(NSDictionary *)catagory{
    self.catagory = catagory;
    
    self.catagoryName = [catagory allKeys];
    [self drawCatagoryView];
    self.tableContentSection = @"All Shop";
    self.lastSelected = -1;
    self.subCatagoryNumber = [[NSMutableArray alloc]init];
}


-(void)drawCatagoryView{
    //draw scroll view
    self.catagoryScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, 0)];
    self.catagoryScrollView.showsVerticalScrollIndicator = NO;
    self.catagoryScrollView.showsHorizontalScrollIndicator = NO;
    self.catagoryScrollView.backgroundColor = [UIColor whiteColor];
    self.catagoryScrollView.contentSize = CGSizeMake(self.frame.size.width/2, (buttonDefaulHeight)*self.catagory.count);
    
    for (int i = 0; i<self.catagory.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, buttonDefaulHeight*i, self.frame.size.width/2, buttonDefaulHeight)];
        
        [btn setTitle:self.catagoryName[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor grayColor];
        NSInteger tag = buttonDefaultTag;
        btn.tag = tag + i;
        [btn addTarget:self action:@selector(catagoryClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.catagoryScrollView addSubview:btn];
        
    }
    //draw table view
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, 0) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell self] forCellReuseIdentifier:@"catagoryCell"];
    
    UIButton *closeButton = [[UIButton alloc]init];
    [closeButton setTitle:@"close" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    closeButton.backgroundColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.25 animations:^{
        self.catagoryScrollView.frame = CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height - bottomButtonHeight);
        self.tableView.frame = CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height - bottomButtonHeight);
        closeButton.frame = CGRectMake(0, self.frame.size.height - bottomButtonHeight, self.frame.size.width, bottomButtonHeight);
    }];
    [self addSubview:self.tableView];
    [self addSubview:self.catagoryScrollView];
    [self addSubview:closeButton];
    
}



-(void)catagoryClicked:(UIButton *)sender{
    //NSLog(@"%@",sender.titleLabel.text);
    
    if (self.lastSelected >= 0) {
        UIButton *lastBtn = (UIButton *)[self viewWithTag:self.lastSelected];
        lastBtn.backgroundColor = [UIColor grayColor];
        [lastBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    self.lastSelected = sender.tag;
    sender.backgroundColor = [UIColor whiteColor];
    [sender setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.tableContentSection = sender.titleLabel.text;
    
    if (![self.tableContentSection isEqualToString:@"All Shop"]) {
        NSDictionary *subCatagory = [self.catagory valueForKey:self.tableContentSection];
        self.subCatagoryDict = subCatagory;
        self.subCatagoryName = [subCatagory allKeys];
        
        for (int i=0; i<self.subCatagoryName.count; i++) {
            [self.subCatagoryNumber addObject: [self.subCatagoryDict valueForKey:self.subCatagoryName[i]]];
        }
        
        [self.tableView reloadData];
    }else{
        [self.delegate finishChooseCatagory:self.tableContentSection];
    }
    
//    NSLog(@"%@",[self.catagory valueForKey:self.tableContentSection]);
//    NSLog(@"%@",self.subCatagoryNumber);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.tableContentSection isEqualToString:@"All Shop"]) {
        return 0;
    }
    NSDictionary *subCatagory = [self.catagory valueForKey:self.tableContentSection];
    return subCatagory.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"catagoryCell" forIndexPath:indexPath];
    if (![self.tableContentSection isEqualToString:@"All Shop"]) {
        if ([cell.contentView subviews].count == 0) {
            UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 80, 30)];
            UILabel *number = [[UILabel alloc]initWithFrame:CGRectMake(90, 5, 30, 30)];
            name.text = self.subCatagoryName[indexPath.row];
            name.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
            name.tag = tableCellTag+1;
            number.tag = tableCellTag+2;
            // number.text = self.subCatagoryNumber[indexPath.row];
            NSNumber *amount = self.subCatagoryNumber[indexPath.row];
            number.text = [amount stringValue];
            [cell.contentView addSubview:name];
            [cell.contentView addSubview:number];
            return cell;
            }
            else{
                UILabel *name = (UILabel *)[cell.contentView viewWithTag: tableCellTag+1];
                UILabel *number = (UILabel *)[cell.contentView viewWithTag: tableCellTag+2];
                name.text = self.subCatagoryName[indexPath.row];
            }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *name = (UILabel *)[cell.contentView viewWithTag: tableCellTag+1];
    [self.delegate finishChooseCatagory:name.text];
    //NSLog(@"%@",name.text);
}

@end
