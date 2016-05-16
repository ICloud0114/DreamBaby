//
//  SubmitAudioViewController.m
//  DreamBaby
//
//  Created by easaa on 14-1-6.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "SubmitAudioViewController.h"
#import "SubmitAudioAlert.h"
#import "AppDelegate.h"


#import "HTTPRequest.h"
#import "FBEncryptorDES.h"
#import "NSString+URLEncoding.h"
#import "JsonFactory.h"
#import "JsonUtil.h"
#import "ATMHud.h"
#import "ATMHudDelegate.h"
#import "IsLogIn.h"
#import "MyDiaryViewController.h"

@interface SubmitAudioViewController ()<ATMHudDelegate,UITextFieldDelegate>
{
    NSDictionary *upload;
    ATMHud *hud;
    BOOL isUp;
    UIButton *aBtn;
    NSTimeInterval startTime;
    
    UITextField *itemTextField;
    UITapGestureRecognizer *tapGesture;
}
@end

@implementation SubmitAudioViewController

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
    if (audioRecoder) {
        [audioRecoder release];
    }
    hud.delegate=nil;
    [hud release];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    
    self.navigationItem.title = @"上传录音";
    
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
    
    
    UIImageView *titleImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"riji1"]];
    titleImage.userInteractionEnabled = YES;
    [titleImage setFrame:CGRectMake(20, 35, 280, 30)];
    [self.view addSubview:titleImage];
    
    
    UILabel *itemLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 66, 30)];
    itemLabel.text = @"主 题";
    itemLabel.backgroundColor = [UIColor clearColor];
    itemLabel.font = [UIFont systemFontOfSize:14];
    itemLabel.textColor = [UIColor whiteColor];
    [titleImage addSubview:itemLabel];
    [itemLabel release];
    
    itemTextField = [[UITextField alloc]initWithFrame:CGRectMake(60, 5, 200, 20)];
    itemTextField.backgroundColor = [UIColor clearColor];
    itemTextField.font = [UIFont systemFontOfSize:12];
    itemTextField.placeholder = @"请输入录音标题";
    itemTextField.textColor = [UIColor colorwithHexString:@"#B4B4B5"];
    itemTextField.delegate = self;
    [titleImage addSubview:itemTextField];
    
    [titleImage release];
    
    UIImageView * shuruBG = [[UIImageView alloc]initWithFrame:CGRectMake(120, 100, 71, 90)];
    shuruBG.userInteractionEnabled = YES;
    shuruBG.image = [UIImage imageNamed:@"luying1"];
    [self.view addSubview:shuruBG];
    [shuruBG release];
    
    hud = [[ATMHud alloc]initWithDelegate:self];
    //长按录音
    aBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [aBtn setFrame:CGRectMake(90, 240, 139, 34)];
    [aBtn setBackgroundImage:[UIImage imageNamed:@"luying2"] forState:UIControlStateNormal];
    aBtn.tag = 100;
    [self.view addSubview:aBtn];
    //button点击事件
    [aBtn addTarget:self action:@selector(btnShort:) forControlEvents:UIControlEventTouchDown];
    [aBtn setTitle:@"长按录音" forState:UIControlStateNormal];
    aBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [aBtn addTarget:self action:@selector(btnStop) forControlEvents:UIControlEventTouchUpInside];
    //button长按事件
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    longPress.minimumPressDuration = 0.8; //定义按的时间
//    [aBtn addGestureRecognizer:longPress];
    
    
    /**
     *  set up record
     */
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone || UIUserInterfaceIdiomPad)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *error;
        if ([audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error])
        {
            if ([audioSession setActive:YES error:&error])
            {
                //        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
            }
            else
            {
                NSLog(@"Failed to set audio session category: %@", error);
            }
        }
        else
        {
            NSLog(@"Failed to set audio session category: %@", error);
        }
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof(audioRouteOverride),&audioRouteOverride);
    }
    audioRecoder = [[CL_AudioRecorder alloc] initWithFinishRecordingBlock:^(CL_AudioRecorder *recorder, BOOL success) {
        //NSLog(@"%@,%@",success?@"YES":@"NO",recorder.recorderingPath);
    } encodeErrorRecordingBlock:^(CL_AudioRecorder *recorder, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
    } receivedRecordingBlock:^(CL_AudioRecorder *recorder, float peakPower, float averagePower, float currentTime) {
        NSLog(@"%f,%f,%f",peakPower,averagePower,currentTime);
    }];
    
    
    [self.view addSubview:hud.view];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(upload) name:@"UPLOADRECORD" object:nil];
  
    isUp = NO;
    
    
    tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    
    
    
}

