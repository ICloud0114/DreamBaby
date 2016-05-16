//
//  ZZExpertCenterView.m
//  梦想宝贝
//
//  Created by wangshaosheng on 14-7-12.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "ZZExpertCenterView.h"

@implementation ZZExpertCenterView

-(void)dealloc
{
    [self.replyUserNameLabel removeFromSuperview];
    self.replyUserNameLabel = nil;
    [self.replyTimeLabel removeFromSuperview];
    self.replyTimeLabel = nil;
    [self.replyContentLabel removeFromSuperview];
    self.replyContentLabel = nil;
    [self.replyView removeFromSuperview];
    self.replyView = nil;
    
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
  
        self.mainView = [[[UIView alloc]initWithFrame:CGRectMake(10, 3, self.frame.size.width - 20, 50)] autorelease];
        [self addSubview:self.mainView];
        
        self.userNameLabel = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.mainView.frame.size.width, 15)] autorelease];
        [self.mainView addSubview:self.userNameLabel];
        [self.userNameLabel setBackgroundColor:[UIColor clearColor]];
        [self.userNameLabel setTextColor:[UIColor colorwithHexString:@"#575757"]];
        [self.userNameLabel setFont:[UIFont systemFontOfSize:12]];

        self.timeLabel = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 15)] autorelease];
        [self.mainView addSubview:self.timeLabel];
        [self.timeLabel setBackgroundColor:[UIColor clearColor]];
        [self.timeLabel setTextColor:[UIColor colorwithHexString:@"#F94BB3"]];
        [self.timeLabel setFont:[UIFont systemFontOfSize:10]];
        
        self.photoImageView = [[[ZZAutoSizeImageView alloc]initWithFrame:CGRectMake(20, 0, 0, 0)] autorelease];
        [self.mainView addSubview:self.photoImageView];
        
        
        self.contentLabel = [[[UILabel alloc]initWithFrame:CGRectMake(0, 16, self.mainView.frame.size.width, 15)] autorelease];
        [self.mainView addSubview:self.contentLabel];
        [self.contentLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentLabel setTextColor:[UIColor colorwithHexString:@"#F94BB3"]];
        [self.contentLabel setFont:[UIFont systemFontOfSize:13]];
        [self.contentLabel setNumberOfLines:0];
        
        
        self.replyView = [[[UIView alloc]initWithFrame:CGRectMake(10, 3, self.frame.size.width - 20, 50)] autorelease];
        [self addSubview:self.replyView];
        [self.replyView setBackgroundColor:[UIColor colorwithHexString:@"#F5F5DC"]];
        
        self.replyUserNameLabel = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.mainView.frame.size.width, 15)] autorelease];
        [self.replyView addSubview:self.replyUserNameLabel];
        [self.replyUserNameLabel setBackgroundColor:[UIColor clearColor]];
        [self.replyUserNameLabel setTextColor:[UIColor colorwithHexString:@"#575757"]];
        [self.replyUserNameLabel setFont:[UIFont systemFontOfSize:12]];
        
        self.replyTimeLabel = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 15)] autorelease];
        [self.replyView addSubview:self.replyTimeLabel];
        [self.replyTimeLabel setBackgroundColor:[UIColor clearColor]];
        [self.replyTimeLabel setTextColor:[UIColor colorwithHexString:@"#F94BB3"]];
        [self.replyTimeLabel setFont:[UIFont systemFontOfSize:10]];
        
        self.replyContentLabel = [[[UILabel alloc]initWithFrame:CGRectMake(0, 16, self.mainView.frame.size.width, 15)] autorelease];
        [self.replyContentLabel setNumberOfLines:0];
        [self.replyView addSubview:self.replyContentLabel];
        [self.replyContentLabel setBackgroundColor:[UIColor clearColor]];
        [self.replyContentLabel setTextColor:[UIColor colorwithHexString:@"#F94BB3"]];
        [self.replyContentLabel setFont:[UIFont systemFontOfSize:13]];
        
        self.lineImageView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jiaoliu_list_line.png"]] autorelease];
        [self addSubview:self.lineImageView];
        [self.lineImageView setFrame:CGRectMake(10, 5, 300, 2)];
        
    }
    return self;
}

