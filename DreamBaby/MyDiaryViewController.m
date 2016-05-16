//
//  MyDiaryViewController.m
//  DreamBaby
//
//  Created by easaa on 14-1-6.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "MyDiaryViewController.h"
#import "DiaryCell.h"
#import "DiaryDetailViewController.h"
#import "AppDelegate.h"
#import "tipAlertView.h"
#import "FeedbackViewController.h"
#import "SubmitAudioViewController.h"

#import "IsLogIn.h"
#import "HTTPRequest.h"
#import "JsonUtil.h"

#import "SVPullToRefresh.h"


#import "FBEncryptorDES.h"
#import "NSString+URLEncoding.h"

#import "ATMHud.h"
#import "ATMHudDelegate.h"


#import <AVFoundation/AVAudioPlayer.h>


#import "JsonFactory.h"
#import "FBEncryptorDES.h"

#import "MyDiaryCell.h"

#import "UIImageView+WebCache.h"
#import "IsLogIn.h"

#import "EADiaryCell.h"
#import "EAWriteTodayViewController.h"
#import "EADiaryDetailViewController.h"
@interface MyDiaryViewController ()<UIActionSheetDelegate,SWTableViewCellDelegate,SubmitAudioViewControllerDelegate,FeedbackViewControllerDelegate,UIGestureRecognizerDelegate>
{
    NSInteger pageIndex;
    ATMHud * hud;
    AVAudioPlayer*  player;
    IsLogIn *login;
}

@property (nonatomic ,retain) NSMutableArray *dataArray;
@end

@implementation MyDiaryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        pageIndex = 1;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:@"refreshMyDiary" object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"diary_bg"]];
    if (self.view.bounds.size.height > 480)
    {
         self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"diary_bg-568h"]];
    }
    
    self.navigationItem.title = @"我的日记";
    
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
    
//    UIView * mainContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 55, 320, [UIScreen mainScreen].bounds.size.height - 20 - 44- - 49 - 55)];
//    mainContentView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:mainContentView];
//    [mainContentView release];
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    bgView.backgroundColor = [UIColor clearColor];
    
    login = [IsLogIn instance];
    //名字
    
    UILabel* nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 30, 100, 30)];
    nameLabel.text= login.memberData.nick_name;
    nameLabel.font = [UIFont boldSystemFontOfSize:14];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor colorwithHexString:@"#DD2E94"];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:nameLabel];
    [nameLabel release];
    
//    //签名
//    UILabel* signLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 230, 15)];
//    signLabel.text= login.memberData.signature;
//    signLabel.font = [UIFont boldSystemFontOfSize:12];
//    signLabel.backgroundColor = [UIColor clearColor];
//    signLabel.textColor = [UIColor colorwithHexString:@"#a9a9a9"];
//    signLabel.textAlignment = NSTextAlignmentRight;
//    [bgView addSubview:signLabel];
//    [signLabel release];
    
    
    //头像
//    UIImageView * headIM = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"riji_touxiang"]];
//    headIM.frame = CGRectMake(235, 10, 70, 70);
//    headIM.userInteractionEnabled = YES;
//    [self.view addSubview:headIM];
//    [headIM release];
    
  
    UIImageView * imag = [[UIImageView alloc]init];
    imag.frame = CGRectMake(0, 20, 70, 70);
    imag.userInteractionEnabled = YES;
    if ([login.memberData.avatar isEqualToString:@"http://183.61.84.207:1234"])
    {
        [imag setImage:[UIImage imageNamed:@"icon"]];
    }
    else
    {
        [imag setImageWithURL:[NSURL URLWithString:login.memberData.avatar] placeholderImage:[UIImage imageNamed:@"icon"]];
    }
    
    [bgView addSubview:imag];
    [imag release];
    
    
    
