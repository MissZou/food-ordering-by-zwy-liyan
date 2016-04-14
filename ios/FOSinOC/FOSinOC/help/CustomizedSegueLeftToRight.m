//
//  CustomizedSegueLeftToRight.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/14.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "CustomizedSegueLeftToRight.h"

@implementation CustomizedSegueLeftToRight

-(void)perform{
    UIView *sourceView = self.sourceViewController.view;
    UIView *destinationView = self.destinationViewController.view;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    destinationView.frame = CGRectMake(sourceView.frame.origin.x + screenWidth, sourceView.frame.origin.y, screenWidth, screenHeight);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window insertSubview:destinationView aboveSubview:sourceView];
    
//    CGRect destinationFrame = destinationView.frame;
//    
//    destinationFrame = CGRectMake(sourceView.frame.origin.x, sourceView.frame.origin.y, destinationFrame.size.width, destinationFrame.size.height);
    CGRect destinationFrame = CGRectMake(sourceView.frame.origin.x, sourceView.frame.origin.y, screenWidth, screenHeight);
    
    
    [UIView animateWithDuration:0.35 animations:^void{
    
        destinationView.frame = destinationFrame;
   
    }completion:^(BOOL finished){
        
        [self.sourceViewController presentViewController:self.destinationViewController animated:false completion:nil];
    }];
}

@end
