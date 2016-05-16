//
//  ZZExpertCenterView.m
//  梦想宝贝
//
//  Created by wangshaosheng on 14-7-12.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "ZZMotherDetailReport.h"

@implementation ZZMotherDetailReport

-(void)dealloc
{
    [self.iconImageView removeFromSuperview];
    self.iconImageView = nil;
    [self.userNameLabel removeFromSuperview];
    self.userNameLabel = nil;
    [self.timeLabel removeFromSuperview];
    self.timeLabel = nil;
    [self.photoImageView removeFromSuperview];
    self.photoImageView = nil;
    [self.contentLabel removeFromSuperview];
    self.contentLabel = nil;
    [self.mainView removeFromSuperview];
    self.mainView = nil;
    
    [self.lineImageView removeFromSuperview];
    self.lineImageView = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        
//        @property (nonatomic, retain) UIView *mainView;
//        @property (nonatomic, retain) UILabel *userNameLabel;
//        @property (nonatomic, retain) UILabel *timeLabel;
//        @property (nonatomic, retain) UILabel *contentLabel;
//        
//        @property (nonatomic, retain) UIView *replyView;
//        @property (nonatomic, retain) UILabel *replyUserNameLabel;
//        @property (nonatomic, retain) UILabel *replyTimeLabel;
//        @property (nonatomic, retain) UILabel *replyContentLabel;
        [self setBackgroundColor:[UIColor colorwithHexString:@"#F5F5DC"]];
        
        self.mainView = [[[UIView alloc]initWithFrame:CGRectMake(10, 3, self.frame.size.width - 20, 50)] autorelease];
        
        [self addSubview:self.mainView];
        
        self.iconImageView = [[[ZZAutoSizeImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
        [self.mainView addSubview:self.iconImageView];
        
        self.userNameLabel = [[[UILabel alloc]initWithFrame:CGRectMake(70, 0, self.mainView.frame.size.width, 15)] autorelease];
        [self.mainView addSubview:self.userNameLabel];
        [self.userNameLabel setBackgroundColor:[UIColor clearColor]];
        [self.userNameLabel setTextColor:[UIColor colorwithHexString:@"#575757"]];
        [self.userNameLabel setFont:[UIFont systemFontOfSize:12]];

        self.timeLabel = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 15)] autorelease];
        [self.mainView addSubview:self.timeLabel];
        [self.timeLabel setBackgroundColor:[UIColor clearColor]];
        [self.timeLabel setTextColor:[UIColor colorwithHexString:@"#F94BB3"]];
        [self.timeLabel setFont:[UIFont systemFontOfSize:10]];
        
        self.photoImageView = [[[ZZAutoSizeImageView alloc]initWithFrame:CGRectMake(70, 0, 0, 0)] autorelease];
        [self.mainView addSubview:self.photoImageView];
        
        
        self.contentLabel = [[[UILabel alloc]initWithFrame:CGRectMake(70, 16, self.mainView.frame.size.width - 95, 15)] autorelease];
        [self.mainView addSubview:self.contentLabel];
        [self.contentLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentLabel setTextColor:[UIColor colorwithHexString:@"#F94BB3"]];
        [self.contentLabel setFont:[UIFont systemFontOfSize:13]];
        [self.contentLabel setNumberOfLines:0];

        self.lineImageView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jiaoliu_list_line.png"]] autorelease];
        [self addSubview:self.lineImageView];
        [self.lineImageView setFrame:CGRectMake(0, 0, 270, 2)];
//        [self.lineImageView setFrame:CGRectMake(10, , 300, 2)];
       
        
    }
    return self;
}

