//
//  SlideButtonView.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/20.
//  Copyright © 2016年 李龑. All rights reserved.
//

#define buttonDefaultSpace             10
#define buttonDefaultTag                960
#define buttonDefaulWidth           50

#import "SlideButtonView.h"

@interface SlideButtonView ()

@property(strong,nonatomic)NSArray *buttonTitle;
@property(strong,nonatomic)UIScrollView *buttonScrollView;
@end

@implementation SlideButtonView
+(id)initSlideButton:(NSArray *)buttonTitle{
    return [[self alloc]initSlideButtonConvenience:buttonTitle];
}

-(id)initSlideButtonConvenience:(NSArray *)buttonTitle{
    if (self = [super init]) {
        self.buttonTitle = buttonTitle;
        [self drawScrollView];
        
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
    }
    return self;
}

-(void)addTitle:(NSArray *)buttonTitle{
    self.buttonTitle = buttonTitle;
    [self drawScrollView];
}

-(void)drawScrollView{
    UIScrollView *myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    myScrollView.backgroundColor = [UIColor whiteColor];
    
    myScrollView.contentSize = CGSizeMake((buttonDefaulWidth + buttonDefaultSpace)* self.buttonTitle.count + buttonDefaultSpace, self.frame.size.height);
    //myScrollView.delegate = self;
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.showsHorizontalScrollIndicator = NO;
    self.buttonScrollView = myScrollView;
    [self addSubview:self.buttonScrollView];
    
    CGSize stringSizeSecond;
    for (int i=0; i<self.buttonTitle.count; i++) {
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15]};
        CGSize stringSizeFirst = [self.buttonTitle[i] sizeWithAttributes:attribute];
        if (i != 0) {
             stringSizeSecond = [self.buttonTitle[i-1] sizeWithAttributes:attribute];
        }
        else{
             stringSizeSecond = [self.buttonTitle[0] sizeWithAttributes:attribute];
        }
        
        CGFloat btnX = 0;
        for (int j = 0; j<i; j++) {
            btnX = btnX + [self.buttonTitle[j] sizeWithAttributes:attribute].width;
        }
        btnX = btnX + i*buttonDefaultSpace;
        //UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(buttonDefaultSpace+(buttonDefaultSpace + stringSizeSecond.width)*i,0,stringSizeFirst.width,self.frame.size.height-buttonDefaultSpace)];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(btnX  ,0,stringSizeFirst.width,self.frame.size.height-buttonDefaultSpace)];
        NSLog(@"%f,%f",btn.frame.origin.x,btn.frame.size.width);
        btn.titleLabel.adjustsFontSizeToFitWidth = NO;
        btn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        
        //btn.titleLabel.textColor = [UIColor redColor];
        
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [btn setTitle:self.buttonTitle[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        NSInteger tag = buttonDefaultTag;
        btn.tag = tag + i;
        [btn addTarget:self action:@selector(titleClicked:) forControlEvents:UIControlEventTouchUpInside];
        [myScrollView addSubview:btn];
        //[self addSubview:btn];
    }
    
}
-(void)titleClicked:(UIButton *)sender{
    NSLog(@"%@",sender.titleLabel.text);
}

-(void)markButtonSelected:(NSInteger)tag{
    
}

@end
