//
//  ZZPageControl.h
//  ZZMostTalented
//
//  Created by wangshaosheng on 13-4-16.
//  Copyright (c) 2013年 wangshaosheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SPACE_X (14.0)

@interface ZZPageControl : UIControl
{
    NSMutableArray *imageViewMutableArray;
    UIImageView *currentPageImageView;
}

@property(nonatomic,assign) NSInteger numberOfPages;          // default is 0
@property(nonatomic,assign) NSInteger currentPage;            // default is 0. value pinned to 0..numberOfPages-1

@end
