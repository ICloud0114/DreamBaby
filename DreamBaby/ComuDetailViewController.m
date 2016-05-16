//
//  ComuDetailViewController.m
//  DreamBaby
//
//  Created by easaa on 14-1-8.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "ComuDetailViewController.h"
#import "HTTPRequest.h"
#import "JsonUtil.h"
#import "NSString+URLEncoding.h"
#import "FBEncryptorDES.h"
#import "ATMHud.h"
#import "SVPullToRefresh.h"
#import "IsLogIn.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "FloorDetailViewController.h"
#import "JsonFactory.h"

#import "ZZExpertCenterView.h"
@interface ComuDetailViewController ()<UITextViewDelegate>
{
    NSString     *floorId;
    BOOL         isFloor;
    NSMutableDictionary *sectionDict;
    CGFloat sectionHeight;
    NSInteger pageIndex;
    NSInteger pageSize;
    ATMHud *hud;
    
    int whichComment;
    float listView_height;
    
    float cutHeight;
    int count;
}

@property (nonatomic ,retain) NSMutableArray *infoArray;
@end

@implementation ComuDetailViewController
@synthesize bgView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        pageIndex = 1;
        pageSize = 10;
        whichComment = 1024;
        
        sectionDict = [[NSMutableDictionary dictionary]retain];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reLoadTableView) name:@"reloadComuDetail" object:nil];
        
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
    RELEASE_SAFE(sectionDict);
    RELEASE_SAFE(_infoArray);
    RELEASE_SAFE(bgView);
    
    RELEASE_SAFE(containerView);
    RELEASE_SAFE(textView);
    RELEASE_SAFE(leftImage);
    
    RELEASE_SAFE(addPhotoView);
    RELEASE_SAFE(photoBackgroundImageView);
    RELEASE_SAFE(addPhotoButton);
    RELEASE_SAFE(photoImage);
    self.ageGroup = nil;
    self.contentString = nil;
    self.name =nil;

    [[NSNotificationCenter defaultCenter]removeObserver:self];
    hud.delegate = nil;
    [hud release];
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated
{
   
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [textView resignFirstResponder];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    isSendMessage = NO;
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    self.navigationItem.title = @"妈妈交流";
    
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
    

    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 20 - 44 - 40)];
    //bgView.layer.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4f].CGColor;
    bgView.layer.backgroundColor = [UIColor colorwithHexString:@"#e7d4df"].CGColor;
    bgView.layer.cornerRadius = 3;
    [self.view addSubview:bgView];
    
    hud = [[ATMHud alloc]initWithDelegate:self];
    [self.view addSubview:hud.view];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    self.infoArray = tempArray;
    
    [self getRequest:YES];
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
- (void)setupsubViews:(NSDictionary *)dictionary
{
    
    if (mTableView != nil)
    {
        [mTableView removeFromSuperview];
        mTableView = nil;
    }
    
    mTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, bgView.bounds.size.height) style:UITableViewStylePlain];
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.backgroundView = nil;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.delegate=self;
    mTableView.dataSource=self;
    
    [bgView addSubview:mTableView];
    
    [mTableView release];
    
    [mTableView addInfiniteScrollingWithActionHandler:^{
        [self getRequest:NO];
    }];
    
    
    [mTableView setTableHeaderView:[self cellForHead]];
    
    [self createReplyView];
    

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


- (void)sendMessages:(UIButton *)button
{
    if (textView.text.length == 0 || [textView.text isEqualToString:@"请输入您想说的话"])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Nil
                                                           message:@"请输入内容"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    }
    NSString *content = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (isFloor)
    {
        [self getCommentFloor:content];
    }
    else
    {
        [self getCommentRequest:content];
    }
}



