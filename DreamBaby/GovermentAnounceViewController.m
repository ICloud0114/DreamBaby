//
//  GovermentAnounceViewController.m
//  DreamBaby
//
//  Created by easaa on 14-1-9.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "GovermentAnounceViewController.h"
#import "ATMHud.h"
#import "HTTPRequest.h"
#import "JsonUtil.h"
#import "FBEncryptorDES.h"
#import "NSString+URLEncoding.h"
@interface GovermentAnounceViewController ()
{
    ATMHud *hud;
}
@end

@implementation GovermentAnounceViewController
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
    self.navigationItem.title = @"原文";
    if ([flageType isEqualToString:@"003"])
    {
        self.navigationItem.title = @"育儿故事";
    }
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
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
    
    
    contentScrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    //scrollerView.bounds = CGRectMake(0, 0, 260, 400);
    contentScrollerView.contentSize= CGSizeMake(320, self.view.frame.size.height);
    contentScrollerView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    contentScrollerView.backgroundColor = [UIColor clearColor];
    contentScrollerView.pagingEnabled = NO;
    contentScrollerView.bounces = NO;
    contentScrollerView.showsHorizontalScrollIndicator = NO;
    contentScrollerView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:contentScrollerView];
    [contentScrollerView release];
    
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 44 - 49)];
    //bgView.layer.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4f].CGColor;
    bgView.layer.backgroundColor = [UIColor colorwithHexString:@"#FFD9EC"].CGColor;
    bgView.layer.cornerRadius = 0;
    [contentScrollerView addSubview:bgView];
    
    


    hud = [[ATMHud alloc]initWithDelegate:self];
    [self.view addSubview:hud.view];
    if (![flageType isEqualToString:@"003"])
    {
        [self getRequset];
    }else
    {
        [self setUp:nil];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{

}

- (void)setUp:(NSDictionary *)dictionary
{
    //姓名
    
    
    CGSize size = [[dictionary objectForKey:@"title"] sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(300, 9999)];
    UILabel* nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 300, size.height)];
    nameLabel.numberOfLines = 0;
    nameLabel.text= [dictionary objectForKey:@"title"];
    NSLog(@"namelabel = %@",nameLabel.text);
    if ([flageType isEqualToString:@"003"])
    {
        nameLabel.text= self.title;
    }
    
    nameLabel.font = [UIFont boldSystemFontOfSize:14];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor colorwithHexString:@"#F94BB3"];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:nameLabel];
    [nameLabel release];
    
//    if ([[dictionary objectForKey:@"address"] isKindOfClass:[NSString class]])
//    {
//        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 300, self.view.frame.size.height - 49)];
//        contentLabel.numberOfLines = 0;
//        contentLabel.text = [dictionary objectForKey:@"address"];
//        contentLabel.font = [UIFont boldSystemFontOfSize:12];
//        contentLabel.backgroundColor = [UIColor clearColor];
//        contentLabel.textColor = [UIColor colorwithHexString:@"#F94BB3"];
//        contentLabel.textAlignment = NSTextAlignmentLeft;
//        [bgView addSubview:contentLabel];
//        [contentLabel release];
//        return;
//        
//    }
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(10, size.height + 5 , 300, bgView.frame.size.height - size.height - 5)];
//    CGRect hightRect = webView.frame;
//    //判断版本
//    if (self.view.bounds.size.height >= 455)
//    {
//        hightRect.size.height = 400;
//    }
//    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
//    {
//        webView = [[UIWebView alloc]initWithFrame:CGRectMake(10, 50, 300, 300)];
//    }
    webView.delegate = self;
//    webView.frame = hightRect;
    webView.backgroundColor = [UIColor clearColor];
    webView.scrollView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
//    [webView loadHTMLString:[dictionary objectForKey:@"content"] baseURL:nil];
    NSString *acontentString = @"";
    if ([flageType isEqualToString:@"003"])
    {
        acontentString = self.content;
    }
    else
    {
        acontentString = [[dictionary objectForKey:@"content"] URLDecodedString];
    }
    
    NSString *imageFomatString = @"<style type=\"text/css\">img{max-width:100%;height:auto;} </style>";
    NSString *fomatString = [imageFomatString stringByAppendingString:acontentString];
    
    [webView  loadHTMLString:fomatString baseURL:nil];

    
    
    
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.body.style.fontSize=%f;document.body.style.color=%@",12.0,@"#F259B1"];
    
    [webView stringByEvaluatingJavaScriptFromString:jsString];
    
    [jsString release];

    
    [bgView addSubview:webView];
    [webView release];
    
    return;
    UITextView * contentFied=[[UITextView alloc]initWithFrame:CGRectMake(15, 50, 270, 300)];
    //contentFied.placeholder=@"在这里输入您的建议和意见";
    contentFied.text = [dictionary objectForKey:@"content"];
    
    
    if ([flageType isEqualToString:@"003"]) {
        contentFied.text = self.content;
    }
    
    contentFied.font=[UIFont systemFontOfSize:12];
    contentFied.textColor = [UIColor colorwithHexString:@"#464545"];
    contentFied.backgroundColor=[UIColor clearColor];
    [bgView addSubview:contentFied];
}

- (void)getRequset
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
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
