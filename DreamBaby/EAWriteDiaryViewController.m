//
//  EAWriteDiaryViewController.m
//  梦想宝贝
//
//  Created by easaa on 7/10/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EAWriteDiaryViewController.h"

#import "HTTPRequest.h"
#import "FBEncryptorDES.h"
#import "NSString+URLEncoding.h"
#import "JsonFactory.h"
#import "JsonUtil.h"
#import "ATMHud.h"
#import "ATMHudDelegate.h"
#import "IsLogIn.h"
#import "MyDiaryViewController.h"
#import "DALinedTextView.h"
@interface EAWriteDiaryViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITextViewDelegate>
{
    NSDictionary *upload;
    BOOL isUp;
    ATMHud *hud;
}
@property (retain, nonatomic) IBOutlet UIView *topView;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UITextField *itemTextField;
//@property (retain, nonatomic) IBOutlet UITextView *contentTextView;
@property (retain, nonatomic) IBOutlet DALinedTextView *contentTextView;

@property (retain, nonatomic) IBOutlet UIImageView *photoImageView;

- (IBAction)submitAction:(id)sender;



@end

@implementation EAWriteDiaryViewController

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
    
    self.navigationItem.title = @"发表图文";
    
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
    
    
    isUp = NO;
    
    //显示时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formtter=[[[NSDateFormatter alloc]init] autorelease];
    formtter.dateFormat=@"YYYY/MM/dd";
    self.timeLabel.text = [formtter stringFromDate:date];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToPhoto:)];
    [self.photoImageView addGestureRecognizer: tap];
    self.photoImageView.userInteractionEnabled = YES;

    [tap release];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"riji2.png"];
    self.photoImageView.layer.contents = (id)backgroundImage.CGImage;
    
    hud = [[ATMHud alloc]initWithDelegate:self];
    [self.view addSubview:hud.view];
//    self.contentTextView.scrollIndicatorInsets = UIEdgeInsetsMake(-10, -10, 0, 0);
//    NSString *string = @"今天天气非常好非常好啊";
//    CGSize size =[string sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(229, 10000)];
//    for (int i = 0; i < self.contentTextView.frame.size.height / (size.height ) ; i ++)
//    {
//        UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,(size.height + 1) * (i + 1), 229,1 )];
//        [lineImage setImage:[UIImage imageNamed:@"riji9"]];
//        [self.contentTextView addSubview:lineImage];
//        [lineImage release];
//    }

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard:)];
    [self.view addGestureRecognizer:tapGesture];
    
}

- (void)hideKeyboard:(id)sender
{
    [self.contentTextView resignFirstResponder];
    [self.itemTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_timeLabel release];
    [_itemTextField release];
    [_contentTextView release];

    [_photoImageView release];
    [_topView release];
    hud.delegate = nil;
    [hud release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTimeLabel:nil];
    [self setItemTextField:nil];
    [self setContentTextView:nil];

    [self setPhotoImageView:nil];
    [self setTopView:nil];
    [self setContentTextView:nil];
    [super viewDidUnload];
}


- (IBAction)submitAction:(id)sender
{
    [self.contentTextView resignFirstResponder];
    [self.itemTextField resignFirstResponder];
    
    
    if (self.itemTextField.text == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入日记标题" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    if ([self.itemTextField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入日记标题" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    [self addNoteRequest];
}

- (IBAction)cameraAction:(id)sender
{
    [self.contentTextView resignFirstResponder];
    [self.itemTextField resignFirstResponder];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    picker.videoQuality = UIImagePickerControllerQualityTypeLow;
    [self presentModalViewController:picker animated:YES];
    [picker release];

}


-(void)tapToPhoto:(UITapGestureRecognizer *)tap
{
    [self.contentTextView resignFirstResponder];
    [self.itemTextField resignFirstResponder];
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
    self.photoImageView.image = [info objectForKey:UIImagePickerControllerEditedImage];
}

- (void)addNoteRequest
{
    
    if(isUp == NO){
        isUp = YES;
        [hud setCaption:@"正在上传"];
        [hud setActivity:YES];
        [hud show];
        IsLogIn *islog=[IsLogIn instance];
        
        if (islog.isLogIn==YES) {
            NSDictionary *postDic=[NSDictionary dictionaryWithObjectsAndKeys:islog.memberData.idString,@"user_id",@"1",@"type",self.itemTextField.text,@"title",self.contentTextView.text,@"content",nil];
            
            dispatch_queue_t network_queue;
            network_queue = dispatch_queue_create("upload.text", nil);
            dispatch_async(network_queue, ^{
                NSData *data = UIImageJPEGRepresentation(self.photoImageView.image , 0.1);
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
                NSString *postString = [NSString stringWithFormat:@"imgs=%@&content=%@",tem,self.contentTextView.text];
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
//                        hud.delegate = self;
                        [hud hideAfter:1.0];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyDiary" object:nil];
                        
                        for (UIViewController *temp in self.navigationController.viewControllers)
                        {
                            if ([temp isKindOfClass:[MyDiaryViewController class]])
                            {
                                [self.navigationController popToViewController:temp animated:YES];
                                break ;
                            }
                        }
                    }else
                    {
                        if ([dictionary objectForKey:@"msgbox"]) {
                            [hud setCaption:[dictionary objectForKey:@"msgbox"]];
                            [hud setActivity:NO];
                            [hud show];
                            [hud update];
//                            hud.delegate = nil;
                            [hud hideAfter:1.0];
                        }else
                        {
                            [hud setCaption:@"发表失败,请检查您的网络."];
                            [hud setActivity:NO];
                            [hud show];
                            [hud update];
//                            hud.delegate = nil;
                            [hud hideAfter:1.0];
                        }
                        isUp = NO;
                    }
                    
                });
            });
        }
    }
}

#pragma mark TextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self.topView setFrame:CGRectMake(self.topView.frame.origin.x, self.topView.frame.origin.y - 120 - 20, self.topView.frame.size.width, self.topView.frame.size.height)];
    [self.contentTextView setFrame:CGRectMake(self.contentTextView.frame.origin.x, self.contentTextView.frame.origin.y - 120 - 20, self.contentTextView.frame.size.width, self.view.frame.size.height - 49 -  44 - 120)];
    
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self.topView setFrame:CGRectMake(self.topView.frame.origin.x, self.topView.frame.origin.y + 120 + 20, self.topView.frame.size.width, self.topView.frame.size.height)];
    [self.contentTextView setFrame:CGRectMake(self.contentTextView.frame.origin.x, self.contentTextView.frame.origin.y + 120 + 20, self.contentTextView.frame.size.width, self.view.frame.size.height - 120 )];
    return YES;
}

@end
