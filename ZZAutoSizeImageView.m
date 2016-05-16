//
//  ZZAutoSizeImageView.m
//  梦想宝贝
//
//  Created by wangshaosheng on 14-7-12.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "ZZAutoSizeImageView.h"


@implementation ZZAutoSizeImageView

- (void)dealloc
{
    [activityView stopAnimating];
    [activityView removeFromSuperview];
    [activityView release];
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        self.imageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)] autorelease];
        [self addSubview:self.imageView];
        self.autoSize = YES;
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    [self autoSizeImageView];

}

- (UIImage *)image
{
    return _imageView.image;
}

- (void)setPlaceholderImage:(UIImage *)image
{
    [super setImage:image];
}

- (UIImage *)placeholderImage
{
    return [super image];
}

- (void)setImageWithURL:(NSURL *)url
{
    //    [self setImageWithURL:url placeholderImage:nil];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    activityView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    activityView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    [activityView startAnimating];
    [self addSubview:activityView];
    if (url)
    {
        [manager downloadWithURL:url delegate:self options:0];
    }
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    super.image = placeholder;
    
    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options];
    }
}

#if NS_BLOCKS_AVAILABLE
- (void)setImageWithURL:(NSURL *)url success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
{
    [self setImageWithURL:url placeholderImage:nil success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    super.image = placeholder;
    
    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options success:success failure:failure];
    }
}
#endif


#pragma mark 等比压缩图片
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
    
}

- (UIImage *)goodSizeImage:(UIImage *)image
{
    if (image.size.width > 640)//超宽
    {
        if (image.size.height > image.size.width * 1136 / 640)//压缩后还是超高
        {
            image = [self scaleImage:image toScale: 1136 / image.size.height];
        }
        else//压缩后正常
        {
            image = [self scaleImage:image toScale:640 / image.size.width];
        }
    }
    else//宽正常
    {
        if (image.size.height > 1136)//但超高
        {
            image = [self scaleImage:image toScale:1136 / image.size.height];
        }
        else//高也正常，不用处理
        {
            
        }
    }
    return image;
}

- (void)autoSizeImageView
{
    if (self.autoSize)
    {
        if (self.frame.size.width >= self.image.size.width && self.frame.size.height >= self.image.size.height)
        {
            CGRect frame;
            frame.origin.x = (self.imageView.frame.size.width - self.image.size.width) / 2;
            frame.origin.y = (self.imageView.frame.size.height - self.image.size.height) / 2;
            frame.size = self.image.size;
            self.imageView.frame = frame;
//            self.imageView.center = CGPointMake(self.imageView.frame.size.width / 2, self.imageView.frame.size.height / 2);
        }
        else
        {
            CGFloat ascept1 = self.frame.size.width / self.frame.size.height;
            CGFloat ascept2 = self.image.size.width / self.image.size.height;
            if (ascept1 >= ascept2)
            {
                CGSize newSize;
                newSize.height = self.frame.size.height;
                newSize.width =  self.frame.size.height * self.image.size.width / self.image.size.height;
                
                CGRect frame;
                frame.origin.x = (self.frame.size.width - newSize.width) / 2;
                frame.origin.y = (self.frame.size.height - newSize.height) / 2;
                frame.size = newSize;
                self.imageView.frame = frame;
                
//                self.imageView.center = CGPointMake(self.imageView.frame.size.width / 2, self.imageView.frame.size.height / 2);
            }
            else
            {
                CGSize newSize;
                newSize.width = self.frame.size.width;
                newSize.height = self.frame.size.width * self.image.size.height  / self.image.size.width;
                
                CGRect frame;
                frame.origin.x = (self.frame.size.width - newSize.width) / 2;
                frame.origin.y = (self.frame.size.height - newSize.height) / 2;
                frame.size = newSize;
                self.imageView.frame = frame;
//                self.imageView.center = CGPointMake(self.imageView.frame.size.width / 2, self.imageView.frame.size.height / 2);
            }
        }
    }
    
    
}

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didProgressWithPartialImage:(UIImage *)image forURL:(NSURL *)url
{
    if (((image.size.width == 0 && image.size.height == 0) || image == nil) && super.image != nil)
    {
        return;
    }
    super.image = nil;
    self.imageView.image = [self goodSizeImage:image];
    [self autoSizeImageView];
    [activityView stopAnimating];
    [activityView removeFromSuperview];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    if (((image.size.width == 0 && image.size.height == 0) || image == nil) && super.image != nil)
    {
        return;
    }
    super.image = nil;
    self.imageView.image = [self goodSizeImage:image];
    [self autoSizeImageView];
    [activityView stopAnimating];
    [activityView removeFromSuperview];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.imageView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

@end
