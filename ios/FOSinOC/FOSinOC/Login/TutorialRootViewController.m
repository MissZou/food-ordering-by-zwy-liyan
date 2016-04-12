//
//  TutorialRootViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/7.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "TutorialRootViewController.h"


@interface TutorialRootViewController ()


@property (strong, nonatomic) NSArray *arrayPageTitle;
@property (strong, nonatomic) NSArray *arrayPageText;
@property (strong, nonatomic) NSArray *arrayImage;




@end

@implementation TutorialRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *introText1 = @"Meals arrive on-demand or you can schedule delivery up to a week in advance for beyond-easy meal-planning.";
    NSString *introText2 = @"Our friendly delivery folk arrive with your food, still chilled so it stays fresh. We’ll bring it right to your front door. Or your desk. Or your friend's place.";
    NSString *introText3 = @"Mealtimes are more than food. They’re time to relax. Sometimes that means recharging all by yourself, other times it’s about connecting with friends and family. However you eat dinner, we’re here to make it as easy as it is delicious.";
    
    self.arrayPageTitle = @[@"DINNER MADE EASY", @"DELIVERED ANYWHERE", @"DINNERS YOU WANT"];
    self.arrayImage = @[@"introductionPic1.jpg", @"introductionPic2.jpg", @"introductionPic3.jpg"];
    self.arrayPageText = @[introText1, introText2, introText3];
    
    self.pageViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    TutorialPageViewController *startingViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:startingViewController];
   
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(TutorialPageViewController *) viewControllerAtIndex:(NSUInteger) index {
    if((self.arrayPageTitle.count == 0) || (index >= self.arrayPageTitle.count)) {
        return nil;
    }
    TutorialPageViewController *pageContentViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"PageContentViewController"];
   
    pageContentViewController.imageFile = self.arrayImage[index];
    pageContentViewController.textTitle = self.arrayPageTitle[index];
    pageContentViewController.textContent = self.arrayPageText[index];
    pageContentViewController.pageIndex = index;
    return pageContentViewController;
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger index = [(TutorialPageViewController *)viewController pageIndex];
    if (index == NSNotFound || index == 0){
        return nil;
    }
    index --;
    return [self viewControllerAtIndex:index];
    
}

-(UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index = [(TutorialPageViewController *)viewController pageIndex];
    if (index == NSNotFound){
        return nil;
    }
    index ++;
    if (index == _arrayPageTitle.count){
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    return self.arrayPageText.count;
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
    return 0;
}
@end
