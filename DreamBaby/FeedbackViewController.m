//
//  FeedbackViewController.m
//  VitiSport
//
//  Created by easaa on 6/14/13.
//  Copyright (c) 2013 easaa. All rights reserved.
//

#import "FeedbackViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "HTTPRequest.h"
#import "FBEncryptorDES.h"
#import "NSString+URLEncoding.h"

#import "JsonUtil.h"
#import "JsonFactory.h"

#import "IsLogIn.h"

#import "ATMHud.h"
#import "ATMHudDelegate.h"

@interface FeedbackViewController ()<ATMHudDelegate>
{
    NSDictionary *upload;
    ATMHud *hud;
    UIToolbar *keyboardToolbar;
}
@end

@implementation FeedbackViewController

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
//    RELEASE_SAFE(upload);
    [keyboardToolbar release];
     hud.delegate = nil;
    [hud release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    isUp = NO;
    
    self.navigationItem.title = @"上传图文";
    if (self.isFeedback) {
        self.navigationItem.title = @"在线反馈";
    }
    if(self.isSign)
    {
        self.navigationItem.title = @"编辑个性签名";
    }
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
    if (!self.isSign&&!self.isFeedback) {
        UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"xiangji_icon"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(tapToPhoto:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = barItem;
    [barItem release];
    }
    
    
    keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0,                            self.view.bounds.size.width, 44)];
    UIBarButtonItem *flex = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil] autorelease];

    UIBarButtonItem *done = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemDone) target:self action:@selector(resignKeyboard)] autorelease];
    [keyboardToolbar setItems:[[NSArray alloc] initWithObjects:flex,done, nil]];

    contentFied=[[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(20, 20, 280, 130)];
    //contentFied.placeholder=@"在这里输入您的建议和意见";
    contentFied.inputAccessoryView = keyboardToolbar;
    
    contentFied.placeholder = @"今天你想说点什么";
    if (self.isFeedback) {
        contentFied.placeholder = @"输入想对我们说的话";
    }
    
    if (self.isSign) {
        contentFied.placeholder = @"编辑个性签名";
    
    }
    contentFied.layer.masksToBounds = YES;
    contentFied.layer.cornerRadius = 2.0;
    contentFied.layer.borderWidth = 5.0;
    contentFied.layer.borderColor = [[UIColor colorwithHexString:@"#DD2E94"] CGColor];
    contentFied.font=[UIFont systemFontOfSize:12];
    contentFied.textColor = [UIColor colorwithHexString:@"#000000"];
    contentFied.backgroundColor=[UIColor colorwithHexString:@"#ffffff"];
    [self.view addSubview:contentFied];
    
    [contentFied release];
    if (!self.isSign&&!self.isFeedback) {
        photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, contentFied.frame.origin.y + contentFied.frame.size.height + 10, 70, 70)];
    UIImage *backgroundImage = [UIImage imageNamed:@"tianjia_icon"];
    photoImageView.layer.contents = (id)backgroundImage.CGImage;
