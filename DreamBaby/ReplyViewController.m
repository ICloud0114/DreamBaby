//
//  ReplyViewController.m
//  梦想宝贝
//
//  Created by IOS001 on 14-5-23.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "ReplyViewController.h"
#import "IsLogIn.h"
#import "JsonFactory.h"
@interface ReplyViewController ()
{
    ATMHud *hud;
    NSMutableArray *areaArr;
    NSMutableArray *ageGroupArr;
    NSMutableArray *dataArr;
    NSDictionary *upload;
    
//    UIPickerView *myPickerView;
}
@property (retain, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (retain, nonatomic) IBOutlet UITextField *topTextField;
@property (retain, nonatomic) IBOutlet UITextField *areaTextField;
@property (retain, nonatomic) IBOutlet UITextField *ageTextField;
@property (retain, nonatomic) IBOutlet UITextView *contentTextField;
@property (retain, nonatomic) IBOutlet UIButton *updateBtn;
@property (retain, nonatomic) IBOutlet UIImageView *photoImageView;
- (IBAction)updateMessage:(UIButton *)sender;
@property (retain, nonatomic) IBOutlet UIPickerView *pickerView;
- (IBAction)selectBtn:(UIBarButtonItem *)sender;
@property (retain, nonatomic) IBOutlet UIToolbar *toolBar;
- (IBAction)ageGroupBeginEdting:(UITextField *)sender;
- (IBAction)areaBeginEdting:(UITextField *)sender;
- (IBAction)selectAreaAction:(id)sender;


@end

@implementation ReplyViewController

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
//    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 1)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 40)];
    titleLabel.text = @"发帖";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel release];
    dataArr=[[NSMutableArray alloc]init];
    areaArr = [[NSMutableArray alloc]init];
    ageGroupArr = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
    
    [self.mainScrollView addGestureRecognizer:tap];
    self.mainScrollView.contentSize=CGSizeMake(0, self.updateBtn.frame.origin.y + self.updateBtn.frame.size.height + 40);
    [tap release];
    
//    myPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.frame.size.width, 160)];
//    myPickerView.backgroundColor = [UIColor whiteColor];
//    myPickerView.delegate = self;
//    myPickerView.dataSource = self;
//    [self.view addSubview:myPickerView];
//    [myPickerView release];
    
    
    
    self.pickerView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.frame.size.width, 160);

    self.areaTextField.inputView = self.pickerView;
    
    self.areaTextField.inputAccessoryView = self.toolBar;
    self.ageTextField.inputAccessoryView = self.toolBar;
    self.ageTextField.inputView = self.pickerView;
    
    
    //添加照片
    UITapGestureRecognizer *addPhotoGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToPhoto:)];
    [self.photoImageView addGestureRecognizer: addPhotoGesture];
    self.photoImageView.userInteractionEnabled = YES;
   
    [addPhotoGesture release];
    UIImage *backgroundImage = [UIImage imageNamed:@"riji2.png"];
    self.photoImageView.layer.contents = (id)backgroundImage.CGImage;
    
    hud = [[ATMHud alloc]initWithDelegate:self];
    [self.view addSubview:hud.view];
    [self getRequset];
    isUp = NO;
}

