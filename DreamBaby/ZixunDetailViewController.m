//
//  ZixunDetailViewController.m
//  DreamBaby
//
//  Created by easaa on 14-1-7.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "ZixunDetailViewController.h"
#import "HTTPRequest.h"
#import "ATMHud.h"
#import "JsonUtil.h"

#import "FBEncryptorDES.h"
#import "NSString+URLEncoding.h"
#import "UIImageView+WebCache.h"
#import "JsonFactory.h"
@interface ZixunDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    ATMHud *hud;
    float cutHeight;
    int count;
}
@end

@implementation ZixunDetailViewController
@synthesize bgView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        commentMutableArray = [[NSMutableArray alloc]init];
        
        count = 0;
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
        {
            cutHeight = 31;
        }
        else
        {
            cutHeight = 23;
        }
    }
    return self;
}

- (void)dealloc
{
    
    RELEASE_SAFE(commentMutableArray);
    
    RELEASE_SAFE(listView);
    [contentWebView setDelegate:nil];
    RELEASE_SAFE(contentWebView);
    
    RELEASE_SAFE(bgView);
    
    RELEASE_SAFE(containerView);
    RELEASE_SAFE(textView);
    RELEASE_SAFE(leftImage);
    
    RELEASE_SAFE(addPhotoView);
    RELEASE_SAFE(photoBackgroundImageView);
    RELEASE_SAFE(addPhotoButton);
    RELEASE_SAFE(photoImage);
    
     hud.delegate = nil;
    [hud release];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    //show camera...
//    if (!hasLoadedCamera)
//    {
//        [self performSelector:@selector(showcamera) withObject:nil afterDelay:0.3];
//    }
//    
//}
//- (void)showcamera
//{
//    imagePicker = [[UIImagePickerController alloc] init];
//    [imagePicker setDelegate:self];
//    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
//    [imagePicker setAllowsEditing:YES];
//    
//    [self presentModalViewController:imagePicker animated:YES];
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    self.navigationItem.title = @"专家咨询";
    
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
    
    contentScrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 90)];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        [contentScrollerView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 90 - 20)];
    }
    [contentScrollerView setContentInset:UIEdgeInsetsMake(0, 0, 40, 0)];
    //scrollerView.bounds = CGRectMake(0, 0, 260, 400);
    contentScrollerView.contentSize= CGSizeMake(320, self.view.frame.size.height);
    contentScrollerView.backgroundColor = [UIColor clearColor];
    contentScrollerView.pagingEnabled = NO;
    contentScrollerView.bounces = YES;
    [self.view addSubview:contentScrollerView];
    [contentScrollerView release];
    
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 300, 250)];
    //bgView.layer.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4f].CGColor;
    bgView.layer.backgroundColor = [UIColor colorwithHexString:@"#FFD9EC"].CGColor;
    bgView.layer.cornerRadius = 3;
    [contentScrollerView addSubview:bgView];
    
    
    UIImageView *titleImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"huiyuan_kuang01"]];
    [titleImg setFrame:CGRectMake(0, 0, 300, 80)];
    [bgView addSubview:titleImg];
    
    [titleImg release];
 
    //
    hud = [[ATMHud alloc]initWithDelegate:self];
    [self.view addSubview:hud.view];
    
    
    [self getRequest];

}