- (void)setDataDictionary:(NSDictionary *)dataDictionary
{
    [dataDictionary retain];
    [_dataDictionary release];
    _dataDictionary = dataDictionary;
    
    //photoImageView
    [self.iconImageView setFrame:CGRectMake(self.iconImageView.frame.origin.x, 0, 45, 45)];
    [self.iconImageView setImage:[UIImage imageNamed:@"icon"]];
    if ([[dataDictionary objectForKey:@"avater"] isKindOfClass:[NSString class]])
    {
        if ([[dataDictionary objectForKey:@"avater"] length] > 0)
        {
            NSURL *url = [NSURL URLWithString:[dataDictionary objectForKey:@"avater"]];
            if (url)
            {
                [self.iconImageView setFrame:CGRectMake(self.iconImageView.frame.origin.x, 0, 45, 45)];
                [self.iconImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon"]];
            }
        }
    }
    
    
    [self.userNameLabel setText:nil];
    if ([[dataDictionary objectForKey:@"nick_name"] isKindOfClass:[NSString class]])
    {
        [self.userNameLabel setText:[dataDictionary objectForKey:@"nick_name"]];
    }
    CGSize userNameSize = ZZ_MULTILINE_TEXTSIZE(self.userNameLabel.text, self.userNameLabel.font, CGSizeMake(200, self.userNameLabel.frame.size.height), self.userNameLabel.lineBreakMode);
    CGRect userNameRect = self.userNameLabel.frame;
    userNameRect.size.width = userNameSize.width;
    [self.userNameLabel setFrame:userNameRect];
    
    [self.timeLabel setText:nil];
    if ([[dataDictionary objectForKey:@"add_time"] isKindOfClass:[NSString class]])
    {
        [self.timeLabel setText:[dataDictionary objectForKey:@"add_time"]];
    }
    CGRect timeRect = self.timeLabel.frame;
    timeRect.origin.x = self.userNameLabel.frame.origin.x + self.userNameLabel.frame.size.width + 5;
    [self.timeLabel setFrame:timeRect];
    

    //photoImageView
    [self.photoImageView setFrame:CGRectMake(self.photoImageView.frame.origin.x, self.userNameLabel.frame.origin.y + self.userNameLabel.frame.size.height, 0, 0)];
    [self.photoImageView setImage:nil];
    if ([[dataDictionary objectForKey:@"img_url"] isKindOfClass:[NSString class]])
    {
        if ([[dataDictionary objectForKey:@"img_url"] length] > 0)
        {
            NSURL *url = [NSURL URLWithString:[dataDictionary objectForKey:@"img_url"]];
            if (url)
            {
                [self.photoImageView setFrame:CGRectMake(self.userNameLabel.frame.origin.x, self.userNameLabel.frame.origin.y + self.userNameLabel.frame.size.height, 80, 80)];
                [self.photoImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon"]];
            }
        }
    }
    
    
    [self.contentLabel setText:nil];
    if ([[dataDictionary objectForKey:@"content"] isKindOfClass:[NSString class]])
    {
        [self.contentLabel setText:[dataDictionary objectForKey:@"content"]];
    }
    CGSize contentSize = ZZ_MULTILINE_TEXTSIZE(self.contentLabel.text, self.contentLabel.font, CGSizeMake(self.contentLabel.frame.size.width, 9999), self.contentLabel.lineBreakMode);
    CGRect contentRect = self.contentLabel.frame;
    contentRect.origin.y = self.photoImageView.frame.origin.y + self.photoImageView.frame.size.height;
    contentRect.size.height = contentSize.height > 30 ? contentSize.height : 30;
    [self.contentLabel setFrame:contentRect];

    CGRect mainViewRect = self.mainView.frame;
    mainViewRect.size.height = self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height;
    if (mainViewRect.size.height < self.photoImageView.frame.origin.y + self.photoImageView.frame.size.height)
    {
        mainViewRect.size.height = self.photoImageView.frame.origin.y + self.photoImageView.frame.size.height;
    }
    
    [self.mainView setFrame:mainViewRect];
        
    CGRect lineRect = self.lineImageView.frame;
    lineRect.origin.y = self.mainView.frame.origin.y + self.mainView.frame.size.height + 2;
    [self.lineImageView setFrame:lineRect];
    
    CGRect selfRect = self.frame;
    selfRect.size.height = self.mainView.frame.origin.y + self.mainView.frame.size.height + 4;
    [self setFrame:selfRect];
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