//    photoImageView.image = [UIImage imageNamed:@"xiangji_icon"];
    photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:photoImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToPhoto:)];
    [photoImageView addGestureRecognizer: tap];
    photoImageView.userInteractionEnabled = YES;
    [photoImageView release];
    [tap release];
        //提交
        UIButton * submitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        submitBtn.frame=CGRectMake(20, photoImageView.frame.size.height + photoImageView.frame.origin.y +10, 280, 30);
        [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        submitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [submitBtn setBackgroundImage:[UIImage imageNamed:@"riji_tuanchu_btn"] forState:UIControlStateNormal];
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"yuchangqi_xiayibu"] forState:UIControlStateNormal];
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"yuchangqi_xiayibu_h"] forState:UIControlStateHighlighted];
        [submitBtn addTarget:self action:@selector(SubmitFeedback) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:submitBtn];
    }else
    {
         //提交
    UIButton * submitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame=CGRectMake(20, contentFied.frame.size.height + contentFied.frame.origin.y +10, 280, 30);
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"yuchangqi_xiayibu"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"yuchangqi_xiayibu_h"] forState:UIControlStateHighlighted];
//    [submitBtn setBackgroundImage:[UIImage imageNamed:@"riji_tuanchu_btn"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(SubmitFeedback) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    }
    
    
    
    
    hud = [[ATMHud alloc]initWithDelegate:self];
    [self.view addSubview:hud.view];
   
}
-(void)tapToPhoto:(UITapGestureRecognizer *)tap
{
    [contentFied resignFirstResponder];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    [actionSheet release];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"buttonIndex = %d",buttonIndex);
    UIImagePickerControllerSourceType sourceType;
    if (buttonIndex == 0)
    {
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if (buttonIndex == 1)
    {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else {
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    picker.videoQuality = UIImagePickerControllerQualityTypeLow;
    [self presentModalViewController:picker animated:YES];
    [picker release];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissModalViewControllerAnimated:YES];
   photoImageView.image = [info objectForKey:UIImagePickerControllerEditedImage];
}
- (void)resignKeyboard
{
    [contentFied resignFirstResponder];
}
-(void)SubmitFeedback
{
    if (contentFied.text==NULL||contentFied.text.length==0) {
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"亲，请输入文字哦" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [av show];
        [av release];
        return;
    }
    
    if (self.isFeedback)
    {
        //在线反馈
        [self addFeedbackRequest];
    }else if(self.isSign)
    {
        //发表文字
        [self updateSignature];
    }else
    {
        [self addNoteRequest];
    }
   
}
-(NSData *) htmlImageString:(NSString *)imageString textViewString:(NSString *)textVIewString
{
    NSString *myBoundary=@"0xKhTmLbOuNdArY";//这个很重要，用于区别输入的域
//    NSString *myContent=[NSString stringWithFormat:@"multipart/form-data;boundary=%@",myBoundary];//意思是要提交的是表单数据
    
//    [myRequest setValue:myContent forHTTPHeaderField:@"Content-type"];//定义内容类型
    
    NSMutableData * body=[NSMutableData data];//这个用于暂存你要提交的数据
    //下面开始增加你的数据了
    //我这里假设表单中，有两个字段，一个叫user,一个叫password
    //字段与字段之间要用到boundary分开
    [body appendData:[[NSString stringWithFormat:@"\n--%@\n",myBoundary] dataUsingEncoding:NSUTF8StringEncoding]];//表示开始
    [body appendData:[@"Content-Disposition:form-data;name='content'\n\n" dataUsingEncoding:NSUTF8StringEncoding]];//第一个字段开始，类型于<input type="text" name="user">
    [body appendData:[textVIewString dataUsingEncoding:NSUTF8StringEncoding]]; //第一个字段的内容，即leve
    
    [body appendData:[[NSString stringWithFormat:@"\n--%@\n",myBoundary]dataUsingEncoding:NSUTF8StringEncoding]];//字段间区分开，也意味着第一个字段结束
    
    [body appendData: [@"Content-Disposition:form-data;name='imgs'\n\n"dataUsingEncoding:NSUTF8StringEncoding]];//第二个字段开始，<input type="text" name="password">
    [body appendData: [imageString dataUsingEncoding:NSUTF8StringEncoding]];//第二个字段的内容
    [body appendData: [[NSString stringWithFormat:@"\n--%@--\n",myBoundary]dataUsingEncoding: NSUTF8StringEncoding]];//结束
//    NSLog(@"body = %@",body);
    return body;
}
#pragma mark - 发表文字
- (void)addNoteRequest
{
    
    if(isUp == NO){
    isUp = YES;
    [hud setCaption:@"正在上传"];
    [hud setActivity:YES];
    [hud show];
    IsLogIn *islog=[IsLogIn instance];
        
    if (islog.isLogIn==YES) {
        NSDictionary *postDic=[NSDictionary dictionaryWithObjectsAndKeys:islog.memberData.idString,@"user_id",@"1",@"type", nil];
        
        dispatch_queue_t network_queue;
        network_queue = dispatch_queue_create("upload.text", nil);
        dispatch_async(network_queue, ^{
            NSData *data = UIImageJPEGRepresentation(photoImageView.image , 0.1);
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
            NSString *signs= [NSString stringWithFormat:@"SDFL#)@FMethod%@Params%@SDFL#)@F",@"add_note",paramsJson];
            signs = [[FBEncryptorDES md5:signs] uppercaseString];
            
            NSString *urlStr = [NSString stringWithFormat:BABYAPI,@"add_note",paramsJson,signs];
//            NSString *urlStr = [NSString stringWithFormat:@"http://192.168.0.23:16327/api/GetFetationInfo.ashx?Method=%@&Params=%@&Sign=%@",@"add_note",paramsJson,signs];
            NSString *postString = [NSString stringWithFormat:@"imgs=%@&content=%@",tem,contentFied.text];
//            NSData *postData = [self htmlImageString:tem textViewString:postString];
            NSString *request = [HTTPRequest requestForPost:urlStr :postString];
//            NSString *request = [HTTPRequest requestForHtmlPost:urlStr :postData];
            NSDictionary *dictionary = [JsonUtil jsonToDic:request];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[dictionary objectForKey:@"msg"]integerValue] == 1)
                {
                    NSString *dataString = [dictionary objectForKey:@"data"];
                    dataString  = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
                    dataString = [dataString URLDecodedString];
                    NSDictionary *dict = [JsonUtil jsonToDic:dataString];
                    upload = [dict copy];
                    NSLog(@"dataString :%@",dataString );
                    [hud setCaption:@"发表成功"];
                    [hud setActivity:NO];
                    [hud show];
                    [hud update];
                    hud.delegate = self;
                    [hud hideAfter:1.0];
                }else
                {
                    if ([dictionary objectForKey:@"msgbox"]) {
                        [hud setCaption:[dictionary objectForKey:@"msgbox"]];
                        [hud setActivity:NO];
                        [hud show];
                        [hud update];
                        hud.delegate = nil;
                        [hud hideAfter:1.0];
                    }else
                    {
                        [hud setCaption:@"发表失败,请检查您的网络."];
                        [hud setActivity:NO];
                        [hud show];
                        [hud update];
                        hud.delegate = nil;
                        [hud hideAfter:1.0];
                    }
                     isUp = NO;
                }
               
            });
        });
    }
}
}

