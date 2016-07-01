//
//  WriteMessageViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/6/30.
//  Copyright © 2016年 李龑. All rights reserved.
//

#define myBlackIron [UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1]

#import "WriteMessageViewController.h"

@interface WriteMessageViewController ()<UITextViewDelegate>

@end

@implementation WriteMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *vcName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 30)];
    vcName.text = @"Leave Message";
    vcName.textAlignment = NSTextAlignmentCenter;
    vcName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    vcName.textColor = myBlackIron;
    self.navigationItem.titleView = vcName;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    

    
    [self initViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)done{
    [self.delegate WriteMessageViewFinishEnterWithMessage:self.message];
    [self.navigationController popViewControllerAnimated:true];
}

-(void)initViewController{
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 200)];
    textView.delegate = self;
    if (self.message !=nil) {
        textView.text = self.message;
        textView.textColor = [UIColor blackColor];
    }else{
        textView.text = @"Write no more than 100 words.";
        textView.textColor = [UIColor lightGrayColor];
    }
    textView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    
    [self.view addSubview:textView];
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Write no more than 100 words."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length<100) {
        self.message = textView.text;
    }else{
        [textView setText:self.message];
        NSLog(@"Write no more than 100 words.");
    }
    
    
//    if ([textView.text isEqualToString:@""]) {
//        textView.text = @"Write no more than 50 words.";
//        textView.textColor = [UIColor lightGrayColor]; //optional
//    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    //self.message = textView.text;
    
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Write no more than 100 words.";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