- (void)createReplyView
{
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, 320, 40)];
    [containerView setBackgroundColor:[UIColor redColor]];
	textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(50, 3, 200, 40)];
    textView.isScrollable = NO;
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
	textView.minNumberOfLines = 1;
	textView.maxNumberOfLines = 3;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
	textView.returnKeyType = UIReturnKeyGo; //just as an example
	textView.font = [UIFont systemFontOfSize:15.0f];
	textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    textView.placeholder = @"请输入您想说的话";
    
    
    [self.view addSubview:containerView];
	
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    //    entryImageView.frame = CGRectMake(5, 0, 248, 40);
    entryImageView.frame = CGRectMake(50, 0, 200, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"replyBackground"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [containerView addSubview:imageView];
    [imageView release];
    [containerView addSubview:textView];
    [containerView addSubview:entryImageView];
    [entryImageView release];
    //添加图片
    addPicture = [UIButton buttonWithType:UIButtonTypeCustom];
	addPicture.frame = CGRectMake(containerView.frame.size.width - 30 - 30, 8, 25, 24);
    
    addPicture.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    
    [addPicture setImage:[UIImage imageNamed:@"mama_xiangji01"] forState:UIControlStateNormal];
    [addPicture setImage:[UIImage imageNamed:@"mama_xiangji01"] forState:UIControlStateSelected];
    [addPicture addTarget:self action:@selector(addPictureAction:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:addPicture];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    //左侧图片
    leftImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mama_xietie"]];
    [leftImage setFrame:CGRectMake(5, 9, 22, 22)];
    [containerView addSubview:leftImage];
    
    //发送
    UIImage *sendBtnBackground = [[UIImage imageNamed:@"mama_lest.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"mama_lest.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
	doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.frame = CGRectMake(containerView.frame.size.width - 30, 8, 25, 24);
    
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [doneBtn addTarget:self action:@selector(sendMessages:) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
	[containerView addSubview:doneBtn];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    
    addPhotoView = [[UIView alloc]initWithFrame:CGRectMake(0, containerView.frame.origin.y + containerView.frame.size.height, 320, 79)];
    [addPhotoView setBackgroundColor:[UIColor whiteColor]];
    [addPhotoView setHidden:YES];
    [self.view addSubview:addPhotoView];
    
    photoBackgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20,10, 280, 46)];
    [addPhotoView addSubview: photoBackgroundImageView];
    [photoBackgroundImageView setImage:[UIImage imageNamed:@"riji6"]];
    [photoBackgroundImageView setUserInteractionEnabled:YES];
    
    addPhotoButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 4, 37, 37)];
    
    [photoBackgroundImageView addSubview:addPhotoButton];
    [addPhotoButton addTarget:self action:@selector(showAddPhotoActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    
    [addPhotoButton setBackgroundImage:[UIImage imageNamed:@"riji2"] forState:UIControlStateNormal];
}

- (void)setExpertReplyView:(NSArray *)sendArray
{
    for (UIView *view in listView.subviews)
    {
        [view removeFromSuperview];
    }

    if (listView == nil)
    {
        listView = [[UIView alloc]init];
        [listView setBackgroundColor:[UIColor colorwithHexString:@"#FFD9EC"]];
        [contentScrollerView addSubview:listView];
        
        [self createReplyView];
    }
    
    [listView setFrame:CGRectMake(10, bgView.frame.origin.y + bgView.frame.size.height, contentScrollerView.frame.size.width, 0)];
    
    if ([sendArray isKindOfClass:[NSArray class]])
    {
        [commentMutableArray setArray:sendArray];
    }

    if (commentMutableArray.count == 0)
    {
        return;
    }

    //留言
    UILabel *messageLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 30)];
    messageLabel.text=@"留言动态";
    
    messageLabel.font=[UIFont boldSystemFontOfSize:14];
    messageLabel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"more_b"]];
    messageLabel.textColor=[UIColor colorwithHexString:@"#FFFFFF"];
    messageLabel.textAlignment=NSTextAlignmentLeft;
    [listView addSubview:messageLabel];
    [messageLabel release];
    
    float listView_height = 30;
    
    for (NSDictionary *dictionary in sendArray)
    {
        ZZExpertCenterView *expertCenterView = [[ZZExpertCenterView alloc]initWithFrame:CGRectMake(0, listView_height, 320, 0)];
        [listView addSubview:expertCenterView];
        [expertCenterView release];
        [expertCenterView setDataDictionary:dictionary];
        listView_height += expertCenterView.frame.size.height;
    }
    [listView setFrame:CGRectMake(0, bgView.frame.origin.y + bgView.frame.size.height, contentScrollerView.frame.size.width, listView_height)];
 
    [contentScrollerView setContentSize:CGSizeMake(contentScrollerView.frame.size.width, listView.frame.origin.y + listView.frame.size.height)];
}

