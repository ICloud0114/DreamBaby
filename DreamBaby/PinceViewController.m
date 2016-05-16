//
//  PinceViewController.m
//  DreamBaby
//
//  Created by easaa on 14-1-9.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "PinceViewController.h"
#import "PinceResultViewController.h"
#import "HistoryViewController.h"

@interface PinceViewController ()
{
    CGRect viewRect;
}
@end

@implementation PinceViewController

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
	// Do any additional setup after loading the view.
    
  
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    self.navigationItem.title = @"评测信息";
    
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

    //左边选项卡按钮
    leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(20, 70, 140, 30);
    leftBtn.selected = YES;
    [leftBtn setTitle:@"妈妈测评" forState:UIControlStateNormal];
    leftBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [leftBtn setTitleColor:[UIColor colorwithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"yuchangqi"] forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"yuchangqi_h"] forState:UIControlStateSelected];
    [leftBtn addTarget:self action:@selector(changeChooseView:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.tag=111;
    //    leftBtn.selected=YES;
    [self.view addSubview:leftBtn];
    
    //左边选项卡按钮
    rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(160, 70, 140, 30);
    [rightBtn setTitle:@"宝宝测评" forState:UIControlStateNormal];
    rightBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [rightBtn setTitleColor:[UIColor colorwithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"yuchangqi"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"yuchangqi_h"] forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(changeChooseView:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.tag=112;
    //    leftBtn.selected=YES;
    [self.view addSubview:rightBtn];
    
    
    
   

    
    //粉色背景视图
    viewBG = [[UIImageView alloc]initWithFrame:CGRectMake(20, 100, 280, 310)];
    viewBG.userInteractionEnabled = YES;
//    viewBG.image = [UIImage imageNamed:@"pingche_neirong_bg"];
    [self.view addSubview:viewBG];
    [viewBG release];
    
    
    
    //两块输入背景
    
    
    UIImageView *firstImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yuchangqi_zhouqi"]];
    
    UIImageView *secondImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yuchangqi_zhouqi"]];
    
    [firstImg setFrame: CGRectMake(0, 0, 280, 30)];
    [secondImg setFrame:CGRectMake(0, 35, 280, 30)];
    
    [viewBG addSubview:firstImg];
    
    [firstImg release];
    [viewBG addSubview:secondImg];
    [secondImg release];
    
    
    
    //左侧选项卡视图
    leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 310)];
    leftView.backgroundColor = [UIColor clearColor];
    [viewBG addSubview:leftView];
    [leftView release];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 20)];
    label.font = [UIFont systemFontOfSize:12];
    label.backgroundColor = [UIColor clearColor];
    //label.text = @"请输入天数（天）：";
    label.text = @"请输入身高（厘米）";
    label.textColor = [UIColor colorwithHexString:@"#FFFFFF"];
    [leftView addSubview:label];
    [label release];
    [label setTag:814];
    
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(5, 40, 200, 20)];
    label2.font = [UIFont systemFontOfSize:12];
    label2.backgroundColor = [UIColor clearColor];
    label2.text = @"请输入体重（公斤)";
    label2.textColor = [UIColor colorwithHexString:@"#FFFFFF"];
    [leftView addSubview:label2];
    [label2 release];
    [label2 setTag:815];
    
    
    //
    shenGaoText = [[CustomTextField alloc] initWithFrame:CGRectMake(130, 6, 145, 18)];
    shenGaoText.backgroundColor = [UIColor clearColor];
//    shenGaoText.background = [UIImage imageNamed:@"pingche_shurukuang"];
    shenGaoText.font = [UIFont systemFontOfSize:12];
    shenGaoText.textColor =  [UIColor colorwithHexString:@"#B4B4B5"];
    //nichengText.placeholder = @"100";
    shenGaoText.delegate = self;
    shenGaoText.keyboardType = UIKeyboardTypeDecimalPad;
    [leftView addSubview:shenGaoText];
    [shenGaoText release];
    //
    tizhongText = [[CustomTextField alloc] initWithFrame:CGRectMake(130, 41, 145, 18)];
    tizhongText.backgroundColor = [UIColor clearColor];
//    tizhongText.background = [UIImage imageNamed:@"pingche_shurukuang"];
    tizhongText.font = [UIFont systemFontOfSize:12];
    tizhongText.textColor =  [UIColor colorwithHexString:@"#B4B4B5"];

    tizhongText.keyboardType = UIKeyboardTypeDecimalPad;
    tizhongText.delegate = self;
    //tizhongText.placeholder = @"100";
    [leftView addSubview:tizhongText];
    [tizhongText release];
    
    
    

    
    //右侧选项卡视图
    rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 250)];
    
    
