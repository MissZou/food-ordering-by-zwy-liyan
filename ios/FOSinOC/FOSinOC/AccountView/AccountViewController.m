//
//  AccountViewController.m
//  FOSinOC
//
//  Created by MoonSlides on 16/4/14.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "AccountViewController.h"
#import "Account.h"
#import "AssetGridViewController.h"
@import PhotosUI;

@interface AccountViewController ()<AssetGridViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;


@property (strong,nonatomic) Account *myAccount;

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myAccount = [Account sharedManager];
    self.topView.layer.shadowOpacity = 0.3;
    self.avatar.layer.masksToBounds = true;
    self.avatar.layer.cornerRadius = 10.0;
    
    self.addressButton.layer.cornerRadius = 5.0;
    self.addressButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.addressButton.layer.borderWidth = 1.0;
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //Update the progress view
        if (self.myAccount.photoUrl != nil) {
            self.avatar.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.myAccount.photoUrl]]];
        }
    });
    
    if (self.myAccount.name != nil) {
        self.name.text = self.myAccount.name;
    }
    self.email.text = self.myAccount.email;
    [self.myAccount address:GET withAddress:nil];
    UITapGestureRecognizer *avatarTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTapEvent)];
    [self.avatar setUserInteractionEnabled:true];
    [self.avatar addGestureRecognizer:avatarTapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismissAccountView:(id)sender {
    CATransition *transition = [CATransition new];
    transition.duration = 0.35;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromLeft;
    
    UIWindow *containerWindow = self.view.window;
    [containerWindow.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:false completion:nil];
}

-(void)avatarTapEvent{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Change avatar" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        [actionSheet dismissViewControllerAnimated:true completion:nil];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Choose Existing" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self performSegueWithIdentifier:@"photo" sender:nil];
        [actionSheet dismissViewControllerAnimated:true completion:nil];
    }]];
    
    [self presentViewController:actionSheet animated:true completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"photo"]) {

        
        AssetGridViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
}

-(void)assetChoosedAsset:(PHAsset *)asset{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.networkAccessAllowed = YES;

    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(640, 480) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
        // Hide the progress view now the request has completed.
        
        
        // Check if the request was successful.
        if (!result) {
            return;
        }
        
        // Show the UIImageView and use it to display the requested image.

        // Create path.
        
        UIImage *resizedImage =  [self resizeImage:result withWidth:640 withHeight:480];
        //UIImage *resizedImage =  [self resizeImage:result withWidth:700 withHeight:700];
        UIImage *uploadImage = [self imageByCroppingImage:resizedImage toSize:CGSizeMake(480, 640)];
        

        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"avatar.png"];
        
        // Save image.
        [UIImagePNGRepresentation(uploadImage) writeToFile:filePath atomically:YES];
        CGFloat filesize = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
        
        self.avatar.image = result;
        [self.myAccount changeAvatar:[NSURL URLWithString:filePath]];
    }];

}

- (UIImage*)resizeImage:(UIImage*)image withWidth:(CGFloat)width withHeight:(CGFloat)height
{
    CGSize newSize = CGSizeMake(width, height);
    CGFloat widthRatio = newSize.width/image.size.width;
    CGFloat heightRatio = newSize.height/image.size.height;
    
    if(widthRatio > heightRatio)
    {
        newSize=CGSizeMake(image.size.width*heightRatio,image.size.height*heightRatio);
    }
    else
    {
        newSize=CGSizeMake(image.size.width*widthRatio,image.size.height*widthRatio);
    }
    
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)imageByCroppingImage:(UIImage *)image toSize:(CGSize)size
{
    // not equivalent to image.size (which depends on the imageOrientation)!
    double refWidth = CGImageGetWidth(image.CGImage);
    double refHeight = CGImageGetHeight(image.CGImage);
    
    double x = (refWidth - size.width) / 2.0;
    double y = (refHeight - size.height) / 2.0;
    
    CGRect cropRect = CGRectMake(x, y, size.height, size.width);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    
    return cropped;
}

@end
