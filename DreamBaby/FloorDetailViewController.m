//
//  FloorDetailViewController.m
//  DreamBaby
//
//  Created by easaa on 14-2-17.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "FloorDetailViewController.h"
#import "ATMHud.h"
#import "HTTPRequest.h"
#import "FBEncryptorDES.h"
#import "NSString+URLEncoding.h"
#import "JsonUtil.h"
//#import "ZZReplyView.h"
#import "JiaoliuDetailCell.h"
#import "SVPullToRefresh.h"
#import "UIImageView+WebCache.h"
#import "IsLogIn.h"
#import "JsonFactory.h"
@interface FloorDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    NSInteger pageIndex;
    NSInteger pageSize;
    UIView *bgView;
//     ZZReplyView *replyView;
    ATMHud *hud;
    UITableView *mTableView;
    BOOL isUp;
    float cutHeight;
    int count;
}
@property (nonatomic ,retain) NSMutableArray *infoArray;


@end

@implementation FloorDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        pageIndex = 1;
        pageSize = 10;
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
    
    RELEASE_SAFE(_infoArray);
    RELEASE_SAFE(_dataDictionary);
    
    RELEASE_SAFE(containerView);
    RELEASE_SAFE(textView);
    RELEASE_SAFE(leftImage);
    
    RELEASE_SAFE(addPhotoView);
    RELEASE_SAFE(photoBackgroundImageView);
    RELEASE_SAFE(addPhotoButton);
    RELEASE_SAFE(photoImage);
    
    hud.delegate = nil;
    [hud release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    isUp = NO;


    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    self.navigationItem.title = @"回帖评论";
    
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

    hud = [[ATMHud alloc]initWithDelegate:self];
    [self.view addSubview:hud.view];
    
    
    NSMutableArray *tempArray = [NSMutableArray array];
    self.infoArray = tempArray;
    
    [self getRequest:YES];
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
- (void)setUp
{
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 20 - 44 - 40)];
//    bgView.backgroundColor = [UIColor redColor];
    //bgView.layer.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4f].CGColor;
    bgView.layer.backgroundColor = [UIColor colorwithHexString:@"#e7d4df"].CGColor;
    bgView.layer.cornerRadius = 0;
    [self.view addSubview:bgView];
    
    
    mTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, bgView.bounds.size.height) style:UITableViewStylePlain];
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.backgroundView = nil;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.delegate=self;
    mTableView.dataSource=self;
    [mTableView setTableHeaderView:[self cellForHead]];
    
    [mTableView addInfiniteScrollingWithActionHandler:^{
        [self getRequest:NO];
    }];
    [bgView addSubview:mTableView];
    
    [mTableView release];
    
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
    [self getCommentRequest:content];
}

#pragma mark - request
- (void)getRequest:(BOOL)isFirst
{
    if (isFirst)
    {
        [hud setCaption:@"加载中"];
        [hud setActivity:YES];
        [hud show];

        if (self.infoArray.count)
        {
            pageIndex = 1;
            [self.infoArray removeAllObjects];
        }
        
    }

    dispatch_queue_t network;
    network = dispatch_queue_create("reply_invitation_info", nil);
    dispatch_async(network, ^{
        NSString *request = [HTTPRequest requestForGetWithPramas:[NSDictionary dictionaryWithObjectsAndKeys:self.Id,@"comment_id",[NSString stringWithFormat:@"%d",pageIndex],@"page_index",[NSString stringWithFormat:@"%d",pageSize],@"page_size",
                                                                  nil] method:@"reply_invitation_info"];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dictionary objectForKey:@"msg"]integerValue] == 1) {
                if (isFirst) {
                    [hud hideAfter:1.0f];
                    [self setUp];
                }
                NSLog(@"%@",[dictionary description]);
                
                
                NSString *dataString = [dictionary objectForKey:@"data"];
                dataString = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
                dataString = [dataString URLDecodedString];
                NSArray *result = [JsonUtil jsonToArray:dataString];
                
                [self.infoArray addObjectsFromArray:result];
                
                [mTableView.infiniteScrollingView stopAnimating];
                [mTableView reloadData];
                if (result.count < 10) {
                    mTableView.infiniteScrollingView.enabled = NO;
                }else
                {
                    pageIndex ++;
                }
                
            }else
            {
                [mTableView.infiniteScrollingView stopAnimating];

                if ([dictionary objectForKey:@"msgbox"] != NULL) {
                    if (isFirst) {
                        [hud setCaption:[dictionary objectForKey:@"msgbox"]];
                        [hud setActivity:NO];
                        [hud update];
                        [hud hideAfter:1.0f];
                    }
                    
                }else
                {
                    if (isFirst) {

                    [hud setCaption:@"网络出问题了"];
                    [hud setActivity:NO];
                    [hud update];
                    [hud hideAfter:1.0f];
                    }
                }
            }
        });
    });
}