#pragma mark - 在线反馈
- (void)addFeedbackRequest
{
    IsLogIn *islog=[IsLogIn instance];
    if (islog.isLogIn==YES) {
        NSDictionary *postDic=[NSDictionary dictionaryWithObjectsAndKeys:islog.memberData.idString,@"user_id",contentFied.text,@"content", nil];
        dispatch_queue_t network_queue;
        network_queue = dispatch_queue_create("feedback.text", nil);
        dispatch_async(network_queue, ^{
            NSString *request = [HTTPRequest requestForGetWithPramas:postDic method:@"user_feedback"];
            NSDictionary *dictionary = [JsonUtil jsonToDic:request];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[dictionary objectForKey:@"msg"]integerValue] == 1) {
                    [hud setCaption:@"反馈成功"];
                    [hud setActivity:NO];
                    [hud show];
                    hud.delegate = self;
                    [hud hideAfter:2.0];
                }else
                {
                    if ([dictionary objectForKey:@"msgbox"]) {
                        [hud setCaption:[dictionary objectForKey:@"msgbox"]];
                        [hud setActivity:NO];
                        [hud show];
                        hud.delegate = nil;
                        [hud hideAfter:1.0];
                    }else
                    {
                        [hud setCaption:@"反馈失败,请检查您的网络."];
                        [hud setActivity:NO];
                        [hud show];
                        hud.delegate = nil;
                        [hud hideAfter:1.0];
                    }
                }
            });
        });
    }
    
}


#pragma mark - Update signature
- (void)updateSignature
{
    IsLogIn *islog=[IsLogIn instance];
    if (isUp == NO) {
        isUp = YES;
    if (islog.isLogIn==YES) {
        NSDictionary *postDic=[NSDictionary dictionaryWithObjectsAndKeys:islog.memberData.idString,@"user_id",contentFied.text,@"signature", nil];
        dispatch_queue_t network_queue;
        network_queue = dispatch_queue_create("update_signature", nil);
        dispatch_async(network_queue, ^{
            NSString *request = [HTTPRequest requestForGetWithPramas:postDic method:@"update_signature"];
            NSDictionary *dictionary = [JsonUtil jsonToDic:request];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[dictionary objectForKey:@"msg"]integerValue] == 1) {
                    [hud setCaption:@"编辑签名成功"];
                    [hud setActivity:NO];
                    [hud show];
                    hud.delegate = self;
                    [hud hideAfter:2.0];
                }else
                {
                    if ([dictionary objectForKey:@"msgbox"]) {
                        [hud setCaption:[dictionary objectForKey:@"msgbox"]];
                        [hud setActivity:NO];
                        [hud show];
                        hud.delegate = nil;
                        [hud hideAfter:1.0];
                    }else
                    {
                        [hud setCaption:@"修改失败,请检查您的网络."];
                        [hud setActivity:NO];
                        [hud show];
                        hud.delegate = nil;
                        [hud hideAfter:1.0];
                    }
                }
            });
        });
    }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        MemberViewController *myvitiVC=[[[MemberViewController alloc]init] autorelease];
        [self.navigationController pushViewController:myvitiVC animated:NO];
    }
}


- (void)hudWillDisappear:(ATMHud *)_hud
{
//    if ([self.delegate respondsToSelector:@selector(FeedbackViewController:didFinishUpload:)]) {
//        [self.delegate FeedbackViewController:self didFinishUpload:upload];
//    }
    
    if ([self.delegate respondsToSelector:@selector(FeedbackViewController:didFinishUpdateSignature:)]) {
        [self.delegate FeedbackViewController:self didFinishUpdateSignature:contentFied.text];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
