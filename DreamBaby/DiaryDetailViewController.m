//
//  DiaryDetailViewController.m
//  DreamBaby
//
//  Created by easaa on 14-1-6.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "DiaryDetailViewController.h"
#import "DiaryCell.h"
#import "UIImageView+WebCache.h"
#import "IsLogIn.h"
#import "MyDiaryCell.h"
#import "NSString+URLEncoding.h"
#import <ShareSDK/ShareSDK.h>

@interface DiaryDetailViewController ()

@end

@implementation DiaryDetailViewController

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
    
    
//    IsLogIn *login = [IsLogIn instance];
//    //名字
//    UILabel* nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 230, 30)];
//    nameLabel.text= login.memberData.user_name;
//    nameLabel.font = [UIFont boldSystemFontOfSize:18];
//    nameLabel.backgroundColor = [UIColor clearColor];
//    nameLabel.textColor = [UIColor colorwithHexString:@"#d470a8"];
//    nameLabel.textAlignment = NSTextAlignmentRight;
//    [self.view addSubview:nameLabel];
//    [nameLabel release];
//    
//    //签名
//    UILabel* signLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 230, 15)];
//    signLabel.text= login.memberData.signature;
//    signLabel.font = [UIFont boldSystemFontOfSize:12];
//    signLabel.backgroundColor = [UIColor clearColor];
//    signLabel.textColor = [UIColor colorwithHexString:@"#a9a9a9"];
//    signLabel.textAlignment = NSTextAlignmentRight;
//    [self.view addSubview:signLabel];
//    [signLabel release];
    
    
    diaryTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 44 - 49) style:UITableViewStylePlain];
    
    diaryTableView.backgroundColor = [UIColor clearColor];
    diaryTableView.backgroundView = nil;
    diaryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    diaryTableView.delegate = self;
    diaryTableView.dataSource = self;
    [self.view addSubview:diaryTableView];
    [diaryTableView release];
    
//    //头像
//    UIImageView * headIM = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"riji_touxiang"]];
//    headIM.frame = CGRectMake(235, 10, 70, 70);
//    headIM.userInteractionEnabled = YES;
//    [self.view addSubview:headIM];
//    [headIM release];
//    UIImageView * imag = [[UIImageView alloc]init];
//    imag.frame = CGRectMake(4, 4, 62, 62);
//    [imag setImageWithURL:[NSURL URLWithString:login.memberData.avatar] placeholderImage:[UIImage imageNamed:@"riji_touxiang_pic"]];
//    imag.userInteractionEnabled = YES;
//    [headIM addSubview:imag];
//    [imag release];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    headerView.backgroundColor = [UIColor clearColor];
    
    
    CGSize size = [[self.dictionary objectForKey:@"title"] sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(230, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
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
            return size.height  + 30 + 110;
        }
        return size.height  + 30;
    }
    return 0.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
//    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    tableView.separatorColor = [UIColor redColor];
    static NSString *identifier = @"cell";
    MyDiaryCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
    if (cell==nil) {
        
        cell = [[[MyDiaryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier containingTableView:diaryTableView leftUtilityButtons:nil rightUtilityButtons:nil]autorelease];
        cell.backgroundColor = [UIColor colorwithHexString:@"#FFD9EC"];
//        
        cell.cellScrollView.scrollEnabled = NO;
        cell.cellScrollView.backgroundColor = [UIColor clearColor];
        cell.bgView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = nil;
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:cell.contentLabel.frame];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.tag = 10086;
//        contentLabel.text = @"1112345644456456456456";
        contentLabel.font = [UIFont systemFontOfSize:11];
        contentLabel.numberOfLines = 0;
        contentLabel.textColor = [UIColor colorwithHexString:@"#DD2E94"];
        [cell.bgView addSubview:contentLabel];
        [contentLabel release];
        
        
      
//        UIButton *replayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        replayBtn.frame = CGRectMake(250, 82, 39, 23);
//        [replayBtn setBackgroundImage:[UIImage imageNamed:@"jiaoliu_huifu"] forState:UIControlStateNormal];
//        [replayBtn setBackgroundImage:[UIImage imageNamed:@"jiaoliu_huifu_h"] forState:UIControlStateHighlighted];
//        [replayBtn setTitle:@"分享" forState:UIControlStateNormal];
//        [replayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        replayBtn.titleLabel.font = [UIFont boldSystemFontOfSize:11];
//        replayBtn.tag = 110000;
//        [replayBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchDown];
//        [cell.bgView addSubview:replayBtn];
    }
    
//    NSString *add_time = [self.dictionary objectForKey:@"add_time"];
//    NSDate *date = [self dateFromString:add_time];
//    NSString *month = [self monthFromDate:date];
//    NSString *day = [self dayFromDate:date];
    
//    cell.daySTR = day;
//    cell.month = month;
   
    NSString *address = [self.dictionary objectForKey:@"address"];
    if ([address intValue] == 1) {
//        cell.daySTR = day;
//        cell.month = month;
        NSString *content = [self.dictionary objectForKey:@"content"];
        contentString = [content URLDecodedString];
        UILabel *contentLabel = (UILabel *)[cell.bgView viewWithTag:10086];
//        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 30)];
        [contentLabel setNumberOfLines:0];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.text = contentString;
        [cell addSubview:contentLabel];
//
//        NSLog(@"content = %@",[content URLDecodedString]);
//        cell.contentLabel.text = contentString;
//        cell.contentLabel.hidden = YES;
//        cell.musicLabel.hidden = YES;
//        cell.musicImageView.hidden = YES;
//        cell.contentImageView.hidden = YES;
//        cell.sharebtn.hidden = YES;
//        
        CGSize size = [contentString sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
       
        NSString *imgUrl = [self.dictionary objectForKey:IMG_URL];
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 20, 10, 10)];
        [imageView setBackgroundColor:[UIColor clearColor]];
        if (imgUrl.length > 0)
        {
//            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(contentLabel.frame.origin.x + 10, contentLabel.frame.origin.y + contentLabel.frame.size.height +10, 150, 100)];
            [imageView  setFrame:CGRectMake( 60, 20 , 200, 100)];

            [imageView setImageWithURL:[NSURL URLWithString:imgUrl]];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [cell addSubview:imageView];
            [imageView release];
        }
//        contentLabel.backgroundColor = [UIColor redColor];
         contentLabel.frame = CGRectMake(20, imageView.frame.origin.y + imageView.frame.size.height+ 20, 280, size.height);
//
//
        [cell setCellHeight:size.height + imageView.frame.size.height];
//
//        
//        
//        UIButton *replayBtn = (UIButton *)[cell.bgView viewWithTag:110000];
//        replayBtn.frame = CGRectMake(250, size.height+15, 40, 25);
    }

    cell.layer.backgroundColor = [UIColor clearColor].CGColor;
    cell.contentView.backgroundColor = [UIColor colorwithHexString:@"#FFD9EC"];
    
    return cell;
}


- (NSDate *)dateFromString:(NSString *)dateString{
    
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
    NSArray *shareLists = @[@1,@2,@5,@7,@8,@22,@23];
        id<ISSContent> publishContent;
        if (((NSString *)[self.dictionary objectForKey:IMG_URL]).length > 0) {
             publishContent = [ShareSDK content:contentString
                                               defaultContent:@""
                                                        image:[ShareSDK pngImageWithImage:imageView.image]
                                                        title:@""
                                                          url:@""
                                                  description:@""
                                                    mediaType:SSPublishContentMediaTypeImage];
        }else{
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