- (void)getComment
{
    [hud setCaption:@"加载中"];
    [hud setActivity:YES];
    [hud show];
    
    dispatch_queue_t network;
    network = dispatch_queue_create("info_detail", nil);
    dispatch_async(network, ^{

        NSString *request1 = [HTTPRequest requestForGetWithPramas:[NSDictionary dictionaryWithObjectsAndKeys:self.Id,@"expert_id", nil]
                                                           method:@"get_expert_reply_message"];
        NSDictionary *dictionary1 = [JsonUtil jsonToDic:request1];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dictionary1 objectForKey:@"msg"]integerValue] == 1) {

                NSString *dataString1 = [dictionary1 objectForKey:@"data"];
                dataString1 = [FBEncryptorDES decrypt:dataString1 keyString:@"SDFL#)@F"];
                dataString1 = [dataString1 URLDecodedString];
                NSArray *array1 = [JsonUtil jsonToArray:dataString1];
                
                NSLog(@"array1 :%@",[array1 description]);
                
                [hud hideAfter:1.0f];

                [self setExpertReplyView:array1];
                
            }else
            {
                if ([dictionary1 objectForKey:@"msgbox"] != NULL) {
//                    [hud setCaption:[dictionary1 objectForKey:@"msgbox"]];
//                    [hud setActivity:NO];
//                    [hud update];
                    
                }else
                {
                    [hud setCaption:@"网络出问题了"];
                    [hud setActivity:NO];
                    [hud update];
                }
                [hud hideAfter:1.0f];
                [self setExpertReplyView:nil];
            }
        });
        
        dispatch_release(network);
    });
}

- (void)getRequest
{
    [hud setCaption:@"加载中"];
    [hud setActivity:YES];
    [hud show];
    
    dispatch_queue_t network;
    network = dispatch_queue_create("info_detail", nil);
    dispatch_async(network, ^{
        NSString *request = [HTTPRequest requestForGetWithPramas:[NSDictionary dictionaryWithObjectsAndKeys:self.Id,@"id", nil]
                                                          method:@"get_new_conte_info"];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];

        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dictionary objectForKey:@"msg"]integerValue] == 1) {
                NSString *dataString = [dictionary objectForKey:@"data"];
                dataString = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
                dataString = [dataString URLDecodedString];
                NSDictionary *dictionary = [JsonUtil jsonToDic:dataString];
                
                
                NSLog(@"begin================");
                NSLog(@"%@", dictionary);
                NSLog(@"end==================");
                [hud hideAfter:1.0f];
                
                if ([dictionary isKindOfClass:[NSDictionary class]])
                {
                    [self setUp:dictionary];
                }
            }else
            {
                if ([dictionary objectForKey:@"msgbox"] != NULL) {
//                    [hud setCaption:[dictionary objectForKey:@"msgbox"]];
//                    [hud setActivity:NO];
//                    [hud update];
                    
                }else
                {
                    [hud setCaption:@"网络出问题了"];
                    [hud setActivity:NO];
                    [hud update];
                }
                [hud hideAfter:1.0f];
            }
            
            [self getComment];

        });
        
        dispatch_release(network);
    });
}

-(void)tapOnce
{
    MessageViewController  *message=[[MessageViewController alloc]init];
    message.hidesBottomBarWhenPushed=YES;
    message.ID=self.Id;
//    self.tabBarController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:message animated:YES];
    [message release];
}



- (void)setUp:(NSDictionary *)dictionary
{
    NSString *img_url = [dictionary objectForKey:@"img_url"];
    
    if (![img_url hasPrefix:@"http://"]) {
        img_url = [@"http://" stringByAppendingString:img_url];
    }
    UIImageView * iconImage =[[UIImageView alloc]init];
    iconImage.frame = CGRectMake(5, 5, 70, 70);
    [bgView addSubview:iconImage];
    [iconImage setImageWithURL:[NSURL URLWithString:img_url]
              placeholderImage:[UIImage imageNamed:@"icon"]];
    [iconImage release];
    //专家名
    UILabel *doctorName = [[UILabel alloc]initWithFrame:CGRectMake(82, 10, 35, 21)];
    doctorName.font = [UIFont systemFontOfSize:11];
    doctorName.backgroundColor = [UIColor clearColor];
    [doctorName setText:@"专家名"];
    doctorName.textColor = [UIColor whiteColor];
    [bgView addSubview:doctorName];
    
    [doctorName release];
    //姓名
    
    UILabel* nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(118, 8, 190, 21)];
    nameLabel.text= [dictionary objectForKey:@"title"];
    nameLabel.font = [UIFont boldSystemFontOfSize:15];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor colorwithHexString:@"#FFFFFF"];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:nameLabel];
    [nameLabel release];
    