//    contentScrollerView = [[UIScrollView alloc]initWithFrame:mainContentView.bounds];
//    //scrollerView.bounds = CGRectMake(0, 0, 260, 400);
//    contentScrollerView.contentSize= CGSizeMake(320, self.view.frame.size.height+45);
//    contentScrollerView.backgroundColor = [UIColor colorwithHexString:@"#f1e5ec"];
//    contentScrollerView.pagingEnabled = NO;
//    contentScrollerView.bounces = YES;
//    [mainContentView addSubview:contentScrollerView];
//    [contentScrollerView release];
    
    
    //写下今天
    
    UIButton * writeTodayBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    writeTodayBtn.frame=CGRectMake(80, 65, 81, 26);
    [writeTodayBtn setTitle:@"写下今天" forState:UIControlStateNormal];
    writeTodayBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [writeTodayBtn setBackgroundImage:[UIImage imageNamed:@"riji_xx"] forState:UIControlStateNormal];
    [writeTodayBtn addTarget:self action:@selector(writeToday:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:writeTodayBtn];

    //
    NSMutableArray *tempArray = [NSMutableArray array];
    self.dataArray = tempArray;
    
    diaryTableView=[[UITableView alloc] initWithFrame:CGRectMake(30, 0, 270, [UIScreen mainScreen].bounds.size.height - 20 - 44- 49  ) style:UITableViewStylePlain];
    diaryTableView.backgroundColor = [UIColor clearColor];
    diaryTableView.backgroundView = nil;

    diaryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    diaryTableView.delegate=self;
    diaryTableView.dataSource=self;
    diaryTableView.tableHeaderView = bgView;
    diaryTableView.showsVerticalScrollIndicator = NO;
    [self.view insertSubview:diaryTableView atIndex:0];
    
    [bgView release];
    [diaryTableView release];
    
    
    hud = [[ATMHud alloc]initWithDelegate:self];
    [self.view addSubview:hud.view];
    
    [diaryTableView addInfiniteScrollingWithActionHandler:^{
        [self continueRequet];
    }];
    [diaryTableView addPullToRefreshWithActionHandler:^{
        [self getrequest];
    }];;
   
    //
    
    /**
     *  第一次请求
     */
    [self getrequest];
}

- (void)reloadTableView:(id)sender
{
    [self.dataArray removeAllObjects];
    dispatch_queue_t network_queue;
    network_queue = dispatch_queue_create("request.getDiary", nil);
    dispatch_async(network_queue, ^{
        NSString *Id = [IsLogIn instance].memberData.idString;
        NSString *request = [HTTPRequest requestForGetWithPramas:[NSDictionary dictionaryWithObjectsAndKeys:Id,@"user_id",@"10",@"page_size",[NSNumber numberWithInt:1],@"page_index", nil] method:@"get_note_list"];
        NSDictionary *dict = [JsonUtil jsonToDic:request];
        if ([[dict objectForKey:@"msg"]integerValue] == 1)
        {
            NSString *data = [dict objectForKey:@"data"];
            data = [FBEncryptorDES decrypt:data keyString:@"SDFL#)@F"];
            data = [data URLDecodedString];
            NSArray *dictionary = [JsonUtil jsonToArray:data];
            
            //            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:dictionary];
            dispatch_async(dispatch_get_main_queue(), ^{
                [diaryTableView reloadData];
            });
        }
    });
}
- (void)getrequest
{
    
    [hud setCaption:@"加载中"];
    [hud setActivity:YES];
    [hud show];
    
    pageIndex = 1;
    dispatch_queue_t network_queue;
    network_queue = dispatch_queue_create("request.getDiary", nil);
    dispatch_async(network_queue, ^{
        NSString *Id = [IsLogIn instance].memberData.idString;
        NSString *request = [HTTPRequest requestForGetWithPramas:[NSDictionary dictionaryWithObjectsAndKeys:Id,@"user_id",@"10",@"page_size",[NSString stringWithFormat:@"%d", pageIndex],@"page_index", nil] method:@"get_note_list"];
        NSDictionary *dict = [JsonUtil jsonToDic:request];
        if ([[dict objectForKey:@"msg"]integerValue] == 1)
        {
            dispatch_async(dispatch_get_main_queue(), ^{

                [hud hide];
                NSString *data = [dict objectForKey:@"data"];
                data = [FBEncryptorDES decrypt:data keyString:@"SDFL#)@F"];
                data = [data URLDecodedString];
                NSArray *dictionary = [JsonUtil jsonToArray:data];
                
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:dictionary];

                if (self.dataArray.count == 0) {
                    
//                    [hud setCaption:@"暂无日记,赶紧记录今天吧"];
//                    [hud setActivity:NO];
//                    [hud update];
//                    [hud hideAfter:1.0];
                }else
                {
                    if (self.dataArray.count < 10)
                    {
                        diaryTableView.infiniteScrollingView.enabled = NO;
                        diaryTableView.scrollIndicatorInsets = UIEdgeInsetsZero;
                    }else
                    {
                        pageIndex ++;
                        diaryTableView.infiniteScrollingView.enabled = YES;

                    }
                    
                    [hud hideAfter:1.0];
                    [diaryTableView reloadData];
                }
                [diaryTableView.pullToRefreshView stopAnimating];

            });
        }else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [diaryTableView reloadData];

            if ([dict objectForKey:@"msgbox"]) {
//                [hud setCaption:[dict objectForKey:@"msgbox"]];
//                [hud setActivity:NO];
//                [hud update];
                [hud hideAfter:1.0];
            }else
            {
                [hud setCaption:@"网络出问题了"];
                [hud setActivity:NO];
                [hud update];
                [hud hideAfter:1.0];
            }
                [diaryTableView.pullToRefreshView stopAnimating];
  
            });
            
        }
    });
    
}


