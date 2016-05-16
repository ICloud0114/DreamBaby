//
//  HosipitalDetailViewController.m
//  DreamBaby
//
//  Created by easaa on 14-1-8.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "HosipitalDetailViewController.h"
#import "HTTPRequest.h"
#import "ATMHud.h"
#import "JsonUtil.h"
#import "NSString+URLEncoding.h"
#import "FBEncryptorDES.h"
#import "UIImageView+WebCache.h"
#import "NSString+HTML.h"

@interface HosipitalDetailViewController ()
{
    ATMHud *hud;
}
@end

@implementation HosipitalDetailViewController
@synthesize bgView;

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
    RELEASE_SAFE(bgView);
     hud.delegate = nil;
    [hud release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    
    titleLabel = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)] autorelease];
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
    
    contentScrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-55)];
    //scrollerView.bounds = CGRectMake(0, 0, 260, 400);
    contentScrollerView.contentSize= CGSizeMake(320, self.view.frame.size.height+45);
    contentScrollerView.contentInset = UIEdgeInsetsMake(20, 0, 20, 0);
    contentScrollerView.backgroundColor = [UIColor clearColor];
    contentScrollerView.pagingEnabled = NO;
    contentScrollerView.bounces = YES;
    [self.view addSubview:contentScrollerView];
    [contentScrollerView release];
    
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 300, self.view.frame.size.height)];
    //bgView.layer.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4f].CGColor;
    bgView.layer.backgroundColor = [UIColor colorwithHexString:@"#FFD9EC"].CGColor;
//    bgView.layer.cornerRadius = 3;
    [contentScrollerView addSubview:bgView];
    
    
    
    
    
    hud = [[ATMHud alloc]initWithDelegate:self];
    [self.view addSubview:hud.view];
    
    
    [self getRequest];
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
                
                NSLog(@"dictionary :%@",[dictionary description]);
                
                [hud hideAfter:1.0f];
                
                [self setUp:dictionary];
            }else
            {
                if ([dictionary objectForKey:@"msgbox"] != NULL) {
                    [hud setCaption:[dictionary objectForKey:@"msgbox"]];
                    [hud setActivity:NO];
                    [hud update];
                    
                }else
                {
                    [hud setCaption:@"网络出问题了"];
                    [hud setActivity:NO];
                    [hud update];
                }
                [hud hideAfter:1.0f];
                
            }
        });
        
        dispatch_release(network);
    });
}


- (void)setUp:(NSDictionary *)dictionary
{
    
    UIImageView *titleImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"huiyuan_kuang01"]];
    [titleImage setFrame:CGRectMake(0, 0, 300, 80)];
    [bgView addSubview:titleImage];
    [titleImage release];
    
    NSLog(@"dictionary :%@",[dictionary description]);
    UIImageView * iconImage =[[UIImageView alloc]init];
    NSString *img_url = [dictionary objectForKey:@"img_url"];
    if (![img_url hasPrefix:@"http://"]) {
        img_url = [@"http://" stringByAppendingString:img_url];
    }
    [iconImage setImageWithURL:[NSURL URLWithString:img_url] placeholderImage:[UIImage imageNamed:@"icon"]];
    
    iconImage.frame = CGRectMake(5, 16, 65, 48);
    [bgView addSubview:iconImage];
    [iconImage release];
    
    //姓名
    if ([dictionary objectForKey:@"title"] != [NSNull null])
    {
    NSLog(@"title = %@",[dictionary objectForKey:@"title"]);
    titleLabel.text = [dictionary objectForKey:@"title"];
    self.title = [dictionary objectForKey:@"title"];
    
    UILabel* nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 220, 15)];
    nameLabel.text= [dictionary objectForKey:@"title"];
    nameLabel.font = [UIFont boldSystemFontOfSize:14];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor colorwithHexString:@"#FFFFFF"];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:nameLabel];
    [nameLabel release];
    }
    //职务
    UILabel* ziwuLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 30, 220, 15)];
    ziwuLabel.text= [dictionary objectForKey:@"address"];
    ziwuLabel.font = [UIFont boldSystemFontOfSize:12];
    ziwuLabel.backgroundColor = [UIColor clearColor];
    ziwuLabel.textColor = [UIColor colorwithHexString:@"#FFFFFF"];
    ziwuLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:ziwuLabel];
    [ziwuLabel release];
    

    //
    UIButton *teleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    teleBtn.frame=CGRectMake(85, 50, 114, 22);
    [teleBtn setTitle:[@"电话:" stringByAppendingString:[dictionary objectForKey:@"link_url"]]  forState:UIControlStateNormal];