- (void)getRequest:(BOOL)isfirst
{
    if (isfirst) {
        [hud setCaption:@"加载中"];
        [hud setActivity:YES];
        [hud show];
        pageIndex = 1;
        
        if (self.infoArray.count)
        {
            
            [self.infoArray removeAllObjects];
        }
        
        
    }
    
    dispatch_queue_t network ;
    network = dispatch_queue_create("get_comment_detail", nil);
    dispatch_async(network, ^{
       NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.Id,@"article_id",
                                   [NSString stringWithFormat:@"%d",pageIndex],@"page_index",
                                   [NSString stringWithFormat:@"%d",pageSize],@"page_size",nil];
        NSString *request = [HTTPRequest requestForGetWithPramas:dictionary method:@"get_comment_detail"];
        NSDictionary *json = [JsonUtil jsonToDic:request];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[json objectForKey:@"msg"]intValue] == 1) {
                
                
                NSString *dataString = [json objectForKey:@"data"];
                dataString = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
                dataString = [dataString URLDecodedString];
                
//                [dataString release];
                
                NSDictionary *result = [JsonUtil jsonToDic:dataString];
//                NSLog(@"result = %@",[result objectForKey:@"age_group"]);
                if (isfirst)
                {
                    sectionHeight = 135;
                    NSLog(@"begin================");
                    NSLog(@"result----->%@", result);
                    NSLog(@"end==================");
                    
//                    sectionDict = [result copy];
                    [sectionDict setDictionary:result];
                    [self setupsubViews:result];
                    [hud hideAfter:1.0f];
                   
                    if ([result objectForKey:@"age_group"] != [NSNull null]&& ((NSString *)[result objectForKey:@"title"]).length > 0 && ((NSString *)[result objectForKey:@"content"]).length > 0) {
                        NSLog(@"age_group = %@",[result objectForKey:@"age_group"]);
                        NSLog(@"title = %@",[result objectForKey:@"title"]);
                        NSLog(@"content = %@",[result objectForKey:@"content"]);
                        self.ageGroup = [[[NSString alloc]initWithString:[result objectForKey:@"age_group"]] autorelease];
                        self.name = [[[NSString alloc]initWithString:[result objectForKey:@"title"]] autorelease];
                        self.contentString = [[NSString stringWithString:[result objectForKey:@"content"]] stringByConvertingHTMLToPlainText];
                        NSLog(@"cont = %@", self.contentString);
                    }
                }
                
                //截取imageview
    
                if ([[result objectForKey:@"list"] isKindOfClass:[NSArray class]])
                {
                    NSArray *array = [result objectForKey:@"list"];
                    NSLog(@"arr=%@",array);
                    [self.infoArray addObjectsFromArray:array];
                    [mTableView reloadData];
                    [mTableView.infiniteScrollingView stopAnimating];
                    
                    if (array.count < 10) {
                        mTableView.infiniteScrollingView.enabled = NO;
                    }else
                    {
                        pageIndex ++;
                    }
                }
                
                
            }else
            {
                [mTableView.infiniteScrollingView stopAnimating];
                if ([json objectForKey:@"msgbox"] != NULL) {
                    if (isfirst) {
                        [hud setCaption:[json objectForKey:@"msgbox"]];
                        [hud setActivity:NO];
                        [hud show];
                        [hud hideAfter:1.0f];
                    }
                }else
                {
                    if (isfirst) {
                        [hud setCaption:@"网络出问题了"];
                        [hud setActivity:NO];
                        [hud show];
                        [hud hideAfter:1.0f];
                    }
                }
            }
        });
    });
}