- (void)hideKeyboard
{
    [itemTextField resignFirstResponder];
}

- (void)btnShort:(UIButton *)sender
{
    
    if ([itemTextField.text isEqualToString:@""]|| itemTextField.text == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入标题" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    NSLog(@"短按");
    startTime = [[NSDate date] timeIntervalSince1970];
    [self performSelector:@selector(startRecord) withObject:Nil afterDelay:1.0f];
//    [sender sendActionsForControlEvents:UIControlEventTouchDown];
//    sender.selected = YES;
//    sender.highlighted = NO;
    
//    [self startToRecord];
}
-(void)startRecord
{
   
     [self startToRecord];
}
-(void)btnStop
{
    NSLog(@"结束");
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if ((now - startTime)<1.0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self                                              selector:@selector(startRecord) object:nil];
    }else
    {
    [self endRecord];
    [self popUpOpreateView];
    }
}
-(void)btnLong:(UILongPressGestureRecognizer *)gestureRecognizer{
//    UIButton *btn = (UIButton *)gestureRecognizer.view;
//    
//    btn.selected = YES;
//    [hud setCaption:@"正在录音，请保持长按。"];
//    [hud show];
//    [hud hideAfter:1];
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        aBtn.selected = YES;
        aBtn.highlighted = NO;
        NSLog(@"长按事件");
        [self startToRecord];
        
        
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
      
        [self endRecord];
      
        [self popUpOpreateView];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        //end record and delete recording files
        [self endRecord];
        NSString *recordAudioFullPath = [kRecorderDirectory stringByAppendingPathComponent:
                                         [NSString stringWithFormat:@"abc.wav"]];
        

        NSLock* tempLock = [[NSLock alloc]init];
        [tempLock lock];
        if ([[NSFileManager defaultManager] fileExistsAtPath:recordAudioFullPath])
        {
            [[NSFileManager defaultManager] removeItemAtPath:recordAudioFullPath error:nil];
        }
        [tempLock unlock];
        [tempLock release];
        
    }
}

- (void)upload
{
    NSString *recordAudioFullPath = [kRecorderDirectory stringByAppendingPathComponent:
                                     [NSString stringWithFormat:@"abc.wav"]];
    [self uploadRecord:recordAudioFullPath];
}


- (void)uploadRecord:(NSString *)fileUrl
{
    [hud setCaption:@"正在上传"];
    [hud setActivity:YES];
    [hud show];
    hud.delegate = nil;
    NSDictionary *requestParams = [NSDictionary dictionaryWithObjectsAndKeys:[IsLogIn instance].memberData.idString,@"user_id",@"3",@"type",itemTextField.text,@"title",nil];
    NSString *paramsJson = [JsonFactory dictoryToJsonStr:requestParams];
    
    //    NSLog(@"requestParamstr %@",paramsJson);
    //加密
	paramsJson = [[FBEncryptorDES encrypt:paramsJson
                                keyString:@"SDFL#)@F"] uppercaseString];
    NSString *signs= [NSString stringWithFormat:@"SDFL#)@FMethod%@Params%@SDFL#)@F",@"add_note",paramsJson];
    signs = [[FBEncryptorDES md5:signs] uppercaseString];
    //    http://113.105.159.107:84
    //    icbcapp.intsun.com
    
    
    NSString *urlStr = [NSString stringWithFormat:BABYAPI,@"add_note",paramsJson,signs];
    
    
    NSData* postData = [[[NSData alloc]initWithContentsOfFile:fileUrl] autorelease];
    
    if (isUp == NO) {
        isUp = YES;
    dispatch_queue_t network_queue;
    network_queue = dispatch_queue_create("login", nil);
    dispatch_async(network_queue, ^{
        
    NSString *TWITTERFON_FORM_BOUNDARY = @"AABBCC";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY] autorelease];
    //结束符 AaB03x--
    NSString *endMPboundary=[[[NSString alloc]initWithFormat:@"%@--",MPboundary] autorelease];
    //http body的字符串
    NSMutableString *body=[[[NSMutableString alloc]init] autorelease];
    
    ////添加分界线，换行---文件要先声明
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"files\"; filename=\"abc.wav\"\r\n"];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: media/AAC\r\n\r\n"];
    //声明结束符：--AaB03x--
    NSString *end=[[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary] autorelease];
    
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:postData];
 
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY] autorelease];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    //建立连接，设置代理
    //    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //设置接受response的data
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    
    NSData *urlData = [NSURLConnection
                       sendSynchronousRequest:request
                       returningResponse: &response
                       error: &error];
    
    
    NSString *json = [[[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"json %@",json);
    json = [FBEncryptorDES decrypt:json keyString:@"SDFL#)@F"];
    json = [json URLDecodedString];
    NSLog(@"json :%@",json);
        NSDictionary *dictionary = [JsonUtil jsonToDic:json];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dictionary objectForKey:@"msg"]integerValue] == 1) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshMyDiary" object:nil];
                
                NSString *dataString = [dictionary objectForKey:@"data"];
                dataString = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
                dataString = [dataString URLDecodedString];
                NSDictionary *dictionary = [JsonUtil jsonToDic:dataString];
                upload= [dictionary copy];
                [hud setCaption:@"上传录音成功"];
                hud.delegate = self;
                [hud setActivity:NO];
                [hud show];
                [hud update];
                [hud hideAfter:0.5];