- (void)continueRequet
{
    dispatch_queue_t network_queue;
    network_queue = dispatch_queue_create("continue.request.getDiary", nil);
    dispatch_async(network_queue, ^{
        NSString *Id = [IsLogIn instance].memberData.idString;
        NSString *request = [HTTPRequest requestForGetWithPramas:[NSDictionary dictionaryWithObjectsAndKeys:Id,@"user_id",@"10",@"page_size",[NSString stringWithFormat:@"%ld",(long)pageIndex],@"page_index", nil] method:@"get_note_list"];
        NSDictionary *dict = [JsonUtil jsonToDic:request];
        if ([[dict objectForKey:@"msg"]integerValue] == 1)
        {
            NSString *data = [dict objectForKey:@"data"];
            data = [FBEncryptorDES decrypt:data keyString:@"SDFL#)@F"];
            data = [data URLDecodedString];
            NSArray *dictionary = [JsonUtil jsonToArray:data];
            [self.dataArray addObjectsFromArray:dictionary];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [diaryTableView.infiniteScrollingView stopAnimating];
                if (dictionary.count < 10)
                {
                    diaryTableView.infiniteScrollingView.enabled = NO;
                    diaryTableView.scrollIndicatorInsets = UIEdgeInsetsZero;
                }else
                {
                    pageIndex ++;
                }
                [diaryTableView reloadData];
            });
        }else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [diaryTableView.infiniteScrollingView stopAnimating];
            });
        }
    });
}

- (void)imageTap:(UITapGestureRecognizer *)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"从相册选取", nil];
//    [sheet showInView:self.view];
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
    [sheet release];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //相机
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        imagePicker.showsCameraControls = YES;
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
        [self.navigationController presentViewController:imagePicker animated:YES completion:NULL];
        [imagePicker release];
    }else if (buttonIndex == 1)
    {
        //相册
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = YES;
        [self.navigationController presentViewController:imagePicker animated:YES completion:NULL];
        [imagePicker release];
    }else if (buttonIndex == 2)
    {
        
    }
}

//通过系统相册获取图片的方法
- (void)chooseImage
{
    [tipVC removeFromSuperview];
    [self imageTap:nil];
}