- (void)reLoadTableView
{

        [hud setCaption:@"加载中"];
        [hud setActivity:YES];
        [hud show];

    
    dispatch_queue_t network ;
    network = dispatch_queue_create("get_comment_detail", nil);
    dispatch_async(network, ^{
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.Id,@"article_id",
                                    [NSNumber numberWithInt:1],@"page_index",
                                    [NSString stringWithFormat:@"%d",pageSize],@"page_size",nil];
        NSString *request = [HTTPRequest requestForGetWithPramas:dictionary method:@"get_comment_detail"];
        NSDictionary *json = [JsonUtil jsonToDic:request];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[json objectForKey:@"msg"]intValue] == 1) {
                
                
                NSString *dataString = [json objectForKey:@"data"];
                dataString = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
                dataString = [dataString URLDecodedString];
                
                //                [dataString release];
                
                NSDictionary *result = [JsonUtil jsonToDic:dataString];
                //                NSLog(@"result = %@",[result objectForKey:@"age_group"]);
                NSLog(@"begin================");
                NSLog(@"dictionary -->%@",dictionary );
                NSLog(@"end==================");
                    sectionHeight = 135;
//                    sectionDict = [result copy];
                [sectionDict setDictionary:result];

                    [hud hideAfter:1.0f];
                    
                    if ([result objectForKey:@"age_group"] != [NSNull null]&& ((NSString *)[result objectForKey:@"title"]).length > 0 && ((NSString *)[result objectForKey:@"content"]).length > 0)
                    {
                        NSLog(@"age_group = %@",[result objectForKey:@"age_group"]);
                        NSLog(@"title = %@",[result objectForKey:@"title"]);
                        NSLog(@"content = %@",[result objectForKey:@"content"]);
                        self.ageGroup = [[[NSString alloc]initWithString:[result objectForKey:@"age_group"]] autorelease];
                        self.name = [[[NSString alloc]initWithString:[result objectForKey:@"title"]] autorelease];
                        self.contentString = [[NSString stringWithString:[result objectForKey:@"content"]] stringByConvertingHTMLToPlainText];
                        NSLog(@"cont = %@", self.contentString);
                    }
             
                
                //截取imageview
                
                if ([[result objectForKey:@"list"] isKindOfClass:[NSArray class]])
                {
                    NSArray *array = [result objectForKey:@"list"];
                    NSLog(@"arr=%@",array);
                    if (self.infoArray.count > 0)
                    {
                        [self.infoArray removeAllObjects];
                    }
                    [self.infoArray addObjectsFromArray:array];
                    
                    [mTableView.infiniteScrollingView stopAnimating];
                    [mTableView reloadData];
                    
                    
                    if (array.count < 10)
                    {
                        mTableView.infiniteScrollingView.enabled = NO;
                    }
                    else
                    {
                        pageIndex ++;
                    }
                    
                }    
                
            }else
            {
                [mTableView.infiniteScrollingView stopAnimating];
                if ([json objectForKey:@"msgbox"] != NULL) {
                   
                        [hud setCaption:[json objectForKey:@"msgbox"]];
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

#pragma mark - comment
- (void)getCommentRequest:(NSString *)content
{
    if (isSendMessage == NO)
    {
        isSendMessage = YES;
        [hud setCaption:@"评论中"];
        [hud setActivity:YES];
        [hud show];
//    dispatch_queue_t network ;
//    network = dispatch_queue_create("comment_invitation", nil);
//    dispatch_async(network, ^{
//    
//        NSDictionary *postDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    self.Id,@"article_id",
//                                    [IsLogIn instance].memberData.idString,@"user_id",
//                                    content,@"content",
//                                    
//                                 nil];
//        NSData *data = UIImageJPEGRepresentation(replyView.photoImage , 0.1);
//        NSString *tem = [data base64Encoding];
//        tem = [NSString stringWithFormat:@"%@",tem];
//        tem =[tem stringByReplacingOccurrencesOfString:@"+" withString:@"|JH|"];
//        tem=[tem stringByReplacingOccurrencesOfString:@" " withString:@"|KG|"];
//        NSString *lTmp = [NSString stringWithFormat:@"%c",'\n'];
//        NSString *lTmp2 = [NSString stringWithFormat:@"%c",'\r'];
//        tem= [tem stringByReplacingOccurrencesOfString:lTmp withString:@"|HC|"];
//        tem= [tem stringByReplacingOccurrencesOfString:lTmp2 withString:@"|HC|"];
//        
//        NSString *paramsJson = [JsonFactory dictoryToJsonStr:postDic];
//        
//        //    NSLog(@"requestParamstr %@",paramsJson);
//        //加密
//        paramsJson = [[FBEncryptorDES encrypt:paramsJson
//                                    keyString:@"SDFL#)@F"] uppercaseString];
//        NSString *signs= [NSString stringWithFormat:@"SDFL#)@FMethod%@Params%@SDFL#)@F",@"comment_invitation",paramsJson];
//        signs = [[FBEncryptorDES md5:signs] uppercaseString];
//        
//        NSString *urlStr = [NSString stringWithFormat:BABYAPI,@"comment_invitation",paramsJson,signs];
//        //            NSString *urlStr = [NSString stringWithFormat:@"http://192.168.0.23:16327/api/GetFetationInfo.ashx?Method=%@&Params=%@&Sign=%@",@"add_note",paramsJson,signs];
//        NSString *postString = [NSString stringWithFormat:@"image=%@&content=%@",tem,content];
//        //            NSData *postData = [self htmlImageString:tem textViewString:postString];
//        NSString *request = [HTTPRequest requestForPost:urlStr :postString];
//        //            NSString *request = [HTTPRequest requestForHtmlPost:urlStr :postData];
//        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        NSString *user_id = [IsLogIn instance].memberData.idString;
        NSLog(@"user = %@",user_id);
        NSDictionary *postDic = [NSDictionary dictionaryWithObjectsAndKeys:user_id,@"user_id",
                                 self.Id,@"article_id",
                                 content,@"content",
                                 nil];
        dispatch_queue_t network_queue;
        network_queue = dispatch_queue_create("upload.text", nil);
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
            NSString *signs= [NSString stringWithFormat:@"SDFL#)@FMethod%@Params%@SDFL#)@F",@"comment_invitation",paramsJson];
            signs = [[FBEncryptorDES md5:signs] uppercaseString];
            
            NSString *urlStr = [NSString stringWithFormat:BABYAPI,@"comment_invitation",paramsJson,signs];
            //            NSString *urlStr = [NSString stringWithFormat:@"http://192.168.0.23:16327/api/GetFetationInfo.ashx?Method=%@&Params=%@&Sign=%@",@"add_note",paramsJson,signs];
            NSString *postString = [NSString stringWithFormat:@"reply_img=%@&content=%@",tem,content];
            //            NSData *postData = [self htmlImageString:tem textViewString:postString];
            NSString *request = [HTTPRequest requestForPost:urlStr :postString];
            //            NSString *request = [HTTPRequest requestForHtmlPost:urlStr :postData];
            NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        

        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dictionary objectForKey:@"msg"]intValue] == 1)
            {
                [self replyViewReleasedAfterSendMessage];
                isFloor = NO;
                
                NSString *dataString = [dictionary objectForKey:@"data"];
                dataString = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
                dataString = [dataString URLDecodedString];
                NSDictionary *result = [JsonUtil jsonToDic:dataString];
                [self.infoArray insertObject:result atIndex:0];
                
                
//                [mTableView beginUpdates];
//                [mTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
//                [mTableView endUpdates];
//                
//                [mTableView setTableHeaderView:[self cellForHead]];
                
//                [self reLoadTableView];
                [self getRequest:YES];

                [hud setCaption:@"评论帖子成功"];
                [hud setActivity:NO];
                [hud show];
                [hud update];
                [hud hideAfter:1.0f];
                isSendMessage = NO;
                
            }else
            {
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
                isSendMessage = NO;
            }
        });
    });
    }
}

