//
//  Created by ShareSDK.cn on 13-1-14.
//  官网地址:http://www.ShareSDK.cn
//  技术支持邮箱:support@sharesdk.cn
//  官方微信:ShareSDK   （如果发布新版本的话，我们将会第一时间通过微信将版本更新内容推送给您。如果使用过程中有任何问题，也可以通过微信与我们取得联系，我们将会在24小时内给予回复）
//  商务QQ:1955211608
//  Copyright (c) 2013年 ShareSDK.cn. All rights reserved.
//

#import "ShareViewController.h"
#import <AGCommon/UIImage+Common.h>
#import "UIView+Common.h"

#import "AGShareCell.h"
//#import "InfoPlistData.h"
#import "AGAuthViewController.h"
#define TARGET_CELL_ID @"targetCell"
#define BASE_TAG 100
//extern InfoPlistData *Infodata;
@interface ShareViewController (Private)

/**
 *	@brief	用户信息更新
 *
 *	@param 	notif 	通知
 */
- (void)userInfoUpdateHandler:(NSNotification *)notif;


@end


@implementation ShareViewController
@synthesize Share_Content;
@synthesize Share_Image;
@synthesize accessToken;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title=@"分享设置";
        //监听用户信息变更
        
     }
    return self;
}

- (void)dealloc
{
    [accessToken release];
    [ShareSDK removeNotificationWithName:SSN_USER_INFO_UPDATE target:self];
    [_shareTypeArray release],_shareTypeArray = nil;
//    [_tableView release],_tableView.delegate = nil;
    [super dealloc];
}

-  (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg"] forBarMetrics:UIBarMetricsDefault];
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];

}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    
    self.navigationItem.title = @"分享设置";
    
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
    
    _tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.width, self.view.height-49)
                                               style:UITableViewStyleGrouped]
                  autorelease];
    _tableView.rowHeight = 50.0;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.backgroundView=nil;
    [self.view addSubview:_tableView];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TARGET_CELL_ID];
    if (cell == nil)
    {
        if (indexPath.row == 0) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TARGET_CELL_ID] autorelease];
            cell.textLabel.text = @"一键分享";
        }else{
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TARGET_CELL_ID] autorelease];
            cell.textLabel.text = @"授权信息";
        }
        
    }
return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0)
    {
        [self shareToSinaWeiboClickHandler:nil];
    }
    else
    {
        AGAuthViewController *auth = [[[AGAuthViewController alloc] init] autorelease];
        [self.navigationController pushViewController:auth animated:YES];
    }
    
}

- (void)shareToSinaWeiboClickHandler:(NSInteger)type
{
//    NSArray *shareLists = @[@1,@2,@5,@7,@8,@22,@23];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"icon"  ofType:@"png"];
    NSArray *shareLists = @[@1,@2];
    id<ISSContent> publishContent = [ShareSDK content:@"【全程关爱、贴心呵护，“梦”享精彩孕期！】孕产育儿专业服务平台 下载地址 http://itunes.apple.com/cn/app/che-bao-mu/id698626681"
                                       defaultContent:@""
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@""
                                                  url:@""
                                          description:@""
                                            mediaType:SSPublishContentMediaTypeText];
    [ShareSDK showShareActionSheet:nil shareList:shareLists content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        
    }];
    /*
    NSArray *shareList = [ShareSDK getShareListWithType:
                          ShareTypeWeixiSession,
                          ShareTypeWeixiTimeline,
                          ShareTypeSinaWeibo,
                          ShareTypeTencentWeibo,
                          ShareTypeQQ,
                          ShareTypeCopy,
                          nil];
    //定义容器
    id<ISSContainer> container = [ShareSDK container];
    
    
    [container setIPhoneContainerWithViewController:self];
    
    
    //定义分享内容
    id<ISSContent> publishContent = nil;
    
    NSString *contentString = @"This is a sample";
    NSString *titleString   = @"title";
    NSString *urlString     = @"http://www.ShareSDK.cn";
    NSString *description   = @"Sample";
    
    publishContent = [ShareSDK content:contentString
                        defaultContent:@""
                                 image:nil
                                 title:titleString
                                   url:urlString
                           description:description
                             mediaType:SSPublishContentMediaTypeText];
    
    //定义分享设置
    id<ISSShareOptions> shareOptions = [ShareSDK simpleShareOptionsWithTitle:@"分享内容" shareViewDelegate:nil];
    
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:NO
                       authOptions:nil
                      shareOptions:shareOptions
                            result:nil];
     */
}





@end
