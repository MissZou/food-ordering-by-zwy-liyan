//
//  CustomizationButton.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/7.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "CustomizationButton.h"

@interface CustomizationButton ()

@end

@implementation CustomizationButton

-(id) initWithCoder:(NSCoder *)aDecoder {
    if((self = [super initWithCoder:aDecoder])){
        self.layer.cornerRadius = 4.0;
        self.clipsToBounds = true;
        self.backgroundColor = [UIColor colorWithRed:69/255.0 green:83/255.0 blue:153/255.0 alpha:1];
    }
    return self;
}



-(void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if(highlighted){
        self.backgroundColor = [UIColor colorWithRed:83/255.0 green:98/255.0 blue:178/255.0 alpha:1];
    } else {
        self.backgroundColor = [UIColor colorWithRed:69/255.0 green:83/255.0 blue:153/255.0 alpha:1];
    }
}

@end