//    //职务
//    UILabel* ziwuLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 40, 180, 15)];
//    ziwuLabel.text= [dictionary objectForKey:@"address"];
//    ziwuLabel.font = [UIFont boldSystemFontOfSize:12];
//    ziwuLabel.backgroundColor = [UIColor clearColor];
//    ziwuLabel.textColor = [UIColor colorwithHexString:@"#464545"];
//    ziwuLabel.textAlignment = NSTextAlignmentLeft;
//    [bgView addSubview:ziwuLabel];
//    [ziwuLabel release];
    
    
    
    
    
    //
    UIButton *teleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    teleBtn.frame=CGRectMake(85, 50, 114, 22);
    [teleBtn setTitle:[@"电话:" stringByAppendingString:[dictionary objectForKey:@"telephone"]]  forState:UIControlStateNormal];
//    teleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 5, 0);
    teleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [teleBtn setTitleColor:[UIColor colorwithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [teleBtn setBackgroundImage:[UIImage imageNamed:@"hopen_01"] forState:UIControlStateNormal];
    [teleBtn setBackgroundImage:[UIImage imageNamed:@"hopen_01"] forState:UIControlStateHighlighted];
    [teleBtn addTarget:self action:@selector(teleBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:teleBtn];
    
    
    //专家介绍
    UILabel* jieshaoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 300, 30)];
    jieshaoLabel.text= @"专家介绍";
    jieshaoLabel.font = [UIFont boldSystemFontOfSize:14];
    jieshaoLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"more_b"]];
    jieshaoLabel.textColor =[UIColor colorwithHexString:@"#FFFFFF"];
    jieshaoLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:jieshaoLabel];
    [jieshaoLabel release];
    
    contentWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 130, 300, 150)];
    [bgView addSubview:contentWebView];
    contentWebView.backgroundColor = [UIColor clearColor];
    contentWebView.opaque = NO;
    [contentWebView setDelegate:self];
    
    
    NSString *urlString = [[dictionary objectForKey:@"content"] URLDecodedString];
    [contentWebView loadHTMLString:urlString baseURL:Nil];
    
 
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}


- (void)teleBtnPressed:(UIButton *)button
{
    NSString *string = [button titleForState:UIControlStateNormal];
    NSString * phoneNum = [string substringFromIndex:3];
    
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:phoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

#pragma mark -webViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    if (webView.scrollView.contentSize.height > webView.frame.size.height)
    {
        CGRect rect = webView.frame;
        rect.size.height = webView.scrollView.contentSize.height;
        [webView setFrame:rect];
        [bgView setFrame:CGRectMake(bgView.frame.origin.x, bgView.frame.origin.y, bgView.frame.size.width, webView.frame.origin.y + webView.frame.size.height)];
        [listView setFrame:CGRectMake(0, bgView.frame.origin.y + bgView.frame.size.height, contentScrollerView.frame.size.width, listView.frame.size.height)];
        [contentScrollerView setContentSize:CGSizeMake(contentScrollerView.frame.size.width, listView.frame.origin.y + listView.frame.size.height)];
    }

    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
    
}

#pragma mark -scorllViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{

    if (contentWebView.scrollView.contentSize.height > contentWebView.frame.size.height)
    {
        CGRect rect = contentWebView.frame;
        rect.size.height = contentWebView.scrollView.contentSize.height;
        [contentWebView setFrame:rect];
        [bgView setFrame:CGRectMake(bgView.frame.origin.x, bgView.frame.origin.y, contentWebView.frame.size.width, contentWebView.frame.origin.y + contentWebView.frame.size.height)];
        [listView setFrame:CGRectMake(0, bgView.frame.origin.y + bgView.frame.size.height, contentScrollerView.frame.size.width, listView.frame.size.height)];
        [contentScrollerView setContentSize:CGSizeMake(contentScrollerView.frame.size.width, listView.frame.origin.y + listView.frame.size.height)];
    }
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification 
                                               object:nil];
}