#pragma mark - comment
- (void)getCommentRequest:(NSString *)content
{
    if (isUp == NO) {
        isUp = YES;
        [hud setCaption:@"评论中"];
        [hud setActivity:YES];
        [hud show];
//    dispatch_queue_t network ;
//    network = dispatch_queue_create("reply_invitation", nil);
//    dispatch_async(network, ^{
//        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.Id,@"comment_id",
//                                    [IsLogIn instance].memberData.idString,@"user_id",
//                                    content,@"content",nil];
//        NSString *request = [HTTPRequest requestForGetWithPramas:dictionary method:@"reply_invitation"];
//        NSDictionary *json = [JsonUtil jsonToDic:request];
        NSString *user_id = [IsLogIn instance].memberData.idString;
        NSLog(@"user = %@",user_id);
        NSDictionary *postDic = [NSDictionary dictionaryWithObjectsAndKeys:user_id,@"user_id",
                                 self.Id,@"comment_id",
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
               
                
                NSString *dataString = [json objectForKey:@"data"];
                dataString = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
                dataString = [dataString URLDecodedString];
                NSDictionary *result = [JsonUtil jsonToDic:dataString];
                [self.infoArray insertObject:result atIndex:0];
                
//                [mTableView beginUpdates];
//                [mTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
//                [mTableView endUpdates];
//                
//
//                [mTableView setTableHeaderView:[self cellForHead]];
                
                [self getRequest:YES];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadComuDetail" object:nil];
                
                photoImage = nil;
                [hud setCaption:@"评论楼层成功"];
                [hud setActivity:NO];
                [hud show];
                [hud hideAfter:1.0f];
            
                isUp = NO;
            }else
            {
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
                isUp = NO;
            }
        });
    });
    }
}