#pragma mark - comment floor
- (void)getCommentFloor:(NSString *)content
{

    if (isFloor)
    {
        isFloor = NO;
        [hud setCaption:@"评论中"];
        [hud setActivity:YES];
        [hud show];
        NSString *user_id = [IsLogIn instance].memberData.idString;
        NSLog(@"user = %@",user_id);
        NSDictionary *postDic = [NSDictionary dictionaryWithObjectsAndKeys:user_id,@"user_id",
                                 floorId,@"comment_id",
                                 content,@"content",
                                 nil];
        dispatch_queue_t network_queue;
        network_queue = dispatch_queue_create("reply_invitation", nil);
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
            NSString *signs= [NSString stringWithFormat:@"SDFL#)@FMethod%@Params%@SDFL#)@F",@"reply_invitation",paramsJson];
            signs = [[FBEncryptorDES md5:signs] uppercaseString];
            
            NSString *urlStr = [NSString stringWithFormat:BABYAPI,@"reply_invitation",paramsJson,signs];
            //            NSString *urlStr = [NSString stringWithFormat:@"http://192.168.0.23:16327/api/GetFetationInfo.ashx?Method=%@&Params=%@&Sign=%@",@"add_note",paramsJson,signs];
            NSString *postString = [NSString stringWithFormat:@"reply_img=%@&content=%@",tem,content];
            //            NSData *postData = [self htmlImageString:tem textViewString:postString];
            NSString *request = [HTTPRequest requestForPost:urlStr :postString];
            //            NSString *request = [HTTPRequest requestForHtmlPost:urlStr :postData];
            NSDictionary *json = [JsonUtil jsonToDic:request];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[json objectForKey:@"msg"]intValue] == 1) {
                    
                    
                    NSLog(@"json :%@",[json description]);
                    
                    [self replyViewReleasedAfterSendMessage];
                    
//                    NSString *dataString = [json objectForKey:@"data"];
//                    dataString = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
//                    dataString = [dataString URLDecodedString];
//                    NSDictionary *result = [JsonUtil jsonToDic:dataString];
//                    [self.infoArray insertObject:result atIndex:0];
                    
//                    [mTableView beginUpdates];
//                    [mTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
//                    [mTableView endUpdates];
                    
                    
//                    [mTableView setTableHeaderView:[self cellForHead]];
//                    [self reLoadTableView];
                    [self getRequest:YES];

                    
                    photoImage = nil;
                    [hud setCaption:@"评论楼层成功"];
                    [hud setActivity:NO];
                    [hud show];
                    [hud hideAfter:1.0f];
                    
                    isFloor = NO;
                }else
                {
                    if ([json objectForKey:@"msgbox"] != NULL)
                    {
                        [textView resignFirstResponder];
                        
                        [hud setCaption:[json objectForKey:@"msgbox"]];
                        [hud setActivity:NO];
                        [hud show];
                        [hud hideAfter:1.0f];

                    }else
                    {
                        [textView resignFirstResponder];
                        
                        [hud setCaption:@"网络出问题了"];
                        [hud setActivity:NO];
                        [hud show];
                        [hud hideAfter:1.0f];

                    }
                    isFloor = NO;
                }
            });
        });
    }
}
#pragma mark -----TableViewDeklegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
//    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {
//        if (sectionDict) {
//            return 1;
//        }
//    }else
//    {
    if (self.infoArray)
    {
        return self.infoArray.count;
    }
