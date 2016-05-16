//
//  ActivityPlageView.m
//  梦想宝贝
//
//  Created by IOS001 on 14-5-24.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "ActivityPlageView.h"
#import <QuartzCore/QuartzCore.h>
@implementation ActivityPlageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0.3;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    self.contentView.frame=CGRectMake(self.center.x-30, self.center.y-30, 60, 60);
    self.contentView.layer.cornerRadius = 8;
    self.contentView.layer.masksToBounds = YES;
    //给图层添加一个有色边框
//    self.contentView.layer.borderWidth = 5;
//    self.contentView.layer.borderColor = [[UIColor colorWithRed:0.52 green:0.09 blue:0.07 alpha:1] CGColor];
}
-(void)hide
{
    if (self) {
        self.hidden = YES;
    }
}
-(void)waitingTime:(NSTimeInterval)waitTime{
    if (self) {
        [self performSelector:@selector(hide) withObject:nil afterDelay:waitTime];
    }

}
- (void)dealloc {
    [_titleLabel release];
    [_playActivity release];
    [_contentView release];
    [super dealloc];
}
@end
