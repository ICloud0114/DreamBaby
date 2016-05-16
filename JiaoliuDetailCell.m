//
//  JiaoliuDetailCell.m
//  DreamBaby
//
//  Created by easaa on 14-1-8.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "JiaoliuDetailCell.h"

@implementation JiaoliuDetailCell


- (void)dealloc
{
    [_IconImageView release];
    [_CityNameLabel release];
    [_NameLabel release];
    [_ContentLabel release];
    [_DataLabel release];
    [_ReplyBtn release];
    [_IconBg release];
    [self.photoImageView removeFromSuperview];
    self.photoImageView = nil;
    
    [self.lineImageView removeFromSuperview];
    self.lineImageView = nil;
    
    [self.firstDetailReport removeFromSuperview];
    self.firstDetailReport = nil;
    [self.secondDetailReport removeFromSuperview];
    self.secondDetailReport = nil;
    
    [_floorLabel release];
    [super dealloc];
}

- (void)nibInit
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.photoImageView = [[[ZZAutoSizeImageView alloc]init] autorelease];
    [self addSubview:self.photoImageView];
    
    
    reportView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 0)];
    [self addSubview:reportView];
    [reportView release];
    
    
    self.lineImageView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jiaoliu_list_line.png"]] autorelease];
    [self.lineImageView setFrame:CGRectMake(10, 90, 300, 2)];
    [self addSubview:self.lineImageView];
    
    self.self_height = self.lineImageView.frame.origin.y + self.lineImageView.frame.size.height;
    
    self.firstDetailReport = [[[ZZMotherDetailReport alloc]initWithFrame:CGRectMake(40, 0, 275, 0)] autorelease];
    [reportView addSubview:self.firstDetailReport];
    
    self.secondDetailReport = [[[ZZMotherDetailReport alloc]initWithFrame:CGRectMake(40, 0, 275, 0)] autorelease];
    [reportView addSubview:self.secondDetailReport];
    
    
    [self.floorLabel setTextColor:[UIColor colorwithHexString:@"#DD2E94"]];
    [self.floorLabel setBackgroundColor:[UIColor clearColor]];
    [self.floorLabel setTextAlignment:NSTextAlignmentCenter];
    [self.floorLabel setFont:[UIFont systemFontOfSize:10]];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        [self nibInit];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark 计算显示时间
- (NSString *)dateFromString:(NSString *)dateString
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"MM/dd/yyyy HH:mm:ss"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    [dateFormatter release];
    NSDate *date = [NSDate date];
    
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    int intervall = (int) [localeDate timeIntervalSinceDate: destDate];
    
    NSString *returnValue = @"";
    if (intervall < 60) {
        returnValue = [NSString stringWithFormat:@"%d分钟前",1];
    }else
    {
        if (intervall > 60)
        {
            int minute = intervall / 60;
            
            if (minute < 60) {
                returnValue = [NSString stringWithFormat:@"%d分钟前",minute];
            }else
            {
                int hour = minute / 60;
                if (hour < 60) {
                    returnValue = [NSString stringWithFormat:@"%d小时前",hour];
                }else
                {
                    int day = hour / 24;
                    if (day < 365) {
                        returnValue = [NSString stringWithFormat:@"%d天前",day];
                    }else
                    {
                        returnValue = [NSString stringWithFormat:@"%d年前",day/365];
                    }
                }
            }
        }
    }
    return returnValue; //[NSString stringWithFormat:@"%d",intervall];
    
}