//    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
////        return sectionHeight;
//        //没有图片
//        JiaoliuDetailCell * cell = [[[NSBundle mainBundle]loadNibNamed:@"JiaoliuDetailCell" owner:self options:nil]lastObject];
//        [cell nibInit];
//        [cell.ContentLabel setFrame:CGRectMake(76, 40, 210, 35)];
//
//        if ([[sectionDict objectForKey:@"content"] isKindOfClass:[NSString class]])
//        {
//            [cell.ContentLabel setText:[sectionDict objectForKey:@"content"]];
//        }
//        CGSize contentSize = ZZ_MULTILINE_TEXTSIZE(cell.ContentLabel.text, cell.ContentLabel.font, CGSizeMake(cell.ContentLabel.frame.size.width, 9999), cell.ContentLabel.lineBreakMode);
//        
//        float height =  70 + (contentSize.height > cell.ContentLabel.frame.size.height ? contentSize.height : cell.ContentLabel.frame.size.height);
//        NSLog(@"楼主：%.f",height);
//        return height;
//        
//    }else
//    {
        JiaoliuDetailCell * cell = [[[NSBundle mainBundle]loadNibNamed:@"JiaoliuDetailCell" owner:self options:nil]lastObject];
        [cell nibInit];
        NSDictionary *dictionary = [self.infoArray objectAtIndex:indexPath.row];
        [cell setDataDictionary:dictionary];
        return cell.self_height;
    NSLog(@"%@",[NSDate date]);
//    }
    return 0;
}