#pragma mark -----TableViewDeklegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        if (self.infoArray) {
            return self.infoArray.count;
        }
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JiaoliuDetailCell * cell = [[[NSBundle mainBundle]loadNibNamed:@"JiaoliuDetailCell" owner:self options:nil]lastObject];
    [cell nibInit];
    NSDictionary *dictionary = [self.infoArray objectAtIndex:indexPath.row];
    [cell setDataDictionary:dictionary];
    return cell.self_height;
    

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
    [cell setBackgroundColor:[UIColor colorwithHexString:@"#ED82DF"]];
    
    [cell.IconImageView setFrame:CGRectMake(5, 5, 66, 66)];
    [cell.NameLabel setFrame:CGRectMake(76, 10, 100, 18)];
    [cell.DataLabel setFrame:CGRectMake(180, 15, 50, 14)];
    [cell.ContentLabel setFrame:CGRectMake(76, 40, 210, 35)];
    [cell.CityNameLabel setFrame:CGRectMake(84, 76, 230, 20)];
    
    UILabel *firstFloorLabel = [[UILabel alloc]initWithFrame:CGRectMake(210, 12, 95, 14)];
    [cell addSubview:firstFloorLabel];
    [firstFloorLabel release];
    [firstFloorLabel setTextColor:[UIColor whiteColor]];
    [firstFloorLabel setBackgroundColor:[UIColor clearColor]];
    [firstFloorLabel setTextAlignment:NSTextAlignmentRight];
    [firstFloorLabel setFont:[UIFont systemFontOfSize:10]];
    [firstFloorLabel setText:[NSString stringWithFormat:@"楼主：%@", [_dataDictionary objectForKey:@"nick_name"]]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    //    NSDictionary *dic = [sectionDict objectForKey:@"list"][0];
    if ([[_dataDictionary objectForKey:@"avater"] isKindOfClass:[NSString class]])
    {
        NSURL *url = [NSURL URLWithString:[_dataDictionary objectForKey:@"avater"]];
        if (url)
        {
            
            [cell.IconImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon"]];
        }
    }
    
    if ([[_dataDictionary objectForKey:@"title"] isKindOfClass:[NSString class]])
    {
        [cell.NameLabel setText:[_dataDictionary objectForKey:@"title"]];
    }
    
    //    if ([[sectionDict objectForKey:@"add_time"] isKindOfClass:[NSString class]])
    //    {
    //        [cell.DataLabel setText:[cell dateFromString:[sectionDict objectForKey:@"add_time"]]];
    //    }
    
    if ([[_dataDictionary objectForKey:@"time_span"] isKindOfClass:[NSString class]])
    {
        [cell.DataLabel setText:[_dataDictionary objectForKey:@"time_span"]];
    }
    
    if ([[_dataDictionary objectForKey:@"nick_name"] isKindOfClass:[NSString class]])
    {
        [cell.NameLabel setText:[_dataDictionary objectForKey:@"nick_name"]];
    }
    
    
    //photoImageView
    [cell.photoImageView setFrame:CGRectMake(cell.NameLabel.frame.origin.x, cell.NameLabel.frame.origin.y + cell.NameLabel.frame.size.height, 0, 0)];
    [cell.photoImageView setImage:nil];
    if ([[_dataDictionary objectForKey:@"img_url"] isKindOfClass:[NSString class]])
    {
        if ([[_dataDictionary objectForKey:@"img_url"] length] > 0)
        {
            NSURL *url = [NSURL URLWithString:[_dataDictionary objectForKey:@"img_url"]];
            if (url)
            {
                [cell.photoImageView setFrame:CGRectMake(cell.NameLabel.frame.origin.x, cell.NameLabel.frame.origin.y + cell.NameLabel.frame.size.height, 80, 80)];
                [cell.photoImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon"]];
            }
        }
    }
    
    //ContentLabel
    if ([[_dataDictionary objectForKey:@"content"] isKindOfClass:[NSString class]])
    {
        [cell.ContentLabel setText:[_dataDictionary objectForKey:@"content"]];
    }

    CGSize contentSize = ZZ_MULTILINE_TEXTSIZE(cell.ContentLabel.text, cell.ContentLabel.font, CGSizeMake(cell.ContentLabel.frame.size.width, 9999), cell.ContentLabel.lineBreakMode);
    CGRect contentRect = cell.ContentLabel.frame;
    
    contentRect.origin.y = cell.photoImageView.frame.origin.y + cell.photoImageView.frame.size.height;
    contentRect.size.height = contentSize.height > 30 ? contentSize.height : 30;
    [cell.ContentLabel setFrame:contentRect];
    
    //CityNameLabel
    if ([[_dataDictionary objectForKey:@"area"] isKindOfClass:[NSString class]])
    {
        [cell.CityNameLabel setText:[_dataDictionary objectForKey:@"area"]];
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
//  
//    NSString * idetifer = @"jiaoliu";
//    JiaoliuDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:idetifer ];
//    if (cell==nil)
//    {
//        cell =[[[NSBundle mainBundle]loadNibNamed:@"JiaoliuDetailCell" owner:self options:nil]lastObject];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    NSDictionary *dictionary = [self.infoArray objectAtIndex:indexPath.row];
//    NSLog(@"begin================");
//    NSLog(@"dictionary-->%@", dictionary);
//    NSLog(@"end==================");
//    if (![[dictionary objectForKey:@"avater"] isEqual:[NSNull null]]) {
//        
//        NSString *img_url = [dictionary objectForKey:@"avater"];
//        
//        if (![img_url hasPrefix:@"http://"]) {
//            img_url = [@"http://" stringByAppendingString:img_url];
//        }
//        [cell.IconImageView setImageWithURL:[NSURL URLWithString:img_url] placeholderImage:[UIImage imageNamed:@"zhuanjia_touxiang"]];
//    }
//    if (![[dictionary objectForKey:@"user_name"] isEqual:[NSNull null]]) {
//        [cell.NameLabel setText:[dictionary objectForKey:@"user_name"]];
//    }
//    if (![[dictionary objectForKey:@"area"] isEqual:[NSNull null]]) {
//        
//        cell.CityNameLabel.text = [dictionary objectForKey:@"area"];
//    }
//    cell.ContentLabel.text = [dictionary objectForKey:@"content"];
//    NSString *time = [dictionary objectForKey:@"add_time"];
//    time = [time stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
//    if ([time hasPrefix:@"-Date"])
//    {
//        time = [time stringByReplacingOccurrencesOfString:@"-" withString:@""];
//        time = [time stringByReplacingOccurrencesOfString:@"Date" withString:@""];
//        time = [time stringByReplacingOccurrencesOfString:@"(" withString:@""];
//        time = [time stringByReplacingOccurrencesOfString:@")" withString:@""];
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time longLongValue]/1000];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//        [formatter  setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//        time = [formatter stringFromDate:date];
//        [formatter release];
//    }
//    cell.DataLabel.text = time;
//    
//    cell.ReplyBtn.hidden = YES;
//    return cell;
//    
//    
//    return nil;
    NSDictionary *dictionary = [self.infoArray objectAtIndex:indexPath.row];
    NSLog(@"begin================");
    NSLog(@"%@", dictionary);
    NSLog(@"end==================");
    
    NSString *idetifer = @"jiaoliu";
    JiaoliuDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:idetifer ];
    if (cell==nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JiaoliuDetailCell" owner:self options:nil]lastObject];
        [cell nibInit];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.ReplyBtn setHidden:YES];
    }
    
    

    
    [cell.floorLabel setText:[NSString stringWithFormat:@"%d楼",indexPath.row + 1]];
    [cell setDataDictionary:dictionary];

    return cell;

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
    photoImage = [creatImage retain];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