- (void)setDataDictionary:(NSDictionary *)dataDictionary
{
    [dataDictionary retain];
    [_dataDictionary release];
    _dataDictionary = dataDictionary;
    
    [self.userNameLabel setText:nil];
    if ([[dataDictionary objectForKey:@"messager"] isKindOfClass:[NSString class]])
    {
        [self.userNameLabel setText:[dataDictionary objectForKey:@"messager"]];
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
                [self.photoImageView setFrame:CGRectMake(self.photoImageView.frame.origin.x, self.userNameLabel.frame.origin.y + self.userNameLabel.frame.size.height, 80, 80)];
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
    contentRect.size.height = contentSize.height;
    [self.contentLabel setFrame:contentRect];

    CGRect mainViewRect = self.mainView.frame;
    mainViewRect.size.height = self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height;
    [self.mainView setFrame:mainViewRect];
    
    [self.replyView setHidden:YES];
    CGRect replyViewRect = self.replyView.frame;
    replyViewRect.origin.y = self.mainView.frame.origin.y + self.mainView.frame.size.height;
    replyViewRect.size.height = 0;
    [self.replyView setFrame:replyViewRect];
    
    if ([[dataDictionary objectForKey:@"reply"] isKindOfClass:[NSArray class]])
    {
        if([[dataDictionary objectForKey:@"reply"]  count] > 0)
       {
           NSDictionary *replyDictionary = [[dataDictionary objectForKey:@"reply"] objectAtIndex:0];
           [self.replyView setHidden:NO];
           
           [self.replyUserNameLabel setText:nil];
           if ([[dataDictionary objectForKey:@"expert_name"] isKindOfClass:[NSString class]])
           {
               
               
               [self.replyUserNameLabel setText:[NSString stringWithFormat:@"专家 %@ 回复",[dataDictionary objectForKey:@"expert_name"]]];
           }
           CGSize userNameSize = ZZ_MULTILINE_TEXTSIZE(self.replyUserNameLabel.text, self.replyUserNameLabel.font, CGSizeMake(200, self.replyUserNameLabel.frame.size.height), self.replyUserNameLabel.lineBreakMode);
           CGRect userNameRect = self.replyUserNameLabel.frame;
           userNameRect.size.width = userNameSize.width;
           [self.replyUserNameLabel setFrame:userNameRect];
           
           [self.replyTimeLabel setText:nil];
           if ([[replyDictionary objectForKey:@"reply_time"] isKindOfClass:[NSString class]])
           {
               [self.replyTimeLabel setText:[replyDictionary objectForKey:@"reply_time"]];
           }
           CGRect timeRect = self.replyTimeLabel.frame;
           timeRect.origin.x = self.replyUserNameLabel.frame.origin.x + self.replyUserNameLabel.frame.size.width + 5;
           [self.replyTimeLabel setFrame:timeRect];
           
           
           [self.replyContentLabel setText:nil];
           if ([[replyDictionary objectForKey:@"reply_content"] isKindOfClass:[NSString class]])
           {
               [self.replyContentLabel setText:[replyDictionary objectForKey:@"reply_content"]];
           }
           CGSize contentSize = ZZ_MULTILINE_TEXTSIZE(self.replyContentLabel.text, self.replyContentLabel.font, CGSizeMake(self.replyContentLabel.frame.size.width, 9999), self.replyContentLabel.lineBreakMode);
           CGRect contentRect = self.replyContentLabel.frame;
           contentRect.size.height = contentSize.height;
           [self.replyContentLabel setFrame:contentRect];
           
           CGRect replyViewRect = self.replyView.frame;
           replyViewRect.origin.y = self.mainView.frame.origin.y + self.mainView.frame.size.height;
           replyViewRect.size.height = self.replyContentLabel.frame.origin.y + self.replyContentLabel.frame.size.height;
           [self.replyView setFrame:replyViewRect];
       }
    }
    
    
    CGRect lineRect = self.lineImageView.frame;
    lineRect.origin.y = self.replyView.frame.origin.y + self.replyView.frame.size.height + 2;
    [self.lineImageView setFrame:lineRect];
    
    CGRect selfRect = self.frame;
    selfRect.size.height = self.replyView.frame.origin.y + self.replyView.frame.size.height + 4;
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