- (JiaoliuDetailCell *)cellForHead
{
    JiaoliuDetailCell * cell =[[[NSBundle mainBundle]loadNibNamed:@"JiaoliuDetailCell" owner:self options:nil]lastObject];
    [cell nibInit];
    
    
    [cell.NameLabel setTextColor:[UIColor whiteColor]];
    [cell.DataLabel setTextColor:[UIColor whiteColor]];
    [cell.ContentLabel setTextColor:[UIColor whiteColor]];
    [cell.CityNameLabel setTextColor:[UIColor whiteColor]];
    [cell.ReplyBtn setHidden:YES];
    [cell setBackgroundColor:[UIColor colorwithHexString:@"#ed82bf"]];
    
//    [cell.IconImageView setFrame:CGRectMake(5, 5, 66, 66)];
//    [cell.NameLabel setFrame:CGRectMake(76, 10, 100, 18)];
//    [cell.DataLabel setFrame:CGRectMake(180, 15, 50, 14)];
//    [cell.ContentLabel setFrame:CGRectMake(76, 40, 210, 35)];
//    [cell.CityNameLabel setFrame:CGRectMake(76, 76, 230, 14)];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
//    NSDictionary *dic = [sectionDict objectForKey:@"list"][0];
    if ([[sectionDict objectForKey:@"avatar"] isKindOfClass:[NSString class]])
    {
        NSURL *url = [NSURL URLWithString:[sectionDict objectForKey:@"avatar"]];
        if (url)
        {
            
            [cell.IconImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon"]];
        }
    }

    if ([[sectionDict objectForKey:@"title"] isKindOfClass:[NSString class]])
    {
        
        CGSize size = [[sectionDict objectForKey:@"title"] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(230, 10000)];
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
        {
            size.height += 1;
        }

//        cell.NameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [cell.NameLabel setFrame:CGRectMake(cell.NameLabel.frame.origin.x, cell.IconImageView.frame.origin.y, 230, size.height)];
        
        [cell.NameLabel setText:[sectionDict objectForKey:@"title"]];
    }
    
    
    UILabel *firstFloorLabel = [[UILabel alloc]initWithFrame:CGRectMake(220, cell.NameLabel.frame.origin.y + cell.NameLabel.frame.size.height + 1, 95, 14)];
    [cell addSubview:firstFloorLabel];
    [firstFloorLabel release];
    [firstFloorLabel setTextColor:[UIColor whiteColor]];
    [firstFloorLabel setBackgroundColor:[UIColor clearColor]];
    [firstFloorLabel setTextAlignment:NSTextAlignmentRight];
    [firstFloorLabel setFont:[UIFont systemFontOfSize:10]];
    if ([[sectionDict objectForKey:@"nick_name"] isEqualToString:@""])
    {
        [firstFloorLabel setText:[NSString stringWithFormat:@"楼主"]];
    }
    else
    {
        [firstFloorLabel setText:[NSString stringWithFormat:@"楼主: %@", [sectionDict objectForKey:@"nick_name"]]];
    }
    if ([[sectionDict objectForKey:@"time_span"] isKindOfClass:[NSString class]])
    {
        [cell.DataLabel setText:[sectionDict objectForKey:@"time_span"]];
        [cell.DataLabel setCenter:CGPointMake(cell.DataLabel.center.x, firstFloorLabel.center.y)];
    }
    
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(cell.NameLabel.frame.origin.x, firstFloorLabel.frame.origin.y + firstFloorLabel.frame.size.height + 1, 240, 1)];
    [lineLabel setBackgroundColor:[UIColor whiteColor]];
    [cell addSubview:lineLabel];
    [lineLabel release];
    
//    if ([[sectionDict objectForKey:@"add_time"] isKindOfClass:[NSString class]])
//    {
//        [cell.DataLabel setText:[cell dateFromString:[sectionDict objectForKey:@"add_time"]]];
//    }
    
//    if ([[sectionDict objectForKey:@"user_name"] isKindOfClass:[NSString class]])
//    {
//        [cell.NameLabel setText:[sectionDict objectForKey:@"user_name"]];
//    }
    
    
    //photoImageView
    [cell.photoImageView setFrame:CGRectMake(lineLabel.frame.origin.x, lineLabel.frame.origin.y + lineLabel.frame.size.height + 2, 0, 0)];
    [cell.photoImageView setImage:nil];
    if ([[sectionDict objectForKey:@"img_url"] isKindOfClass:[NSString class]])
    {
        if ([[sectionDict objectForKey:@"img_url"] length] > 0)
        {
            NSURL *url = [NSURL URLWithString:[sectionDict objectForKey:@"img_url"]];
            if (url)
            {
                [cell.photoImageView setFrame:CGRectMake(lineLabel.frame.origin.x, lineLabel.frame.origin.y + lineLabel.frame.size.height + 2, 200, 100)];
                [cell.photoImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon"]];
            }
        }
    }
    
    //ContentLabel
    if ([[sectionDict objectForKey:@"content"] isKindOfClass:[NSString class]])
    {
        [cell.ContentLabel setText:[sectionDict objectForKey:@"content"]];
    }
    CGSize contentSize = ZZ_MULTILINE_TEXTSIZE(cell.ContentLabel.text, cell.ContentLabel.font, CGSizeMake(cell.ContentLabel.frame.size.width, 9999), cell.ContentLabel.lineBreakMode);
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        NSDictionary *attribute = @{NSFontAttributeName: cell.ContentLabel.font};
        contentSize = [cell.ContentLabel.text boundingRectWithSize:CGSizeMake(cell.ContentLabel.frame.size.width, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        contentSize.height += 1;
    }
    CGRect contentRect = cell.ContentLabel.frame;
    
    contentRect.origin.y = cell.photoImageView.frame.origin.y + cell.photoImageView.frame.size.height;
    contentRect.size.height = contentSize.height > 30 ? contentSize.height : 30;
    [cell.ContentLabel setFrame:contentRect];
    
    //CityNameLabel
    if ([[sectionDict objectForKey:@"area"] isKindOfClass:[NSString class]])
    {
        [cell.CityNameLabel setText:[sectionDict objectForKey:@"area"]];
    }
    CGRect addressRect = cell.CityNameLabel.frame;
    addressRect.origin.y = cell.ContentLabel.frame.origin.y + cell.ContentLabel.frame.size.height + 1;
    [cell.CityNameLabel setFrame:addressRect];
    
    CGRect lineRect = cell.lineImageView.frame;
    lineRect.origin.y = cell.CityNameLabel.frame.origin.y + cell.CityNameLabel.frame.size.height + 1;
    [cell.lineImageView setFrame:lineRect];
    [cell.lineImageView setHidden:YES];
    
    
    
    [cell setFrame:CGRectMake(0, 0, 320, cell.lineImageView.frame.origin.y + 2)];

    return [[cell retain] autorelease];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0)
//    {
//        NSString *identifier = @"identifier1";
//        JiaoliuDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
//        if (cell==nil)
//        {
//            cell =[[[NSBundle mainBundle]loadNibNamed:@"JiaoliuDetailCell" owner:self options:nil]lastObject];
//            [cell nibInit];
//            [cell.NameLabel setTextColor:[UIColor whiteColor]];
//            [cell.DataLabel setTextColor:[UIColor whiteColor]];
//            [cell.ContentLabel setTextColor:[UIColor whiteColor]];
//            [cell.CityNameLabel setTextColor:[UIColor whiteColor]];
//            [cell setBackgroundColor:[UIColor colorwithHexString:@"#ED82DF"]];
//            
//            [cell.IconImageView setFrame:CGRectMake(10, 10, 73, 73)];
//            [cell.NameLabel setFrame:CGRectMake(76, 10, 100, 18)];
//            [cell.DataLabel setFrame:CGRectMake(180, 15, 50, 14)];
//            [cell.ContentLabel setFrame:CGRectMake(76, 40, 210, 35)];
//            [cell.CityNameLabel setFrame:CGRectMake(76, 76, 210, 14)];
//            
//            UILabel *firstFloorLabel = [[UILabel alloc]initWithFrame:CGRectMake(230, 12, 66, 14)];
//            [cell addSubview:firstFloorLabel];
//            [firstFloorLabel release];
//            [firstFloorLabel setTextColor:[UIColor whiteColor]];
//            [firstFloorLabel setBackgroundColor:[UIColor clearColor]];
//            [firstFloorLabel setTextAlignment:NSTextAlignmentRight];
//            [firstFloorLabel setFont:[UIFont systemFontOfSize:10]];
//            [firstFloorLabel setText:[NSString stringWithFormat:@"楼主：%@", [sectionDict objectForKey:@"user_name"]]];
//            
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//
//        if ([[sectionDict objectForKey:@"avater"] isKindOfClass:[NSString class]])
//        {
//            NSURL *url = [NSURL URLWithString:[sectionDict objectForKey:@"avater"]];
//            if (url)
//            {
//                
//                [cell.IconImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"huiyuan_touxiang_pic_moren"]];
//            }
//        }
//        
//        if ([[sectionDict objectForKey:@"title"] isKindOfClass:[NSString class]])
//        {
//            [cell.NameLabel setText:[sectionDict objectForKey:@"title"]];
//        }
//        
//        if ([[sectionDict objectForKey:@"add_time"] isKindOfClass:[NSString class]])
//        {
//            [cell.DataLabel setText:[cell dateFromString:[sectionDict objectForKey:@"add_time"]]];
//        }
//        
//        if ([[sectionDict objectForKey:@"user_name"] isKindOfClass:[NSString class]])
//        {
//            [cell.NameLabel setText:[sectionDict objectForKey:@"user_name"]];
//        }
//        
//        
//        //photoImageView
//        [cell.photoImageView setFrame:CGRectMake(cell.NameLabel.frame.origin.x, cell.NameLabel.frame.origin.y + cell.NameLabel.frame.size.height, 0, 0)];
//        [cell.photoImageView setImage:nil];
//        
//        //ContentLabel
//        if ([[sectionDict objectForKey:@"content"] isKindOfClass:[NSString class]])
//        {
//            [cell.ContentLabel setText:[sectionDict objectForKey:@"content"]];
//        }
//        CGSize contentSize = ZZ_MULTILINE_TEXTSIZE(cell.ContentLabel.text, cell.ContentLabel.font, CGSizeMake(cell.ContentLabel.frame.size.width, 9999), cell.ContentLabel.lineBreakMode);
//        CGRect contentRect = cell.ContentLabel.frame;
//        
//        contentRect.origin.y = cell.photoImageView.frame.origin.y + cell.photoImageView.frame.size.height;
//        contentRect.size.height = contentSize.height > 30 ? contentSize.height : 30;
//        [cell.ContentLabel setFrame:contentRect];
//        
//        //CityNameLabel
//        if ([[sectionDict objectForKey:@"area"] isKindOfClass:[NSString class]])
//        {
//            [cell.CityNameLabel setText:[sectionDict objectForKey:@"area"]];
//        }
//        CGRect addressRect = cell.CityNameLabel.frame;
//        addressRect.origin.y = cell.ContentLabel.frame.origin.y + cell.ContentLabel.frame.size.height + 1;
//        [cell.CityNameLabel setFrame:addressRect];
//        
//        CGRect lineRect = cell.lineImageView.frame;
//        lineRect.origin.y = cell.CityNameLabel.frame.origin.y + cell.CityNameLabel.frame.size.height + 1;
//        [cell.lineImageView setFrame:lineRect];
//        [cell.lineImageView setHidden:YES];
//
//        
//        return cell;
//    }
//    else
//    {\
    
    
    NSDictionary *dictionary = [self.infoArray objectAtIndex:indexPath.row];
    NSLog(@"begin================");
    NSLog(@"-------dictionary-----%@",dictionary );
    NSLog(@"end==================");

    NSString *idetifer = @"jiaoliu";
    JiaoliuDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:idetifer ];
    if (cell==nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JiaoliuDetailCell" owner:self options:nil]lastObject];
        [cell nibInit];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.ReplyBtn setTag:indexPath.row + 10000];
        [cell.ReplyBtn addTarget:self action:@selector(replyFloor:) forControlEvents:UIControlEventTouchUpInside];
    }

    [cell.floorLabel setText:[NSString stringWithFormat:@"%d楼",indexPath.row + 1]];
    
    [cell setDataDictionary:dictionary];
    
    return cell;
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


    NSDictionary *dictionary = [self.infoArray objectAtIndex:indexPath.row];

    FloorDetailViewController *controller = [[[FloorDetailViewController alloc]init]autorelease];
    controller.Id =  [dictionary objectForKey:@"comment_id"];
    controller.dataDictionary = [self.infoArray objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)replyFloor:(UIButton *)button
{
    isFloor = YES;
//    int tag = button.tag - 10000;

    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        if ([button.superview.superview.superview isKindOfClass:[UITableViewCell class]])
        {
            UITableViewCell *cell = (UITableViewCell *)button.superview.superview.superview;
            NSIndexPath *indexpath = [mTableView indexPathForCell:cell];
            NSLog(@"%d",indexpath.row);
            NSDictionary *dictionary = [self.infoArray objectAtIndex:indexpath.row];
            
            floorId = [dictionary objectForKey:@"comment_id"];
            [textView becomeFirstResponder];
        }

    }
    else
    {
        if ([button.superview.superview isKindOfClass:[UITableViewCell class]])
        {
            UITableViewCell *cell = (UITableViewCell *)button.superview.superview;
            NSIndexPath *indexpath = [mTableView indexPathForCell:cell];
            NSLog(@"%d",indexpath.row);
            NSDictionary *dictionary = [self.infoArray objectAtIndex:indexpath.row];
            
            floorId = [dictionary objectForKey:@"comment_id"];
            [textView becomeFirstResponder];
        }
    }
    
    
    
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
                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
                    imagePicker.delegate = self;
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    imagePicker.allowsEditing = YES;
                    imagePicker.showsCameraControls = YES;
                    imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
                    [self.navigationController presentViewController:imagePicker animated:YES completion:NULL];
                    [imagePicker release];
                }
                    break;
                case 1:
                {
                    //相册
                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
                    imagePicker.delegate = self;
                    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    imagePicker.allowsEditing = YES;
                    imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
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
//    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *image = [self rotateImage:[info objectForKey:UIImagePickerControllerEditedImage]];
    //    UIImage *pickImage = [self scaleImage:image];
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
    photoImage  = [creatImage retain];
//    [replyView setPhotoImage:image];
    [picker dismissViewControllerAnimated:YES completion:^{
        [addPhotoButton setBackgroundImage:photoImage forState:UIControlStateNormal];
    }];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
