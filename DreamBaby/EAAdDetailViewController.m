//
//  EAAdDetailViewController.m
//  梦想宝贝
//
//  Created by easaa on 7/12/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EAAdDetailViewController.h"

@interface EAAdDetailViewController ()
{

}
@property (retain, nonatomic) IBOutlet UIWebView *myWebView;
@end

@implementation EAAdDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.navigationItem.title = [self.dataDictionary objectForKey:@"Tile"];
    
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
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.dataDictionary objectForKey:@"LinkUrl"]]];
    [self.myWebView loadRequest:request];
    
   
//    [self.myWebView stringByEvaluatingJavaScriptFromString:
//     @"var script = document.createElement('script');"
//     "script.type = 'text/javascript';"
//     "script.text = \"function ResizeImages() { "
//     "var myimg,oldwidth, newheight;"
//     "var maxwidth=260;" //缩放系数
//     "for(i=0;i <document.images.length;i++){"
//     "myimg = document.images[i];"
//     "myimg.setAttribute('style','max-width:260px;height:auto')"
//     "}"
//     "}\";"
//     "document.getElementsByTagName('head')[0].appendChild(script);"];
//    
//    
//    [self.myWebView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
//    NSString *jsString = [[NSString alloc] initWithFormat:@"document.body.style.fontSize=%f;document.body.style.color=%@",12.0,@"#F259B1"];
//    
//    [self.myWebView stringByEvaluatingJavaScriptFromString:jsString];
    
//    [jsString release];
    
//    [self.myWebView loadHTMLString:[self.dataDictionary objectForKey:@"LinkUrl"] baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    RELEASE_SAFE(_dataDictionary);
    [_myWebView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMyWebView:nil];
    [super viewDidUnload];
}

#pragma mark webView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    if (HUD == nil)
//    {
//        HUD = [[MBProgressHUD alloc] initWithView:self.view];
//        [self.view addSubview:HUD];
//        HUD.labelText = @"正在加载";
//    }
//    [HUD show:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    if (HUD != nil)
//    {
//        //        [HUD removeFromSuperview];
//        //        [HUD release];
//        //        HUD = nil;
//        [HUD hide:YES];
//    }
   
//    NSString *jsToGetHTMLSource = @"document.getElementsByTagName('html')[0].innerHTML";
//    
//    NSString *HTMLSource = [webView stringByEvaluatingJavaScriptFromString:jsToGetHTMLSource];
//    NSString *cutString = [HTMLSource stringByReplacingOccurrencesOfString:@"</body>" withString:@""];
//    
//    
//    NSString *imageFomatString = @"<style type=\"text/css\">img{max-width:100%;height:auto;} </style>";
//    
//    NSString *fomatString = [cutString stringByAppendingString:imageFomatString];
//    
//    NSString *resultString = [NSString stringWithFormat:@"%@</body>",fomatString];
//    
//    [webView loadHTMLString:resultString baseURL:nil];



}

@end