#pragma mark - comment
- (void)sendComment
{
 
    
    
    NSString *user_id = [IsLogIn instance].memberData.idString;
    NSLog(@"user = %@",user_id);
    
    
    
    NSDictionary *postDic = [NSDictionary dictionaryWithObjectsAndKeys:self.Id,@"expert_id",
                             [IsLogIn instance].memberData.user_name,@"messager",
                             textView.text,@"mesage_content",
                             
                             nil];
    
    dispatch_queue_t network_queue;
    network_queue = dispatch_queue_create("leave_message", nil);
    dispatch_async(network_queue, ^{
        NSData *data = UIImageJPEGRepresentation(photoImage , 0.1);
        NSString *tem = [data base64Encoding];
        tem = [NSString stringWithFormat:@"%@",tem];
        tem =[tem stringByReplacingOccurrencesOfString:@"+" withString:@"|JH|"];
        tem=[tem stringByReplacingOccurrencesOfString:@" " withString:@"|KG|"];
        NSString *lTmp = [NSString stringWithFormat:@"%c",'\n'];
        NSString *lTmp2 = [NSString stringWithFormat:@"%c",'\r'];
        tem= [tem stringByReplacingOccurrencesOfString:lTmp withString:@"|HC|"];
        tem= [tem stringByReplacingOccurrencesOfString:lTmp2 withString:@"|HC|"];
        
        NSString *paramsJson = [JsonFactory dictoryToJsonStr:postDic];
        
        //    NSLog(@"requestParamstr %@",paramsJson);
        //加密
        paramsJson = [[FBEncryptorDES encrypt:paramsJson
                                    keyString:@"SDFL#)@F"] uppercaseString];
        NSString *signs= [NSString stringWithFormat:@"SDFL#)@FMethod%@Params%@SDFL#)@F",@"leave_message",paramsJson];
        signs = [[FBEncryptorDES md5:signs] uppercaseString];
        
        NSString *urlStr = [NSString stringWithFormat:BABYAPI,@"leave_message",paramsJson,signs];
        //            NSString *urlStr = [NSString stringWithFormat:@"http://192.168.0.23:16327/api/GetFetationInfo.ashx?Method=%@&Params=%@&Sign=%@",@"add_note",paramsJson,signs];
        NSString *postString = [NSString stringWithFormat:@"img_url=%@&mesage_content=%@",tem,textView.text];
        //            NSData *postData = [self htmlImageString:tem textViewString:postString];
        NSString *request = [HTTPRequest requestForPost:urlStr :postString];
        //            NSString *request = [HTTPRequest requestForHtmlPost:urlStr :postData];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[dictionary objectForKey:@"msg"]intValue] == 1)
                {
                    [self replyViewReleasedAfterSendMessage];
                      [self getComment];

                    [hud setCaption:@"评论帖子成功"];
                    [hud setActivity:NO];
                    [hud show];
                    [hud update];
                    [hud hideAfter:1.0f];
                    photoImage = nil;
                    
                }else
                {
                    [textView resignFirstResponder];
                    if ([dictionary objectForKey:@"msgbox"] != NULL) {
                        [hud setCaption:[dictionary objectForKey:@"msgbox"]];
                        [hud setActivity:NO];
                        [hud show];
                        [hud hideAfter:1.0f];
                    }else
                    {
                        [hud setCaption:@"网络出问题了"];
                        [hud setActivity:NO];
                        [hud show];
                        [hud hideAfter:1.0f];
                    }
                }
            });
        });

}