//                [hud setCaption:@"上传录音成功"];
            }else
            {
                isUp = NO;
                [hud setCaption:@"上传录音失败"];
                hud.delegate = self;
                [hud setActivity:NO];
                [hud show];
                [hud update];
                hud.delegate = nil;
                [hud hideAfter:0.5];
            }
            
        });
        
    });
    }
    //
  
}

- (void)hudWillDisappear:(ATMHud *)_hud
{
    
        if ([self.delegate respondsToSelector:@selector(SubmitAudioViewController:didFinishUpload:)]) {
            [self.delegate SubmitAudioViewController:self didFinishUpload:upload];
        }
//    [self.navigationController popViewControllerAnimated:YES];
    for (UIViewController *temp in self.navigationController.viewControllers)
    {
        if ([temp isKindOfClass:[MyDiaryViewController class]])
        {
            [self.navigationController popToViewController:temp animated:YES];
            break ;
        }
    }
}

- (void)popUpOpreateView
{
    UIApplication * app = [UIApplication sharedApplication];
    AppDelegate * appDelegate = (AppDelegate *)app.delegate;
    SubmitAudioAlert * hudView = [[[NSBundle mainBundle]loadNibNamed:@"SubmitAudioAlert" owner:self options:nil]lastObject];
    hudView.center = appDelegate.window.center;
    [appDelegate.window addSubview:hudView];
    
    
    
    CABasicAnimation *forwardAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    forwardAnimation.duration = 0.7;
    forwardAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.5f :1.7f :0.6f :0.85f];
    forwardAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    forwardAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:forwardAnimation, nil];
    //    animationGroup.delegate = self;
    animationGroup.duration = forwardAnimation.duration  + 1.0;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    [UIView animateWithDuration:animationGroup.duration
                          delay:0.0
                        options:0
                     animations:^{
                         [hudView.layer addAnimation:animationGroup
                                              forKey:@"kLPAnimationKeyPopup"];
                     }
                     completion:^(BOOL finished) {
                         //                NSLog(@" anmation finsh");
                     }];
    
    
}

#pragma mark record function
- (void)startToRecord
{
    if (m_isRecording == NO)
    {
        m_isRecording = YES;
        NSString *recordAudioFullPath = [kRecorderDirectory stringByAppendingPathComponent:
                                         [NSString stringWithFormat:@"abc.wav"]];
        NSLock* tempLock = [[NSLock alloc]init];
        [tempLock lock];
        if ([[NSFileManager defaultManager] fileExistsAtPath:recordAudioFullPath])
        {
            [[NSFileManager defaultManager] removeItemAtPath:recordAudioFullPath error:nil];
        }
        [tempLock unlock];
        [tempLock release];
        
        [audioRecoder startRecord];
    }
}

- (void)endRecord
{
    m_isRecording = NO;
    dispatch_queue_t stopQueue;
    stopQueue = dispatch_queue_create("stopQueue", NULL);
    dispatch_async(stopQueue, ^(void){
        //run in main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [audioRecoder stopRecord];
        });
    });
    dispatch_release(stopQueue);
}






/**
 *   [self sendFileWithPath:[kRecorderDirectory stringByAppendingPathComponent:
 [NSString stringWithFormat:@"recordAudio.aac"]]];
 */


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.view addGestureRecognizer:tapGesture];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self.view removeGestureRecognizer:tapGesture];
    return YES;
}
@end
