//
//  DiaryDetailViewController.m
//  DreamBaby
//
//  Created by easaa on 14-1-6.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "EADiaryDetailViewController.h"
#import "DiaryCell.h"
#import "UIImageView+WebCache.h"
#import "IsLogIn.h"
#import "MyDiaryCell.h"
#import "NSString+URLEncoding.h"
#import <ShareSDK/ShareSDK.h>

@interface EADiaryDetailViewController ()

@end

@implementation EADiaryDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    RELEASE_SAFE(_dictionary);

    [super dealloc];

//    [contentString release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    self.view.backgroundColor = [UIColor colorwithHexString:@"#FFD9EC"];
    NSLog(@"dic = %@",self.dictionary);
    contentString = [[NSString alloc]init];
    self.navigationItem.title = @"日记详情";
    
    UILabel *titleLabel = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)] autorelease];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navigationItem setTitleView:titleLabel];
    
    if (self.title != nil)
    {
        [titleLabel setText:self.title];
    }
    if (self.navigationItem.title != nil)
    {
        [titleLabel setText:self.navigationItem.title];
    }

    diaryTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 44 - 49) style:UITableViewStylePlain];
    
    diaryTableView.backgroundColor = [UIColor clearColor];
    diaryTableView.backgroundView = nil;
    diaryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    diaryTableView.delegate = self;
    diaryTableView.dataSource = self;
    [self.view addSubview:diaryTableView];
    [diaryTableView release];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    headerView.backgroundColor = [UIColor clearColor];
    
    
    CGSize size = [[self.dictionary objectForKey:@"title"] sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(280, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 280, size.height)];
    [title setNumberOfLines:0];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont systemFontOfSize:16];
    title.textColor = [UIColor colorwithHexString:@"#DD2E94"];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = [self.dictionary objectForKey:@"title"];
    [headerView addSubview:title];
    [title release];
    
    NSString *add_time = [self.dictionary objectForKey:@"add_time"];
    NSDate *date = [self dateFromString:add_time];
    NSString *month = [self monthFromDate:date];
    NSString *day = [self dayFromDate:date];

    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, title.frame.origin.y + title.frame.size.height , 50, 15)];
    timeLabel.backgroundColor = [UIColor clearColor];
    
    timeLabel.font = [UIFont systemFontOfSize:11];
    timeLabel.textColor = [UIColor colorwithHexString:@"#F259B1"];
    
    timeLabel.text = [NSString stringWithFormat:@"%@月%@日",month,day];
    [headerView addSubview:timeLabel];
    [timeLabel release];
    NSLog(@"begin================");
    NSLog(@"%@", [self.dictionary objectForKey:@"add_time"]);
    NSLog(@"end==================");
    
    UILabel *weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, timeLabel.frame.origin.y + timeLabel.frame.size.height , 50, 15 )];
    weekLabel.font = [UIFont systemFontOfSize:11];
    weekLabel.backgroundColor = [UIColor clearColor];
    weekLabel.textColor = [UIColor colorwithHexString:@"#F259B1"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE"];
    
    weekLabel.text = [dateFormat stringFromDate:date];
    [headerView addSubview:weekLabel];
    [dateFormat release];
    [weekLabel release];
   
    [headerView setFrame:CGRectMake(0, 0, 320, size.height + 5  + 30)];
    
    diaryTableView.tableHeaderView = headerView;
    [headerView release];
}

#pragma mark -----TableViewDeklegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *address = [self.dictionary objectForKey:@"address"];
    NSString *content = [self.dictionary objectForKey:@"content"];
    NSString *imgUrl = [self.dictionary objectForKey:IMG_URL];
    content = [content URLDecodedString];
    if ([address intValue] == 1) {
       
        CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        if (imgUrl.length > 0)
        {
            return size.height  + 30 + 210;
        }
        return size.height  + 30;
    }
    return 0.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
        cell.backgroundColor = [UIColor colorwithHexString:@"#FFD9EC"];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = nil;
    NSString *address = [self.dictionary objectForKey:@"address"];
    if ([address intValue] == 1)
    {

        NSString *content = [self.dictionary objectForKey:@"content"];
        contentString = [content URLDecodedString];
      
        CGSize size = [contentString sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
       
        NSString *imgUrl = [self.dictionary objectForKey:IMG_URL];
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 5, 10, 10)];
        [imageView setBackgroundColor:[UIColor clearColor]];
        if (imgUrl.length > 0)
        {
            [imageView  setFrame:CGRectMake( 60, 5 , 200, 200)];

            [imageView setImageWithURL:[NSURL URLWithString:imgUrl]];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [cell addSubview:imageView];
            [imageView release];
        }
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, imageView.frame.origin.y + imageView.frame.size.height + 2, 300, size.height)];
        [contentLabel setText:contentString];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont systemFontOfSize:13];
        contentLabel.numberOfLines = 0;
        contentLabel.textColor = [UIColor colorwithHexString:@"#DD2E94"];
        [cell addSubview:contentLabel];
        [contentLabel release];
    }
    cell.layer.backgroundColor = [UIColor clearColor].CGColor;
    cell.contentView.backgroundColor = [UIColor colorwithHexString:@"#FFD9EC"];
    
    return cell;
}


- (NSDate *)dateFromString:(NSString *)dateString
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    [dateFormatter release];
    
    return destDate;
    
}

- (NSString *)monthFromDate:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit;
    NSDateComponents *dd = [cal components:unitFlags fromDate:date];
    return [NSString stringWithFormat:@"%ld", (long)[dd month]];
    
}

- (NSString *)dayFromDate:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit;
    NSDateComponents *dd = [cal components:unitFlags fromDate:date];
    return [NSString stringWithFormat:@"%ld", (long)[dd day]];
}

- (void)share
{
//    NSData * data = UIImagePNGRepresentation(imageView.image);
    @synchronized(self){
    NSArray *shareLists = @[@1,@2];
        id<ISSContent> publishContent;
        if (((NSString *)[self.dictionary objectForKey:IMG_URL]).length > 0) {
             publishContent = [ShareSDK content:contentString
                                               defaultContent:@""
                                                        image:[ShareSDK pngImageWithImage:imageView.image]
                                                        title:@""
                                                          url:@""
                                                  description:@""
                                                    mediaType:SSPublishContentMediaTypeImage];
        }
        else
        {
            publishContent = [ShareSDK content:contentString
                                defaultContent:@""
                                         image:nil
                                         title:@""
                                           url:@""
                                   description:@""
                                     mediaType:SSPublishContentMediaTypeText];
        }
        
    
    [ShareSDK showShareActionSheet:nil shareList:shareLists content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        NSLog(@"error = %@", error);
    }];
    }
}


@end