//    rightView.contentSize = CGSizeMake(0, 500);
    [viewBG addSubview:rightView];
    [rightView release];
    rightView.hidden = YES;
    
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 20)];
    label3.font = [UIFont systemFontOfSize:12];
    label3.backgroundColor = [UIColor clearColor];
    label3.text = @"请输入天数";
    label3.textColor = [UIColor colorwithHexString:@"#FFFFFF"];
    [rightView addSubview:label3];
    [label3 release];
    [label3 setTag:816];
    
    
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(5, 40, 200, 20)];
    label4.font = [UIFont systemFontOfSize:12];
    label4.backgroundColor = [UIColor clearColor];
    label4.text = @"请输入体重（公斤）";
    label4.textColor = [UIColor colorwithHexString:@"#FFFFFF"];
    [rightView addSubview:label4];
    [label4 release];
    [label4 setTag:817];
    
    
    
    //
    daysText = [[CustomTextField alloc] initWithFrame:CGRectMake(130, 6, 145, 18)];
//    daysText.background = [UIImage imageNamed:@"pingche_shurukuang"];
    daysText.font = [UIFont systemFontOfSize:12];
    daysText.textColor =  [UIColor colorwithHexString:@"#B4B4B5"];
    daysText.backgroundColor = [UIColor clearColor];
    //nichengText.placeholder = @"100";
    daysText.delegate = self;
    daysText.keyboardType = UIKeyboardTypeNumberPad;
    [rightView addSubview:daysText];
    [daysText release];
    //
    tizhong2Text = [[CustomTextField alloc] initWithFrame:CGRectMake(130, 41, 145, 18)];
//    tizhong2Text.background = [UIImage imageNamed:@"pingche_shurukuang"];
    tizhong2Text.font = [UIFont systemFontOfSize:12];
    tizhong2Text.textColor =  [UIColor colorwithHexString:@"#B4B4B5"];
    tizhong2Text.backgroundColor = [UIColor clearColor];
    //tizhongText.placeholder = @"100";
    tizhong2Text.delegate = self;
    tizhong2Text.keyboardType = UIKeyboardTypeDecimalPad;
    [rightView addSubview:tizhong2Text];
    [tizhong2Text release];

    
    
    UIImageView *broadImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yuchangqi_zhouqi"]];
    

    [broadImg setFrame:CGRectMake(0, 70, 280, 30)];
    [rightView addSubview:broadImg];
    [broadImg release];
    
    UILabel *broadLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 75, 200, 20)];
    broadLabel.font = [UIFont systemFontOfSize:12];
    broadLabel.backgroundColor = [UIColor clearColor];
    broadLabel.text = @"请输入出生体重(公斤)";
    broadLabel.textColor = [UIColor colorwithHexString:@"#FFFFFF"];
    [rightView addSubview:broadLabel];
    [broadLabel release];
    broadText = [[CustomTextField alloc]initWithFrame:CGRectMake(130, 76, 145, 18)];
//    broadText.background = [UIImage imageNamed:@"pingche_shurukuang"];
    broadText.font = [UIFont systemFontOfSize:12];
    broadText.textColor = [UIColor colorwithHexString:@"#B4B4B5"];
    broadText.backgroundColor = [UIColor clearColor];
    //tizhongText.placeholder = @"100";
    broadText.delegate = self;
    broadText.keyboardType = UIKeyboardTypeDecimalPad;
    [rightView addSubview:broadText];
    [broadText release];
    
    conformBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    conformBtn.frame=CGRectMake(45, 215, 230, 35);
    [conformBtn setTitle:@"确认" forState:UIControlStateNormal];
    conformBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [conformBtn setBackgroundImage:[UIImage imageNamed:@"yuchangqi"] forState:UIControlStateNormal];
    [conformBtn setBackgroundImage:[UIImage imageNamed:@"yuchangqi_h"] forState:UIControlStateHighlighted];
    //[sharebtn addTarget:self action:@selector(showActionSheet:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    [conformBtn addTarget:self action:@selector(conformsPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:conformBtn];
    
    historyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    historyBtn.frame=CGRectMake(45, 260, 230, 35);
    [historyBtn setTitle:@"历史记录" forState:UIControlStateNormal];
    historyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [historyBtn setBackgroundImage:[UIImage imageNamed:@"yuchangqi"] forState:UIControlStateNormal];
    [historyBtn setBackgroundImage:[UIImage imageNamed:@"yuchangqi_h"] forState:UIControlStateHighlighted];
    //[sharebtn addTarget:self action:@selector(showActionSheet:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    [historyBtn addTarget:self action:@selector(historyPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:historyBtn];
    
    
    
}