//    teleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 5, 0);
    teleBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [teleBtn setTitleColor:[UIColor colorwithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [teleBtn setBackgroundImage:[UIImage imageNamed:@"hopen_01"] forState:UIControlStateNormal];
    [teleBtn setBackgroundImage:[UIImage imageNamed:@"hopen_01"] forState:UIControlStateHighlighted];
    [teleBtn addTarget:self action:@selector(teleBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:teleBtn];
    
    //专家介绍
    UILabel* jieshaoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 300, 30)];
    jieshaoLabel.text= @"   详细信息";
    jieshaoLabel.font = [UIFont boldSystemFontOfSize:14];
    jieshaoLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"more_b"]];
    jieshaoLabel.textColor =[UIColor colorwithHexString:@"#FFFFFF"];
    jieshaoLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:jieshaoLabel];
    [jieshaoLabel release];
    
    
//    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(20, 140, 260, 300)];
    
   
    
    UITextView * contentFied=[[UITextView alloc]initWithFrame:CGRectMake(20, 140, 260, 300)];
    contentFied.editable = NO;
    contentFied.userInteractionEnabled = NO;
    //contentFied.placeholder=@"在这里输入您的建议和意见";
    
    NSString *urlDecoding = [[dictionary objectForKey:@"content"] URLDecodedString];

    NSString *content = [urlDecoding stringByConvertingHTMLToPlainText];
    
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
        CGSize size = [content boundingRectWithSize:CGSizeMake(260, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        if (size.height > contentScrollerView.frame.size.height - 20 - 49 - 100 - 20 - 20 - 45)
        {
            contentScrollerView.contentSize= CGSizeMake(320, size.height + 100 + 45 + 49 +20 +20 +20);
            [bgView setFrame:CGRectMake(10, 10, 300, size.height + 100 + 45  + 49 + 20)];
            [contentFied setFrame:CGRectMake(20, 140, 260, size.height + 100)];

        }
        
    }
    else
    {
        CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(260, 10000)];
        
        if (size.height > contentScrollerView.frame.size.height - 20 - 49 - 100 - 20)
        {
            contentScrollerView.contentSize= CGSizeMake(320, size.height + 100 + 45 + 49 + 20 + 20);
            [bgView setFrame:CGRectMake(10, 10, 300, size.height + 100 + 45  + 49  + 20)];
            [contentFied setFrame:CGRectMake(20, 140, 260, size.height + 100)];
            
        }
        
    }
    
   
    contentFied.text = content;

    //    contentFied.layer.masksToBounds = YES;
    //    contentFied.layer.cornerRadius = 5.0;
    //    contentFied.layer.borderWidth = 1.0;
    //    contentFied.layer.borderColor = [[UIColor colorwithHexString:@"d470a8"] CGColor];
    contentFied.font=[UIFont systemFontOfSize:12];
    contentFied.textColor = [UIColor colorwithHexString:@"#878787"];
    contentFied.backgroundColor=[UIColor clearColor];
    [bgView addSubview:contentFied];
    [contentFied release];
}

- (void)teleBtnPressed:(UIButton *)button
{
    NSString *string = [button titleForState:UIControlStateNormal];
    NSString * phoneNum = [string substringFromIndex:3];
    
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:phoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
