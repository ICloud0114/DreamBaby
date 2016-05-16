//
//  ZZPageControl.m
//  ZZMostTalented
//
//  Created by wangshaosheng on 13-4-16.
//  Copyright (c) 2013年 wangshaosheng. All rights reserved.
//

#import "ZZPageControl.h"

@implementation ZZPageControl
@synthesize currentPage = _currentPage;
@synthesize numberOfPages = _numberOfPages;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        currentPageImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gallery_radio_on"]];
        [self addSubview:currentPageImageView];

        imageViewMutableArray = [[NSMutableArray alloc]init];
        
        [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelf:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        
    }
    return self;
}

-(void)setCurrentPage:(NSInteger)currentPage
{
    if (currentPage != 0)
    {
        if (_currentPage == currentPage)
        {
            return;
        }
    }

    _currentPage = currentPage;
    switch (self.contentHorizontalAlignment)
    {
        case UIControlContentHorizontalAlignmentLeft:
        {
            if (_numberOfPages == 0)
            {
                [currentPageImageView setFrame:CGRectMake(_currentPage * SPACE_X, (self.frame.size.height - 10) / 2, 0, 0)];
            }
            else
            {
                [currentPageImageView setFrame:CGRectMake(_currentPage * SPACE_X, (self.frame.size.height - 10) / 2, 10, 10)];
            }

        }
            break;
        case UIControlContentHorizontalAlignmentRight:
        {
            if (_numberOfPages == 0)
            {
                [currentPageImageView setFrame:CGRectMake(self.frame.size.width - _numberOfPages * SPACE_X + _currentPage * SPACE_X, (self.frame.size.height - 10) / 2, 0, 0)];
            }
            else
            {
                [currentPageImageView setFrame:CGRectMake(self.frame.size.width - _numberOfPages * SPACE_X + _currentPage * SPACE_X, (self.frame.size.height - 10) / 2, 10, 10)];
            }
        }
            break;
            
        default:
        {
            if (_numberOfPages == 0)
            {
                [currentPageImageView setFrame:CGRectMake((self.frame.size.width - _numberOfPages * SPACE_X) / 2 + _currentPage *SPACE_X, (self.frame.size.height - 10) / 2, 0, 0)];
            }
            else
            {
                [currentPageImageView setFrame:CGRectMake((self.frame.size.width - _numberOfPages * SPACE_X) / 2 + _currentPage * SPACE_X, (self.frame.size.height - 10) / 2, 10, 10)];
            }
        }
            break;
    }
    
//    DLog(@"III:%@",currentPageImageView);
}

-(void)setNumberOfPages:(NSInteger)numberOfPages
{
    _numberOfPages = numberOfPages;
    [imageViewMutableArray removeAllObjects];
    for (UIImageView *imageView in imageViewMutableArray)
    {
        [imageView removeFromSuperview];
    }    
    [imageViewMutableArray removeAllObjects];

    switch (self.contentHorizontalAlignment)
    {
        case UIControlContentHorizontalAlignmentLeft:
        {
            for (int i = 0; i < numberOfPages; i++)
            {
                UIImageView *pageImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * SPACE_X, (self.frame.size.height - 10) / 2, 10, 10)];
                [self addSubview:pageImageView];
                [pageImageView setImage:[UIImage imageNamed:@"gallery_radio_off"]];

                [imageViewMutableArray addObject:pageImageView];
//                [pageImageView release];
            }
        }
            break;
        case UIControlContentHorizontalAlignmentRight:
        {
            for (int i = 0; i < numberOfPages; i++)
            {
                UIImageView *pageImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - _numberOfPages * SPACE_X+ i * SPACE_X, (self.frame.size.height - 10) / 2, 10, 10)];
                [self addSubview:pageImageView];
                [pageImageView setImage:[UIImage imageNamed:@"gallery_radio_off"]];

                [imageViewMutableArray addObject:pageImageView];
//                [pageImageView release];
            }
        }
            break;
            
        default:
        {
            for (int i = 0; i < numberOfPages; i++)
            {
                UIImageView *pageImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width - _numberOfPages * SPACE_X) / 2 + i * SPACE_X, (self.frame.size.height - 10) / 2, 10, 10)];
                [self addSubview:pageImageView];
                [pageImageView setImage:[UIImage imageNamed:@"gallery_radio_off"]];

                [imageViewMutableArray addObject:pageImageView];
//                [pageImageView release];
            }
        }
            break;
    }
    
    [self addSubview:currentPageImageView];

    if (self.currentPage == 0 || self.currentPage >= _numberOfPages)
    {
        self.currentPage = 0;
    }

}

-(void)tapSelf:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        if([tap locationInView:self].x < currentPageImageView.frame.origin.x)
        {
            if (_currentPage > 0 )
            {
                [self setCurrentPage:_currentPage - 1];
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
            
        }
        else
        {
            if (_currentPage < _numberOfPages - 1)
            {
                [self setCurrentPage:_currentPage + 1];
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
        }

    }
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
