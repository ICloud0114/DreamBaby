//
//  GuanYuWoMen.m
//  BeiJing
//
//  Created by easaa on 10/12/12.
//  Copyright (c) 2012 easaa. All rights reserved.
//

#import "GuanYuWoMen.h"
#import "JSONKit.h"
#import "HTTPRequest.h"
#import "FBEncryptorDES.h"
#import "NSString+URLEncoding.h"
#import "JsonUtil.h"
#import "ATMHud.h"
@interface GuanYuWoMen ()
{
    ATMHud *hud;
}
@end

@implementation GuanYuWoMen
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
     hud.delegate = nil;
    [mytextView release];
    [hud release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    self.navigationItem.title = @"关于我们";
    
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
    
    mytextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 20 -44)];
    mytextView.backgroundColor=[UIColor clearColor];
    mytextView.textColor=[UIColor blackColor];
    mytextView.editable=NO;
    mytextView.font=[UIFont systemFontOfSize:17];
    [self.view addSubview:mytextView];

    hud = [[ATMHud alloc]initWithDelegate:self];
    [self.view addSubview:hud.view];
    
    [self getRequst];
    

}


- (void)getRequst
{
    [hud setCaption:@"加载中"];
    [hud setActivity:YES];
    [hud show];
    
    dispatch_queue_t network;
    network = dispatch_queue_create("get_about", nil);
    dispatch_async(network, ^{
        NSString *request=[HTTPRequest requestForGetWithPramas:nil method:@"get_about"];
        NSDictionary *json=[request objectFromJSONString];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAfter:1.0f];

            if ([[json objectForKey:@"msg"]intValue] == 1) {
                
                NSString *dataString = [json objectForKey:@"data"];
                dataString = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
                dataString = [dataString URLDecodedString];
                NSLog(@"dataString: %@",dataString);
                NSDictionary *dict = [JsonUtil jsonToDic:dataString];
                NSString *description = [dict objectForKey:@"description"];
                description = [description URLDecodedString];
            
                mytextView.text=description;
            }
            else
            {
                if ([json objectForKey:@"msgbox"]!=NULL) {
                    UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:[json objectForKey:@"msgbox"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [av show];
                    RELEASE_SAFE(av);
                    NSLog(@"error :%@", [json objectForKey:@"msgbox"]);
                }
                else
                {
                    UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"获取提醒状态失败,可能是你的网络不给力!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [av show];
                    RELEASE_SAFE(av);
                }
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