- (void)conformsPressed:(UIButton *)sender
{
    if (!leftView.hidden) {
        if (shenGaoText.text.length == 0 || tizhongText.text.length == 0) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Nil message:@"请将信息输入完整" delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
            return;
        }
        
        NSInteger result = [self evaluationMotherWithHeight:[shenGaoText.text floatValue] / 100 bodyWeight:[tizhongText.text floatValue]];
        CGFloat height = [shenGaoText.text floatValue] / 100;
        CGFloat weight = [tizhongText.text floatValue];
        NSDate *date = [NSDate date];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dataString = [dateformatter stringFromDate:date];
        [dateformatter release];
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:[shenGaoText.text floatValue] / 100],@"height",tizhongText.text,@"weight",[NSString stringWithFormat:@"%d",result],@"result",dataString,@"time", nil];
                                    
        if ([[NSUserDefaults standardUserDefaults]objectForKey:MomHistory]) {
            NSArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:MomHistory];
            NSMutableArray *tempArray = [NSMutableArray array];
            [tempArray addObjectsFromArray:array];
            [tempArray insertObject:dictionary atIndex:0];
            
            [[NSUserDefaults standardUserDefaults]setObject:tempArray forKey:MomHistory];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }else
        {
            NSMutableArray *tempArray = [NSMutableArray array];
            [tempArray insertObject:dictionary atIndex:0];
            
            [[NSUserDefaults standardUserDefaults]setObject:tempArray forKey:MomHistory];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        CGFloat standardWeight = height * height * 21;
        CGFloat fat = (weight - standardWeight) / standardWeight;
        CGFloat BMI = weight / (height * height);
        CGFloat dreamWeight = (BMI * 0.88 + 6.65) * height * height;
        NSString *fatString ;
        if (BMI < 20) {
            fatString = @"偏瘦";
        }else if (BMI >= 20 && BMI <= 24){
        fatString = @"正常";
        }else if (BMI > 24 && BMI <= 26.4){
            fatString = @"略胖";
        }else{
        fatString = @"太胖";
        }
        //妈妈
        PinceResultViewController * pinceRVC = [[PinceResultViewController alloc]init];
        pinceRVC.type = 1;
        pinceRVC.result = result;
        pinceRVC.standardWeight = [NSString stringWithFormat:@"%.2f公斤",standardWeight];
        pinceRVC.fatPoint = [NSString stringWithFormat:@"%.2f%%",fat];
        pinceRVC.BMI = [NSString stringWithFormat:@"%.2f  %@",BMI,fatString];
        pinceRVC.dreamWeight = [NSString stringWithFormat:@"%.2f公斤",dreamWeight];
        [self.navigationController pushViewController:pinceRVC animated:YES];
        [pinceRVC release];
        
    }else
    {
        if (daysText.text.length == 0 || tizhong2Text.text.length == 0 || broadText.text.length == 0) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Nil message:@"请将信息输入完整" delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
            return;
        }
    
        NSInteger result = [self evaluationBabyWithDay:[daysText.text intValue] Weight:[tizhong2Text.text floatValue]];
        NSDate *date = [NSDate date];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dataString = [dateformatter stringFromDate:date];
        [dateformatter release];
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:daysText.text,@"days",tizhong2Text.text,@"weight",[NSString stringWithFormat:@"%ld",(long)result],@"result",dataString,@"time", nil];
        
        if ([[NSUserDefaults standardUserDefaults]objectForKey:BabyHistory]) {
            NSArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:BabyHistory];
            NSMutableArray *tempArray = [NSMutableArray array];
            [tempArray addObjectsFromArray:array];
            [tempArray insertObject:dictionary atIndex:0];
            
            [[NSUserDefaults standardUserDefaults]setObject:tempArray forKey:BabyHistory];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }else
        {
            NSMutableArray *tempArray = [NSMutableArray array];
            [tempArray insertObject:dictionary atIndex:0];
            
            [[NSUserDefaults standardUserDefaults]setObject:tempArray forKey:BabyHistory];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
        //宝宝
        PinceResultViewController * pinceRVC = [[PinceResultViewController alloc]init];
        pinceRVC.type = 2;
        pinceRVC.result = result;
        [self.navigationController pushViewController:pinceRVC animated:YES];
        [pinceRVC release];
        
    }
}
- (void)historyPressed:(UIButton *)sender
{
        HistoryViewController * hisVC = [[HistoryViewController alloc]init];
        if (!rightView.hidden) {
            hisVC.type = 2;
        }else
            hisVC.type = 1;
        [self.navigationController pushViewController:hisVC animated:YES];
        [hisVC release];
    //}
}
-(void)changeChooseView:(UIButton*)sender
{
    if (sender.tag== 112) {
        //        leftView.image = [UIImage imageNamed:@"yunqi_shurukuang_bg01"];
        //        leftView.frame = CGRectMake(7, 15, 305, 170);
        leftView.hidden = YES;
        rightView.hidden = NO;
        
        sender.selected = YES;
        leftBtn.selected = NO;
       
        
    }else{
        //        leftView.image = [UIImage imageNamed:@"yunqi_shurukuang_bg02"];
        //        leftView.frame = CGRectMake(7, 15, 305, 237);
        leftView.hidden = NO;
        rightView.hidden = YES;
       
        sender.selected = YES;
        rightBtn.selected = NO;
    }
    
}