//如果在相册里选择了某张照片，就显示在_imageView里面
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker  dismissViewControllerAnimated:YES completion:nil];
    UIImage * pickImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *image = [self scaleImage:pickImage];
    [self uploadImage:image];
}
//如果神马都没选，点击相册的Cancel按键就直接返回
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker  dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)scaleImage:(UIImage *)image
{
    UIGraphicsBeginImageContext(CGSizeMake(100,100));
    [image drawInRect:CGRectMake(0, 0, 100,100)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (void)uploadImage:(UIImage *)image
{
    dispatch_queue_t network_queue;
    network_queue = dispatch_queue_create("upLoadImage", nil);
    dispatch_async(network_queue, ^{
        
        NSData *data = UIImageJPEGRepresentation(image , 0.1);
        NSString *tem = [data base64Encoding];
        tem = [NSString stringWithFormat:@"imgs=%@",tem];
        tem =[tem stringByReplacingOccurrencesOfString:@"+" withString:@"|JH|"];
        tem=[tem stringByReplacingOccurrencesOfString:@" " withString:@"|KG|"];
        NSString *lTmp = [NSString stringWithFormat:@"%c",'\n'];
        NSString *lTmp2 = [NSString stringWithFormat:@"%c",'\r'];
        tem= [tem stringByReplacingOccurrencesOfString:lTmp withString:@"|HC|"];
        tem= [tem stringByReplacingOccurrencesOfString:lTmp2 withString:@"|HC|"];
        
        NSDictionary *postDic = [NSDictionary dictionaryWithObjectsAndKeys:[IsLogIn instance].memberData.idString,@"user_id",@"2",@"type", nil];
        NSString *paramsJson = [JsonFactory dictoryToJsonStr:postDic];
        
        //    NSLog(@"requestParamstr %@",paramsJson);
        //加密
        paramsJson = [[FBEncryptorDES encrypt:paramsJson
                                    keyString:@"SDFL#)@F"] uppercaseString];
        NSString *signs= [NSString stringWithFormat:@"SDFL#)@FMethod%@Params%@SDFL#)@F",@"add_note",paramsJson];
        signs = [[FBEncryptorDES md5:signs] uppercaseString];
      
        NSString *urlStr = [NSString stringWithFormat:BABYAPI,@"add_note",paramsJson,signs];
        NSString *request = [HTTPRequest requestForPost:urlStr :tem];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 显示图片到界面
            if ([[dictionary objectForKey:@"msg"]floatValue] == 1) {
                NSString *dataString = [dictionary objectForKey:@"data"];
                NSLog(@"dataString :%@",dataString);
                dataString = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
                dataString = [dataString URLDecodedString];
                NSDictionary *dict = [JsonUtil jsonToDic:dataString];
                [self.dataArray insertObject:dict atIndex:0];
                
                
                [diaryTableView beginUpdates];
                
                [diaryTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
                [diaryTableView endUpdates];
                
                
            }else
            {
                if ([dictionary objectForKey:@"msgbox"]) {
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
    } );
    
}

-(void)loadBigImage:(UITapGestureRecognizer *)tap
{
    
    UIGraphicsBeginImageContext(self.view.bounds.size);
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    UIView *view = tap.view;
    NSInteger tag = view.tag - 10086;
    NSDictionary *dictionary = [self.dataArray objectAtIndex:tag];
    NSString *url = [dictionary objectForKey:@"img_url"];

    UIApplication * app = [UIApplication  sharedApplication];
    AppDelegate * appDegate = (AppDelegate *)app.delegate;
    
    UIView *bigBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIColor *backColor = [UIColor blackColor];
    backColor = [backColor colorWithAlphaComponent:0.6];
    bigBackView.backgroundColor = backColor;
    [appDegate.window addSubview:bigBackView];
    [UIView animateWithDuration:.3 animations:^{
        
        
        
        
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            bigBackView.frame = CGRectMake(0, 0, 320, 568);
        }else{
            if (self.view.frame.size.height==548) {
                bigBackView.frame = CGRectMake(0, 0, 320, 568);
            }else{
                bigBackView.frame = CGRectMake(0, 0, 320, 480);
            }
            
        }
#endif
    } completion:^(BOOL finished) {
        UIScrollView *picScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        //        picScrollView.backgroundColor=[UIColor clearColor];
        [bigBackView addSubview:picScrollView];
        for (int i=0; i<1; i++) {
           // NSString* urlStr = [senderEntity.Photos objectAtIndex:i];
           // NSLog(@"---%@",urlStr);
            UIImageView* imageview = [[UIImageView alloc] init];
            imageview.frame=CGRectMake(i*320, 120, 320, 240);
            //            imageview.center = CGPointMake(160+320*i, 240);
            //            imageview.tag = 222;
            //[imageview setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"picx_loading"]];
//            imageview.image = [UIImage imageNamed:@"riji_touxiang_pic"];
            //            [bigBackView addSubview:imageview];
            [imageview setImageWithURL:[NSURL URLWithString:url] placeholderImage:image];
            [picScrollView addSubview:imageview];
            [imageview release];
        }
//        UIImageView *currentImageView=[[UIImageView alloc] init];
//        //[currentImageView setImageWithURL:[NSURL URLWithString:[senderEntity.Photos objectAtIndex:tag]] placeholderImage:[UIImage imageNamed:@"picx_loading"]];
//        currentImageView.image =[UIImage imageNamed:@"riji_touxiang_pic"];
        //photoImage=currentImageView.image;
        picScrollView.contentSize=CGSizeMake(320*1, 480);
        picScrollView.showsHorizontalScrollIndicator=NO;
        picScrollView.pagingEnabled=YES;
//        picScrollView.contentOffset=CGPointMake(320*tag, 0);
        picScrollView.delegate=self;
        [picScrollView release];
        
        UITapGestureRecognizer *singleOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBigImage:)];
        singleOne.numberOfTouchesRequired = 1;    //触摸点个数，另作：[singleOne setNumberOfTouchesRequired:1];
        singleOne.numberOfTapsRequired = 1;    //点击次数，另作：[singleOne setNumberOfTapsRequired:1];
        singleOne.delegate=self;
        [bigBackView addGestureRecognizer:singleOne];
        [singleOne release];
    }];
    
    [bigBackView release];
}



-(void)removeBigImage:(id)sender
{
    UIView *senderView = ((UITapGestureRecognizer*)sender).view;
    [UIView animateWithDuration:.3 animations:^{
        senderView.alpha = 0;
    } completion:^(BOOL finished) {
        [senderView removeFromSuperview];
    }];
}


- (void)writeToday:(UIButton *)sender
{
//    UIApplication * app = [UIApplication sharedApplication];
//    AppDelegate * appDelegate = (AppDelegate *)app.delegate;
//    
//    tipVC = [[[NSBundle mainBundle]loadNibNamed:@"tipAlertView" owner:self options:nil]lastObject];
//    tipVC.hidden = NO;
//    
////    [tipVC.submitBtn addTarget:self action:@selector(goToWrite:) forControlEvents:UIControlEventTouchUpInside];
////    [tipVC.submitPhotoBtn addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
//    [tipVC.submitPhotoBtn addTarget:self action:@selector(goToWrite:) forControlEvents:UIControlEventTouchUpInside];
//    [tipVC.submitAudioBtn addTarget:self action:@selector(submitAudio) forControlEvents:UIControlEventTouchUpInside];
//    
//    tipVC.center = CGPointMake(160, appDelegate.window.center.y+568);
//    [appDelegate.window addSubview:tipVC];
//    
//    [UIView beginAnimations:Nil context:nil];
//    [UIView setAnimationDuration:0.5];
//    if ([UIScreen mainScreen].bounds.size.height==568) {
//        tipVC.center =appDelegate.window.center;
//    }else{
//        tipVC.center =CGPointMake(160, appDelegate.window.center.y+35);
//    }
//    
//    [UIView commitAnimations];
    
    EAWriteTodayViewController *writeToday = [[[EAWriteTodayViewController alloc]initWithNibName:@"EAWriteTodayViewController" bundle:Nil]autorelease];
    [self.navigationController pushViewController:writeToday animated:YES];
    
}
- (void)goToWrite:(UIButton *)sender
{
    [tipVC removeFromSuperview];
    FeedbackViewController  * feedBackVC = [[FeedbackViewController alloc]init];
    feedBackVC.delegate = self;
    [self.navigationController pushViewController:feedBackVC animated:YES];
    [feedBackVC release];
}
- (void)submitAudio
{
    [tipVC removeFromSuperview];
    SubmitAudioViewController * subVC = [[SubmitAudioViewController  alloc]init];
    subVC.delegate = self;
    [self.navigationController pushViewController:subVC animated:YES];
    [subVC release];
}

#pragma mark -----TableViewDeklegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataArray) {
        return 1 ;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray) {
        return self.dataArray.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    float x = 0.00;
//    NSDictionary *dictionary = [self.dataArray objectAtIndex:indexPath.row];
//    NSString *address = [dictionary objectForKey:@"address"];
//    NSString *imgUrl = [dictionary objectForKey:@"img_url"];
//    switch ([address integerValue]) {
//        case 1:
//        {
//            if (imgUrl.length > 0) {
//            x = 65 + 100;
//            }else{
//            x= 65.0f;
//            }
//          
//        }
//            break;
//        case 2:
//        {
//            x=80;
//        }
//            break;
//        case 3:
//        {
//            x= 65;
//        }
//            break;
//        default:
//            break;
//    }
//    
//    return x;
    return 77;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictionary = [self.dataArray objectAtIndex:indexPath.row];
    
    
    NSLog(@"begin================");
    NSLog(@"%@", dictionary);
    NSLog(@"end==================");
    
//    NSLog(@"dic = %@", dictionary);
//    NSString *imgUrl = [dictionary objectForKey:@"img_url"];
    NSString *address = [dictionary objectForKey:@"address"];
//    NSRange range = [imgUrl rangeOfString:@"jpeg"];
//    static NSString *identifier;
//    if (imgUrl.length > 0 && range.length > 0) {
//        identifier = @"imageCell";
//    }else
//    {
//     identifier = @"normalCell";
//    }
//    tableView.separatorColor = [UIColor colorwithHexString:@"#d470a8"];
    
    EADiaryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"diaryCell"];
    
    if (cell == nil)
    {
        cell = [[NSBundle mainBundle]loadNibNamed:@"EADiaryCell" owner:self options:Nil][0];
    }
    
    cell.titleLabel.text = [dictionary objectForKey:@"title"];
    cell.timeLabel.text = [dictionary objectForKey:@"add_time"];
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([address isEqualToString:@"3"])
    {
        [cell.headerPic setImage:[UIImage imageNamed:@"riji_pic03"]];
    }
    else
    {
        
        if (![[dictionary objectForKey:@"img_url"] isEqualToString:@"http://183.61.84.207:1234"])
        {
            [cell.headerPic setImageWithURL:[NSURL URLWithString:[dictionary objectForKey:@"img_url"]] placeholderImage:[UIImage imageNamed:@"icon"]];
        }
        else
        {
            if ([login.memberData.avatar isEqualToString:@"http://183.61.84.207:1234"])
            {
                [cell.headerPic setImage:[UIImage imageNamed:@"icon"]];
            }
            else
            {
                [cell.headerPic setImageWithURL:[NSURL URLWithString:login.memberData.avatar] placeholderImage:[UIImage imageNamed:@"icon"]];
            }

        }
    }
    
    
    return cell;
    
//    if (!cell) {
//        if (imgUrl.length > 0) {
//            NSMutableArray *rightUtilityButtons = [NSMutableArray new];
//            [rightUtilityButtons sw_addUtilityButtonWithColor:
//             [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
//                                                        title:@"Delete"];
//            cell = [[[MyDiaryCell alloc]initWithStyle:UITableViewCellStyleDefault
//                                      reuseIdentifier:identifier
//                                  containingTableView:diaryTableView
//                                   leftUtilityButtons:Nil
//                                  rightUtilityButtons:rightUtilityButtons]autorelease];
//            [rightUtilityButtons release];
//            cell.delegate = self;
//            [cell setBackgroundColor:[UIColor colorwithHexString:@"#f1e5ec"]];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.photoImage.hidden = NO;
//        }else{
//        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
//        [rightUtilityButtons sw_addUtilityButtonWithColor:
//         [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
//                                                    title:@"Delete"];
//        cell = [[[MyDiaryCell alloc]initWithStyle:UITableViewCellStyleDefault
//                                  reuseIdentifier:identifier
//                              containingTableView:diaryTableView
//                               leftUtilityButtons:Nil
//                              rightUtilityButtons:rightUtilityButtons]autorelease];
//        [rightUtilityButtons release];
//        cell.photoImage.hidden = YES;
//        cell.delegate = self;
//        [cell setBackgroundColor:[UIColor colorwithHexString:@"#f1e5ec"]];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//    }
//    
//    
//    NSString *add_time = [dictionary objectForKey:@"add_time"];
//    NSDate *date = [self dateFromString:add_time];
//    NSString *month = [self monthFromDate:date];
//    NSString *day = [self dayFromDate:date];
//    
//    switch ([address integerValue]) {
//        case 1:
//        {
//            if (imgUrl.length > 0 && range.length > 0) {
//            [cell setCellHeight:65 + 100];
//            cell.daySTR = day;
//            cell.month = month;
//            NSString *content = [dictionary objectForKey:@"content"];
//            cell.diaContent = [content URLDecodedString];
//            NSLog(@"diacontent = %@\n content = %@",[content URLDecodedString],content);
//            cell.contentLabel.hidden = NO;
//            cell.musicLabel.hidden = YES;
//            cell.musicImageView.hidden = YES;
//            cell.contentImageView.hidden = YES;
//                               
//            [cell.photoImage setImageWithURL:[NSURL URLWithString:imgUrl]];
//                
//            }
//            else
//            {
//                [cell setCellHeight:65];
//                cell.daySTR = day;
//                cell.month = month;
//                NSString *content = [dictionary objectForKey:@"content"];
//                cell.diaContent = [content URLDecodedString];
//                NSLog(@"diacontent = %@\n content = %@",[content URLDecodedString],content);
//                cell.contentLabel.hidden = NO;
//                cell.musicLabel.hidden = YES;
//                cell.musicImageView.hidden = YES;
//                cell.contentImageView.hidden = YES;
//                cell.photoImage.hidden = YES;
//            }
//        }
//            break;
//        case 2:
//        {
//            [cell setCellHeight:80];
//
//            cell.daySTR = day;
//            cell.month = month;
//            NSString *url = [dictionary objectForKey:@"img_url"];
//            if (![url hasPrefix:@"http://"])
//            {
//                url = [@"http://" stringByAppendingString:url];
//            }
//            [cell.contentImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"huiyuan_touxiang_pic_moren"]];
//            cell.contentLabel.hidden = YES;
//            cell.musicLabel.hidden = YES;
//            cell.musicImageView.hidden = YES;
//            cell.contentImageView.hidden = NO;
//            cell.contentImageView.tag = indexPath.row + 10086;
//            cell.photoImage.hidden = YES;
//            if ([cell.contentImageView gestureRecognizers].count == 0) {
//                cell.contentImageView.userInteractionEnabled  = YES;
//                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadBigImage:)];
//                [cell.contentImageView addGestureRecognizer:tap];
//                [tap release];
//            }
//            [cell.bgView bringSubviewToFront:cell.contentImageView];
//        }
//            break;
//        case 3:
//        {
//            [cell setCellHeight:65];
//            
//            cell.daySTR = day;
//            cell.month = month;
//            NSString *url = [dictionary objectForKey:@"img_url"];
//            cell.music = url;
//            cell.photoImage.hidden = YES;
//            cell.contentLabel.hidden = YES;
//            cell.musicLabel.hidden = NO ;
//            cell.musicImageView.hidden = NO;
//            cell.contentImageView.hidden = YES;
//        }
//            break;
//        default:
//            break;
//    }

    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO]; 
    NSDictionary *dictionary = [self.dataArray objectAtIndex:indexPath.row];
    NSString *address = [dictionary objectForKey:@"address"];
    switch ([address integerValue]) {
        case 1:
        {
//            DiaryDetailViewController * diaryDVC = [[DiaryDetailViewController alloc]init];
//            diaryDVC.dictionary = dictionary;
//            [self.navigationController pushViewController:diaryDVC animated:YES];
//            [diaryDVC release];
            EADiaryDetailViewController * diaryDVC = [[EADiaryDetailViewController alloc]init];
            diaryDVC.dictionary = dictionary;
            [self.navigationController pushViewController:diaryDVC animated:YES];
            [diaryDVC release];
        }
            break;
        case 2:
        {
        }
            break;
        case 3:
        {

            NSString *urlStr = [dictionary objectForKey:@"img_url"];
            NSLog(@"urlstr = %@  ---",urlStr);
            NSURL *url = [[NSURL alloc]initWithString:urlStr];
           // NSData * audioData = [NSData dataWithContentsOfURL:url];
//            
//            NSError *error;
//            if (player != nil) {
//                [player stop];
//                [player release];
//                player = nil;
//            }
//            player = [[AVAudioPlayer alloc]initWithData:audioData error:&error];
//            [player play];
//            
//            NSURL *url = [NSURL URLWithString:[[listArray objectAtIndex:row] objectForKey:@"music_url"]];
            
            
            //视频URL
            //视频播放对象
            MPMoviePlayerViewController *moviePlayer = [ [ MPMoviePlayerViewController alloc]initWithContentURL:url];
            [self.navigationController presentMoviePlayerViewControllerAnimated:moviePlayer];
            //lux
            [moviePlayer release];
            [url release];
        }
            break;
        default:
            break;
    }
    
    
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            NSIndexPath *cellIndexPath = [diaryTableView indexPathForCell:cell];
            dispatch_queue_t network ;
            network = dispatch_queue_create("delete_note", nil);
            dispatch_async(network, ^{
                NSString *Id = [[self.dataArray objectAtIndex:cellIndexPath.row]valueForKey:@"id"];
                
                NSString *request = [HTTPRequest requestForGetWithPramas:[NSDictionary dictionaryWithObjectsAndKeys:Id,@"id", nil] method:@"delete_note"];
                NSDictionary *dictionary = [JsonUtil jsonToDic:request];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([[dictionary objectForKey:@"msg"]intValue] == 1) {
                        [diaryTableView beginUpdates];
                        [self.dataArray removeObjectAtIndex:cellIndexPath.section];
                        //[diaryTableView deleteSections:[NSIndexSet indexSetWithIndex:cellIndexPath.section] withRowAnimation:YES];
                        [diaryTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:cellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                        [diaryTableView endUpdates];
                        
                    }else
                    {
                        if ([dictionary objectForKey:@"msgbox"] != NULL) {
                            [hud setCaption:[dictionary objectForKey:@"msgbox"]];
                            [hud setActivity:NO];
                            [hud show];
                            [hud hideAfter:1.0f];
                        }else{
                            [hud setCaption:@"网络出问题了"];
                            [hud setActivity:NO];
                            [hud show];
                            [hud hideAfter:1.0f];
                        }
                        double delayInSeconds = 1.0;
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            [diaryTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:cellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                        });
                    }
                    
                });
            });
        }break;
         
        default:
            break;
    }
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


#pragma mark - SubmitAudioViewController delegate
- (void)SubmitAudioViewController:(SubmitAudioViewController *)controller didFinishUpload:(NSDictionary *)dictionary
{
    [self.dataArray insertObject:dictionary atIndex:0];
//      [self getrequest];
    
    [diaryTableView beginUpdates];
//
    [diaryTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    [diaryTableView endUpdates];

}

#pragma mark -
- (void)FeedbackViewController:(FeedbackViewController *)controller didFinishUpload:(NSDictionary *)dictionary
{
    [self.dataArray insertObject:dictionary atIndex:0];
 
    
    [diaryTableView beginUpdates];
    
    [diaryTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    [diaryTableView endUpdates];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (player != nil) {
        [player stop];
    }
    [super viewWillDisappear:animated];
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIControl class]]) {
        return NO;
    }
    return YES;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    if (player != nil) {
        [player stop];
        [player release];
        player = nil;
    }
     hud.delegate = nil;
    [hud release];
    [super dealloc];
}
@end
