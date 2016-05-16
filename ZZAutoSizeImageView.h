//
//  ZZAutoSizeImageView.h
//  梦想宝贝
//
//  Created by wangshaosheng on 14-7-12.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageCompat.h"
#import "SDWebImageManagerDelegate.h"
#import "SDWebImageManager.h"


@interface ZZAutoSizeImageView : UIImageView<SDWebImageManagerDelegate>
{
    UIActivityIndicatorView *activityView;
}

@property (nonatomic, retain)UIImageView *imageView;
@property (nonatomic, retain)UIImage *placeholderImage;
@property (nonatomic, assign)BOOL autoSize;

- (void)setImageWithURL:(NSURL *)url;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

@end