- (void)sendMessages:(UIButton *)button
{
    if (textView.text.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil
                                                           message:@"请输入内容"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
        
        [alertView show];
        [alertView release];
        return;
    }
    else
    {
       [self sendComment];
    }

}
- (void)showAddPhotoActionSheet: (UIButton *)senderButton
{
    if (photoImage == nil)
    {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"从相册选取", nil];
        [actionSheet showInView:self.view];
        [actionSheet release];
        [actionSheet setTag:1213];
        
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"从相册选取", nil];
        [actionSheet showInView:self.view];
        [actionSheet release];
        [actionSheet setTag:1213];
    }
    
    
    
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag)
    {
        case 1213:
        {
            switch (buttonIndex)
            {
                case 0:
                {
                    //相机
//                    isShowingImagePickerView = YES;
                    [textView  resignFirstResponder];
                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
                    imagePicker.delegate = self;
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    imagePicker.allowsEditing = YES;
                    imagePicker.showsCameraControls = YES;
                    [self.navigationController presentViewController:imagePicker animated:YES completion:NULL];
                    [imagePicker release];
                    
                }
                    break;
                case 1:
                {
                    //相册
//                     isShowingImagePickerView = YES;
                    [textView resignFirstResponder];
                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
                    imagePicker.delegate = self;
                    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    imagePicker.allowsEditing = YES;
                    [self.navigationController presentViewController:imagePicker animated:YES completion:NULL];
                    [imagePicker release];

                }
                    break;
//                case 2:
//                {
//                    //删除照片
//                    photoImage = nil;
//                }
//                    break;
                    
                default:
                    break;
            }
            
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark -- image的翻转
-(UIImage *)rotateImage:(UIImage *)aImage
{
    CGImageRef imgRef = aImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    UIImageOrientation orient = aImage.imageOrientation;
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            break;
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
    {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    UIImage *image = [self rotateImage:[info objectForKey:UIImagePickerControllerEditedImage]];;
    

    //截取imageview
    CGRect imageRect;
    //计算截取范围
    if (image.size.width>=image.size.height) {
        imageRect=CGRectMake((image.size.width-image.size.height)/2, 0, image.size.height, image.size.height);
    }else{
        imageRect=CGRectMake(0, (image.size.height-image.size.width)/2, image.size.width, image.size.width);
    }
    //生成图片
    CGImageRef cgimage=CGImageCreateWithImageInRect(image.CGImage, imageRect);
    UIImage *creatImage=[[UIImage alloc]initWithCGImage:cgimage];
    //这里主要要释放cgImage
    CGImageRelease(cgimage);
    if (photoImage)
    {
        [photoImage release];
        photoImage = nil;
    }
    photoImage = [creatImage retain];
    [addPhotoButton setBackgroundImage:photoImage forState:UIControlStateNormal];

//    [picker dismissViewControllerAnimated:YES completion:^{
//
//        [addPhotoButton setBackgroundImage:photoImage forState:UIControlStateNormal];
//    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:^{

    }];
}



- (void)replyViewReleasedAfterSendMessage
{
     [textView resignFirstResponder];
    
    [addPhotoView setHidden:YES];
    textView.text = @"";
    
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    containerView.frame = containerFrame;
    
   
    
    
}
- (void)addPictureAction:(id)sender
{
    [addPhotoView setHidden:!addPhotoView.hidden];
    if (addPhotoView.hidden)
    {

        [containerView setFrame:CGRectMake(containerView.frame.origin.x, containerView.frame.origin.y + 79, containerView.frame.size.width, containerView.frame.size.height)];
        [addPhotoView setFrame:CGRectMake(0, containerView.frame.origin.y + containerView.frame.size.height, 320, 79)];
    }
    else
    {

        CGRect containerFrame = containerView.frame;
        containerFrame.origin.y = containerView.frame.origin.y - 79;

        containerView.frame = containerFrame;

        
        
        [addPhotoView setFrame:CGRectMake(0, containerView.frame.origin.y + containerView.frame.size.height, 320, 79)];
        [addPhotoButton setBackgroundImage:[UIImage imageNamed:@"riji2"] forState:UIControlStateNormal];
        
    }
}

-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
    
    
	CGRect containerFrame = containerView.frame;
    if (addPhotoView.hidden)
    {
        containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    }
    else
    {
        containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height + addPhotoView.frame.size.height);
        
        [addPhotoView setFrame:CGRectMake(0, containerFrame.origin.y + containerFrame.size.height, 320, 79)];
    }
    
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	containerView.frame = containerFrame;
    
	
	// commit animations
	[UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    
    if (addPhotoView.hidden)
    {
         containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    }
    else
    {
        containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height - addPhotoView.frame.size.height;
        
        [addPhotoView setFrame:CGRectMake(0, containerFrame.origin.y + containerFrame.size.height, 320, 79)];
    }
    
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	containerView.frame = r;
    doneBtn.center = CGPointMake(doneBtn.center.x, doneBtn.center.y + diff / 2);
    [leftImage setCenter:CGPointMake(leftImage.center.x, doneBtn.center.y)];
    [addPicture setCenter:CGPointMake(addPicture.center.x, doneBtn.center.y)];
}
@end
