//
//  AssetGridViewCell.m
//  FOSinOC
//
//  Created by MoonSlides on 16/6/15.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "AssetGridViewCell.h"

@interface AssetGridViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation AssetGridViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
}

- (void)setThumbnailImage:(UIImage *)thumbnailImage {
    _thumbnailImage = thumbnailImage;
    self.imageView.image = thumbnailImage;
}

@end
