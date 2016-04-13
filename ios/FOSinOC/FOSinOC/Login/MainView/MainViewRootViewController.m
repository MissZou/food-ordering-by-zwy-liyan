//
//  MainViewRootViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/12.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "MainViewRootViewController.h"

@interface MainViewRootViewController ()
@property (weak, nonatomic) IBOutlet UIView *leftMenu;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@property CGFloat leftMenuWidth;

@property (strong,nonatomic)UISwipeGestureRecognizer *swipLeftGesture;
@property (strong,nonatomic)UITapGestureRecognizer *tapGesture;
@property (strong,nonatomic)UIScreenEdgePanGestureRecognizer *panGesture;

@property (strong,nonatomic)UIBlurEffect *blurEffet;
@property (strong,nonatomic)UIVisualEffectView *blurEffectView;
@property CGPoint startLocation;
@property CGPoint currentLocation;
@property CGFloat swipeOffset;
@end

@implementation MainViewRootViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftMenuWidth = 100.0;
    self.leftMenu.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.leftMenuWidth, self.view.frame.size.height);
    self.mainView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    self.swipLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenu)];
    self.swipLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToCloseMenu)];
    self.panGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDo:)];
    self.panGesture.delegate = self;
    self.panGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:self.panGesture];
    self.blurEffet = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:self.blurEffet];


    self.blurEffectView.frame = CGRectMake(self.mainView.frame.origin.x, self.mainView.frame.origin.y, self.mainView.frame.size.width, self.mainView.frame.size.height);
    [self.blurEffectView addGestureRecognizer:self.tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleMenu) name:@"toggleMenu" object:nil];

    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.view addGestureRecognizer:self.swipLeftGesture];
    self.leftMenu.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 0, self.view.frame.size.height); //important bug I do not understand
    //[self.blurEffectView removeFromSuperview];
    //[self testOperation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}
-(void)testOperation{
    [self.mainView addSubview:self.blurEffectView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0];
    
    self.leftMenu.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.leftMenuWidth, self.view.frame.size.height);
    self.mainView.frame = CGRectMake(self.view.frame.origin.x + self.leftMenuWidth, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    self.blurEffectView.alpha = 0;
    //[self.mainView addSubview:self.blurEffectView];
    self.blurEffectView.alpha = 1;
    
    [UIView commitAnimations];

    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0];
    self.blurEffectView.alpha = 1;
    self.leftMenu.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.leftMenuWidth, self.view.frame.size.height);
    self.mainView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    self.blurEffectView.alpha = 0;
    [UIView commitAnimations];
    [self.blurEffectView removeFromSuperview];

}

-(void)closeMenu{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.blurEffectView.alpha = 1;
    self.leftMenu.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.leftMenuWidth, self.view.frame.size.height);
    self.mainView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    self.blurEffectView.alpha = 0;
    [UIView commitAnimations];
    [self.view removeGestureRecognizer:self.swipLeftGesture];
    [self.blurEffectView removeGestureRecognizer:self.tapGesture];
    [self.blurEffectView removeFromSuperview];
}


-(void)openMenu{
//    self.blurEffectView.alpha = 0;
//    if (![self. self.mainView.subviews containsObject:self.blurEffectView]) {
//        [self.mainView addSubview:self.blurEffectView];
//    }
    [self.mainView addSubview:self.blurEffectView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    self.leftMenu.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.leftMenuWidth, self.view.frame.size.height);
    self.mainView.frame = CGRectMake(self.view.frame.origin.x + self.leftMenuWidth, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);

    self.blurEffectView.alpha = 0;
    //[self.mainView addSubview:self.blurEffectView];
    self.blurEffectView.alpha = 1;

    [UIView commitAnimations];
    [self.blurEffectView addGestureRecognizer:self.tapGesture];
    [self.view addGestureRecognizer:self.swipLeftGesture];
}

-(void) toggleMenu{
    if(self.mainView.frame.origin.x == 0){
        
        [self openMenu];
        
    }else{
        [self closeMenu];
    }
}

-(void)closeMenuHalfAnimation{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    self.leftMenu.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.leftMenuWidth, self.view.frame.size.height);
    self.mainView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    self.blurEffectView.alpha = 0;
    [UIView commitAnimations];
    [self.view removeGestureRecognizer:self.swipLeftGesture];
    [self.blurEffectView removeGestureRecognizer:self.tapGesture];
    [self.blurEffectView removeFromSuperview];
}


-(void)openMenuHalfAnimation{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    self.leftMenu.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.leftMenuWidth, self.view.frame.size.height);
    self.mainView.frame = CGRectMake(self.view.frame.origin.x + self.leftMenuWidth, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);

    [self.mainView addSubview:self.blurEffectView];
    self.blurEffectView.alpha = 1;
    
    [UIView commitAnimations];
    [self.blurEffectView addGestureRecognizer:self.tapGesture];
    [self.view addGestureRecognizer:self.swipLeftGesture];
}

-(void)tapToCloseMenu{
    if (self.mainView.frame.origin.x != 0) {
        [self closeMenuHalfAnimation];
    }
    else{
        [self closeMenu];
    }
}

-(void)panGestureDo:(UIScreenEdgePanGestureRecognizer *)sender{
    sender.enabled = true;
    if(sender.state == UIGestureRecognizerStateBegan){
        self.startLocation = [sender locationInView:self.view];
    }
    
    self.currentLocation = [sender locationInView:self.view];
    CGFloat distance = self.startLocation.x - self.currentLocation.x;
//    if(sender.state == UIGestureRecognizerStateEnded){
//        if (self.mainView.frame.origin.x > 50) {
//            [self openMenuHalfAnimation];
//        }else{
//            [self closeMenuHalfAnimation];
//        }
//    }
    if(distance < 0){
        [self.mainView addSubview:self.blurEffectView];
        [self.blurEffectView addGestureRecognizer:self.tapGesture];
        self.blurEffectView.alpha = (-distance)/100;
        self.leftMenu.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.leftMenuWidth, self.view.frame.size.height);
        self.mainView.frame =CGRectMake(self.view.frame.origin.x - distance, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        
        if (self.mainView.frame.origin.x > 97) {
            self.mainView.frame =CGRectMake(self.view.frame.origin.x + self.leftMenuWidth, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            [self openMenuHalfAnimation];
        }
        
        if (self.mainView.frame.origin.x < 3) {
            self.mainView.frame =CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            [self closeMenuHalfAnimation];
        }
        if(sender.state == UIGestureRecognizerStateEnded){
            if (self.mainView.frame.origin.x > 50) {
                [self openMenuHalfAnimation];
            }else{
                [self closeMenuHalfAnimation];
            }
        }

        
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return true;
}

@end