- (NSInteger)evaluationMotherWithHeight:(CGFloat)height bodyWeight:(CGFloat)weight
{
//    CGFloat standardWeight = height * height * 21;
//    CGFloat fat = (weight - standardWeight) / standardWeight;
    CGFloat BMI = weight / (height * height);
//    CGFloat result = weight / (height * 2);
    if (BMI < 20) {
        //偏轻
        BMI = 1;
        return BMI;

    }else if (BMI >= 20 && BMI <= 24)
    {
        //正常
        BMI = 2;
        return BMI;

    }else
    {
        //超重
        BMI = 3;
        return BMI;

    }
    return 0;

}


- (NSInteger)evaluationBabyWithDay:(NSInteger)day Weight:(CGFloat)weight
{
    CGFloat standardWeight;
    int age = [daysText.text intValue];
    if (age < 365) {
    CGFloat broadWeight = [broadText.text floatValue];
        if (age < 365/2) {
            standardWeight = broadWeight + age/30*0.7;
        }else{
            standardWeight = broadWeight + 1.2 + age/60;
        }
    }else{
        standardWeight = age/365 +12;
    }
    CGFloat standardPoint = [tizhong2Text.text floatValue]/standardWeight;
    if (standardPoint < 0.6) {
        return 1;
    }else if (standardPoint >= 0.6&&standardPoint < 0.8){
        return 2;
    }else if (standardPoint >=0.8 && standardPoint < 0.9){
        return 3;
    }else if (standardPoint >0.9 && standardPoint < 1.1){
        return  4;
    }else{
        return 5;
    }
    
    return 1;
//    CGFloat original1 = 2;
//    CGFloat original2 = 4;
//    CGFloat babyWeight1 = 0;
//    CGFloat babyWeight2 = 0;
//    
//    if (day < 180) {
//        babyWeight1 = original1 + day/30.0 * 0.6;
//        babyWeight2 = original2 + day/30.0 * 0.6;
//    }else if (day >= 180 && day < 365)
//    {
//        babyWeight1 = original1 + day/30.0 * 0.5;
//        babyWeight2 = original2 + day/30.0 * 0.5;
//    }else
//    {
//        babyWeight1 = 8 + day/365 * 2;
//        babyWeight2 = 8 + day/365 * 2;
//    }
//    
//    if (weight < babyWeight1) {
//        return 1;
//    }else if (weight >= babyWeight1 && weight <= babyWeight2)
//    {
//        return 2;
//    }else
//    {
//        return 3;
//    }
    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    int age = [daysText.text intValue];
    if (textField == tizhongText || textField == tizhong2Text || textField == broadText) {
        CGRect rect  = self.view.frame;
        viewRect = rect;

        rect.origin.y = 0;
        self.view.frame = rect;
        if (age < 365) {
//            rightView.contentOffset = CGPointMake( 0, 65);
        }
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    int age = [daysText.text intValue];
    if (textField == tizhongText || textField == tizhong2Text || textField == broadText) {
        
        self.view.frame = viewRect;
    }
    if (textField == tizhong2Text) {
        if (age < 365) {
//            rightView.contentOffset = CGPointMake( 0, 170);
        }
    }
    if (textField == daysText) {
        
        if (age < 365) {
//            rightView.contentSize = CGSizeMake( 0, 400);
            
            [viewBG reloadInputViews];
        }else{
//        rightView.contentSize = CGSizeMake( 0, 0);
        [viewBG reloadInputViews];
    }
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