-(void)tapToPhoto:(UITapGestureRecognizer *)tap
{
    [self.contentTextField resignFirstResponder];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    [actionSheet release];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

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
    
    [self.photoImageView setImage:creatImage];
//    self.photoImageView.image = creatImage;
    
    [creatImage release];
    
//    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView==self.contentTextField)
    {
        if ([self.contentTextField.text isEqualToString:@"今天你想说点什么"])
        {
             self.contentTextField.text = @"";
        }
        self.mainScrollView.frame=CGRectMake(0, self.mainScrollView.frame.origin.y, 320, self.mainScrollView.frame.size.height - 200);
        [UIView animateWithDuration:0.3 animations:^{
            self.mainScrollView.contentOffset=CGPointMake(0, self.contentTextField.frame.origin.y - 40);
        }];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView==self.contentTextField)
    {
         self.mainScrollView.frame=CGRectMake(0, self.mainScrollView.frame.origin.y, 320, self.mainScrollView.frame.size.height + 200);
    }
}
-(void)tapGesture
{
    [self.topTextField resignFirstResponder];
    [self.contentTextField resignFirstResponder];
}
#pragma mark picker代理函数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [dataArr count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (![dataArr objectAtIndex:row]) {
        return nil;
    }
    return [dataArr objectAtIndex:row];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (areaArr.count == 0||ageGroupArr.count == 0)
    {
        return;
    }
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    if (textField==self.areaTextField)
    {
        textField.text = [areaArr objectAtIndex:row];
    }else if(textField == self.ageTextField)
    {
        textField.text = [ageGroupArr objectAtIndex:row];
    }
}
#pragma mark 加载数据
- (void)getRequset
{
    self.areaTextField.userInteractionEnabled = NO;
    self.ageTextField.userInteractionEnabled = NO;
    [hud setCaption:@"加载中"];
    [hud setActivity:YES];
    [hud show];
    int cityId = [IsLogIn instance].memberData.cityId;
    NSDictionary *param = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:cityId],@"city_id", nil];
    dispatch_queue_t network;
    network = dispatch_queue_create("get_area", nil);
    dispatch_async(network, ^{
        //获得区域
        NSString *request = [HTTPRequest requestForGetWithPramas:param method:@"get_area"];
        //获得年龄组
        NSString *request1 = [HTTPRequest requestForGetWithPramas:param method:@"get_age_group"];
        
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        NSDictionary *dictionary1 = [JsonUtil jsonToDic:request1];
        NSLog(@"requestarea = %@",dictionary);
        NSLog(@"requestage = %@",dictionary1);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dictionary objectForKey:@"msg"]integerValue] == 1&&[[dictionary1 objectForKey:@"msg"]integerValue] == 1)
            {
                [hud hideAfter:1.0f];
            if ([[dictionary objectForKey:@"msg"]integerValue] == 1)
            {
                NSString *dataString = [dictionary objectForKey:@"data"];
                dataString = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
                dataString = [dataString URLDecodedString];

                [dataString rangeOfString:@":"];
                
                
//                [areaArr addObjectsFromArray:[dataString componentsSeparatedByString:@","]];
//                NSLog(@"%@   %@",[areaArr[0] class],areaArr[0]);
//                [areaArr removeObjectAtIndex:(areaArr.count-1)];
                NSMutableArray *areaArray = [NSMutableArray array];
                [areaArray addObjectsFromArray:[dataString objectFromJSONString]];
                

                for (NSDictionary *dic in areaArray)
                {
                    
                    [areaArr addObject:[dic objectForKey:@"title"]];
                }

            }
            if ([[dictionary1 objectForKey:@"msg"]integerValue] == 1)
            {
                NSString *dataString = [dictionary1 objectForKey:@"data"];
                dataString = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
                dataString = [dataString URLDecodedString];
                [ageGroupArr addObjectsFromArray:[dataString componentsSeparatedByString:@","]];
                [ageGroupArr removeObjectAtIndex:(ageGroupArr.count-1)];
            }
//                [hud setCaption:@"加载成功"];
//                [hud setActivity:NO];
//                [hud update];
//                [hud hideAfter:1.0f];
                self.areaTextField.userInteractionEnabled = YES;
                self.ageTextField.userInteractionEnabled = YES;
            }
            else
            {
                [hud setCaption:@"加载失败"];
                [hud setActivity:NO];
                [hud update];
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

- (void)dealloc {
    [dataArr release];
    [ageGroupArr release];
    [areaArr release];
    [_mainScrollView release];
    [_topTextField release];
    [_areaTextField release];
    [_ageTextField release];
    [_contentTextField release];
    [_updateBtn release];
    [_pickerView release];
    [_toolBar release];
    self.delegate=nil;
    [actPlay release];
    [_photoImageView release];
    
    hud.delegate = nil;
    [hud release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMainScrollView:nil];
    [self setTopTextField:nil];
    [self setAreaTextField:nil];
    [self setAgeTextField:nil];
    [self setContentTextField:nil];
    [self setUpdateBtn:nil];
    [self setPickerView:nil];
    [self setToolBar:nil];
    [self setPhotoImageView:nil];
    [super viewDidUnload];
}
- (IBAction)endReturn:(UITextField *)sender {
    [sender resignFirstResponder];
}
#pragma mark 发帖
- (IBAction)updateMessage:(UIButton *)sender
{
    
    if (self.topTextField.text.length==0||self.areaTextField.text.length==0||self.ageTextField.text.length==0||self.contentTextField.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请填写完整信息" message:Nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    if (isUp == NO)
    {
        isUp =YES;
   
        NSString *user_id = [IsLogIn instance].memberData.idString;
        NSLog(@"user = %@",user_id);

        
        
        NSDictionary *postDic = [NSDictionary dictionaryWithObjectsAndKeys:user_id,@"user_id",
                                        [NSString stringWithFormat:@"%@",self.topTextField.text],@"title",
                                        [NSString stringWithFormat:@"%@",self.areaTextField.text],@"area",
                                        [NSString stringWithFormat:@"%@",self.ageTextField.text],@"age_group",
                                        [NSString stringWithFormat:@"%@",self.contentTextField.text],@"content",
                                        nil];

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
            NSString *signs= [NSString stringWithFormat:@"SDFL#)@FMethod%@Params%@SDFL#)@F",@"publish_topic",paramsJson];
            signs = [[FBEncryptorDES md5:signs] uppercaseString];
            
            NSString *urlStr = [NSString stringWithFormat:BABYAPI,@"publish_topic",paramsJson,signs];
            //            NSString *urlStr = [NSString stringWithFormat:@"http://192.168.0.23:16327/api/GetFetationInfo.ashx?Method=%@&Params=%@&Sign=%@",@"add_note",paramsJson,signs];
            NSString *postString = [NSString stringWithFormat:@"image=%@&content=%@",tem,self.contentTextField.text];
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
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMotherList" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark alretDelegete
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([self.delegate respondsToSelector:@selector(beginReloadData)]) {
        [self.delegate beginReloadData];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 收起picker
- (IBAction)selectBtn:(UIBarButtonItem *)sender {
//    if (areaArr.count == 0||ageGroupArr.count == 0) {
//        return;
//    }
    [self.areaTextField  endEditing:YES];
    [self.ageTextField endEditing:YES];
//    CGRect rect = self.pickerView.frame;
//    rect.origin.y = self.view.bounds.size.height;
//    self.pickerView.frame = rect;
}

- (IBAction)ageGroupBeginEdting:(UITextField *)sender
{

    if (ageGroupArr.count == 0)
    {
        return;
    }
    [dataArr removeAllObjects];
    [dataArr addObjectsFromArray:ageGroupArr];
    [self.pickerView reloadAllComponents];
//    CGRect rect = self.pickerView.frame;
//    rect.origin.y = self.view.bounds.size.height - 160;
//    self.pickerView.frame = rect;
}

- (IBAction)areaBeginEdting:(UITextField *)sender
{

    if (areaArr.count == 0)
    {
        return;
    }
    [dataArr removeAllObjects];
    [dataArr addObjectsFromArray:areaArr];
    [self.pickerView reloadAllComponents];
//    CGRect rect = self.pickerView.frame;
//    rect.origin.y = self.view.bounds.size.height - 160;
//    self.pickerView.frame = rect;
}

- (IBAction)selectAreaAction:(id)sender
{
    if (areaArr.count == 0)
    {
        return;
    }
    [dataArr removeAllObjects];
    [dataArr addObjectsFromArray:areaArr];
    [self.pickerView reloadAllComponents];
    CGRect rect = self.pickerView.frame;
    rect.origin.y = self.view.bounds.size.height - 160;
    self.pickerView.frame = rect;
}

@end