- (void)setDataDictionary:(NSDictionary *)dataDictionary
{
    [dataDictionary retain];
    [_dataDictionary release];
    _dataDictionary = dataDictionary;
    
    [self.IconImageView setImage:[UIImage imageNamed:@"icon"]];
    if ([[_dataDictionary objectForKey:@"avater"] isKindOfClass:[NSString class]])
    {
        NSURL *url = [NSURL URLWithString:[_dataDictionary objectForKey:@"avater"]];
        if (url)
        {
            [self.IconImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon"]];
        }
    }
    
    [self.NameLabel setText:[_dataDictionary objectForKey:nil]];
    if ([[_dataDictionary objectForKey:@"nick_name"] isKindOfClass:[NSString class]])
    {
        [self.NameLabel setText:[_dataDictionary objectForKey:@"nick_name"]];
    }
    
     [self.DataLabel setText:nil];
  
    if ([[_dataDictionary objectForKey:@"time_span"] isKindOfClass:[NSString class]])
    {
        [self.DataLabel setText:[_dataDictionary objectForKey:@"time_span"]];
    }
    else if ([[_dataDictionary objectForKey:@"add_time"] isKindOfClass:[NSString class]])
   {
       [self.DataLabel setText:[self dateFromString:[_dataDictionary objectForKey:@"add_time"]]];
   }

    [self.NameLabel setText:nil];
    if ([[_dataDictionary objectForKey:@"nick_name"] isKindOfClass:[NSString class]])
    {
        [self.NameLabel setText:[_dataDictionary objectForKey:@"nick_name"]];
    }
    
    
    //photoImageView
    [self.photoImageView setFrame:CGRectMake(self.NameLabel.frame.origin.x, self.NameLabel.frame.origin.y + self.NameLabel.frame.size.height + 5, 0, 0)];
    [self.photoImageView setImage:nil];
    if ([[_dataDictionary objectForKey:@"img_url"] isKindOfClass:[NSString class]])
    {
        if ([[_dataDictionary objectForKey:@"img_url"] length] > 0)
        {
            NSURL *url = [NSURL URLWithString:[_dataDictionary objectForKey:@"img_url"]];
            if (url)
            {
                [self.photoImageView setFrame:CGRectMake(self.NameLabel.frame.origin.x, self.NameLabel.frame.origin.y + self.NameLabel.frame.size.height + 5, 200, 100)];
                [self.photoImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon"]];
            }
        }
    }
    
     //ContentLabel
    [self.ContentLabel setText:[dataDictionary objectForKey:nil]];
    if ([[dataDictionary objectForKey:@"content"] isKindOfClass:[NSString class]])
    {
        [self.ContentLabel setText:[dataDictionary objectForKey:@"content"]];
    }
    CGSize contentSize = ZZ_MULTILINE_TEXTSIZE(self.ContentLabel.text, self.ContentLabel.font, CGSizeMake(self.ContentLabel.frame.size.width, 9999), self.ContentLabel.lineBreakMode);
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        contentSize.height += 1;
    }
    CGRect contentRect = self.ContentLabel.frame;
    
    contentRect.origin.y = self.photoImageView.frame.origin.y + self.photoImageView.frame.size.height;
    contentRect.size.height = contentSize.height > 30 ? contentSize.height : 30;
    
    [self.ContentLabel setFrame:contentRect];
    
    
    CGRect replyBtn = self.ReplyBtn.frame;
    replyBtn.origin.y = self.ContentLabel.frame.origin.y + self.ContentLabel.frame.size.height + 1;
    [self.ReplyBtn setFrame:replyBtn];
    
     //CityNameLabel
    [self.CityNameLabel setText:nil];
    if ([[dataDictionary objectForKey:@"area"] isKindOfClass:[NSString class]])
    {
        [self.CityNameLabel setText:[dataDictionary objectForKey:@"area"]];
    }
    CGRect addressRect = self.CityNameLabel.frame;
    addressRect.origin.y = self.ReplyBtn.frame.origin.y + self.ReplyBtn.frame.size.height + 1;
    [self.CityNameLabel setFrame:addressRect];
    
//    for (UIView *view in reportView.subviews)
//    {
//        [view removeFromSuperview];
//    }
    [reportView setFrame:CGRectMake(reportView.frame.origin.x, self.CityNameLabel.frame.origin.y + self.CityNameLabel.frame.size.height + 1, 0, 0)];
    [self.firstDetailReport setHidden:YES];
    [self.secondDetailReport setHidden:YES];
    
    if ([[_dataDictionary objectForKey:@"CommentReplyList"] isKindOfClass:[NSArray class]])
    {
        float mortherDetailView_height = 0.0;
        for (int i = 0; i < [[_dataDictionary objectForKey:@"CommentReplyList"] count] && i < 2; i++)
        {
            switch (i)
            {
                case 0:
                {
                    [self.firstDetailReport setFrame:CGRectMake(self.firstDetailReport.frame.origin.x, mortherDetailView_height, 270, 0)];
                    [self.firstDetailReport setDataDictionary:[[_dataDictionary objectForKey:@"CommentReplyList"] objectAtIndex:i]];
                    mortherDetailView_height += (self.firstDetailReport.frame.size.height );
                    [self.firstDetailReport setHidden:NO];
                }
                    
                    break;
                case 1:
                {
//                    [self.firstDetailReport setFrame:CGRectMake(self.secondDetailReport.frame.origin.x, mortherDetailView_height, 300, 0)];
                    [self.secondDetailReport setFrame:CGRectMake(self.secondDetailReport.frame.origin.x, mortherDetailView_height, 270, 0)];
                    [self.secondDetailReport setDataDictionary:[[_dataDictionary objectForKey:@"CommentReplyList"] objectAtIndex:i]];
                    mortherDetailView_height += (self.secondDetailReport.frame.size.height);
                    [self.secondDetailReport setHidden:NO];
                }
                    
                    break;
                    
                default:
                    break;
            }
//            ZZMotherDetailReport *motherDetailReport = [[ZZMotherDetailReport alloc]initWithFrame:CGRectMake(10, mortherDetailView_height, 300, 0)];
//            [motherDetailReport setDataDictionary:[[_dataDictionary objectForKey:@"CommentReplyList"] objectAtIndex:i]];
//            [reportView addSubview:motherDetailReport];
//            [motherDetailReport release];
//            mortherDetailView_height += (motherDetailReport.frame.size.height + 10);
        }
        [reportView setFrame:CGRectMake(reportView.frame.origin.x, self.CityNameLabel.frame.origin.y + self.CityNameLabel.frame.size.height, reportView.frame.size.width, mortherDetailView_height)];
    }
    CGRect lineRect = self.lineImageView.frame;
    lineRect.origin.y = reportView.frame.origin.y + reportView.frame.size.height + 1;
    [self.lineImageView setFrame:lineRect];

    self.self_height = reportView.frame.origin.y + reportView.frame.size.height;
    
}


@end
