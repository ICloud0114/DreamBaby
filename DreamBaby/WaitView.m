//
//  WaitView.m
//  梦想宝贝
//
//  Created by IOS001 on 14-5-24.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "WaitView.h"

@implementation WaitView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/2 - 30, frame.size.height - 30, 60, 60)];
        [self addSubview:centerView];
        [centerView release];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
