//
//  PinceResultViewController.m
//  DreamBaby
//
//  Created by easaa on 14-1-10.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "PinceResultViewController.h"


@interface PinceResultViewController ()

@end

@implementation PinceResultViewController

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
    
    self.navigationItem.title = @"评测结果";
    
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
    
    //上面
    UIImageView * jieguoIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pingche_jieguo_biaozhun"]];
    jieguoIV.frame = CGRectMake(0, 0, 320, 156);
    [self.view addSubview:jieguoIV];
    [jieguoIV  release];
    
    //下面背景
    UIImageView * xiaMianBGIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pingche_jieguo_bg"]];
    xiaMianBGIV.userInteractionEnabled = YES;
    xiaMianBGIV.frame = CGRectMake(0, 160, 320, 200);
    [self.view addSubview:xiaMianBGIV];
    [xiaMianBGIV  release];
    
    
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 55, 200, 60)];
    label2.font = [UIFont systemFontOfSize:18];
    label2.numberOfLines =0;
    label2.textAlignment  = NSTextAlignmentCenter;
    label2.backgroundColor = [UIColor clearColor];
    label2.text = @"您的体重属于标准范围  请继续保持!";
    label2.textColor = [UIColor colorwithHexString:@"#d470a8"];
    [xiaMianBGIV  addSubview:label2];
    [label2 release];
    [label2 setTag:815];

    if (self.type == 1) {
        //妈妈
//        UILabel *standardLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(30, 50, 120, 20)];
//        standardLabel1.font = [UIFont systemFontOfSize:18];
//        standardLabel1.textColor = [UIColor colorwithHexString:@"#d470a8"];
//        standardLabel1.backgroundColor = [UIColor clearColor];
//        standardLabel1.text = @"孕前标准体重:";
//        [xiaMianBGIV addSubview:standardLabel1];
//        [standardLabel1 release];
//        UILabel *standardLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(standardLabel1.frame.size.width + standardLabel1.frame.origin.x + 5, standardLabel1.frame.origin.y, 100, 20)];
//        standardLabel2.textColor = [UIColor grayColor];
//        standardLabel2.font = [UIFont systemFontOfSize:18];
//        standardLabel2.backgroundColor = [UIColor clearColor];
//        standardLabel2.text = self.standardWeight;
//        [xiaMianBGIV addSubview:standardLabel2];
//        [standardLabel2 release];
//        
//        UILabel *fatLabel = [[UILabel alloc]initWithFrame:CGRectMake(standardLabel1.frame.origin.x, standardLabel1.frame.origin.y + standardLabel1.frame.size.height + 10, 120, 20)];
//        fatLabel.font = [UIFont systemFontOfSize:18];
//        fatLabel.textColor = [UIColor colorwithHexString:@"#d470a8"];
//        fatLabel.backgroundColor = [UIColor clearColor];
//        fatLabel.text = @"孕前肥胖度:";
//        [xiaMianBGIV addSubview:fatLabel];
//        [fatLabel release];
//        UILabel *fatlabel1 = [[UILabel alloc]initWithFrame:CGRectMake(fatLabel.frame.size.width + fatLabel.frame.origin.x + 5, fatLabel.frame.origin.y, 100, 20)];
//        fatlabel1.textColor = [UIColor grayColor];
//        fatlabel1.font = [UIFont systemFontOfSize:18];
//        fatlabel1.backgroundColor = [UIColor clearColor];
//        fatlabel1.text = self.fatPoint;
//        [xiaMianBGIV addSubview:fatlabel1];
//        [fatlabel1 release];
//
//        UILabel *BMILabel = [[UILabel alloc]initWithFrame:CGRectMake(standardLabel1.frame.origin.x, fatLabel.frame.origin.y + fatLabel.frame.size.height + 10, 120, 20)];
//        BMILabel.font = [UIFont systemFontOfSize:18];
//        BMILabel.textColor = [UIColor colorwithHexString:@"#d470a8"];
//        BMILabel.backgroundColor = [UIColor clearColor];
//        BMILabel.text = @"肥胖度BMI值:";
//        [xiaMianBGIV addSubview:BMILabel];
//        [BMILabel release];
//        UILabel *BMILabel1 = [[UILabel alloc]initWithFrame:CGRectMake(BMILabel.frame.origin.x + BMILabel.frame.size.width + 5, BMILabel.frame.origin.y, 100, 20)];
//        BMILabel1.textColor = [UIColor grayColor];
//        BMILabel1.font = [UIFont systemFontOfSize:18];
//        BMILabel1.backgroundColor = [UIColor clearColor];
//        BMILabel1.text = self.BMI;
//        [xiaMianBGIV addSubview:BMILabel1];
//        [BMILabel1 release];
//        
//        UILabel *dreamWeight = [[UILabel alloc]initWithFrame:CGRectMake(standardLabel1.frame.origin.x, BMILabel.frame.origin.y + BMILabel.frame.size.height + 10, 120, 20)];
//        dreamWeight.font = [UIFont systemFontOfSize:18];
//        dreamWeight.textColor = [UIColor colorwithHexString:@"#d470a8"];
//        dreamWeight.backgroundColor = [UIColor clearColor];
//        dreamWeight.text = @"安产理想体重:";
//        [xiaMianBGIV addSubview:dreamWeight];
//        [dreamWeight release];
//        UILabel *dreamWeight1 = [[UILabel alloc]initWithFrame:CGRectMake(dreamWeight.frame.size.width + dreamWeight.frame.origin.x + 5, dreamWeight.frame.origin.y, 100, 20)];
//        dreamWeight1.textColor = [UIColor grayColor];
//        dreamWeight1.font = [UIFont systemFontOfSize:18];
//        dreamWeight1.backgroundColor = [UIColor clearColor];
//        dreamWeight1.text = self.dreamWeight;
//        [xiaMianBGIV addSubview:dreamWeight1];
//        [dreamWeight1 release];
//        
//        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(standardLabel1.frame.origin.x, dreamWeight.frame.origin.y + dreamWeight.frame.size.height +3, 250, 40)];
//        label.textColor = [UIColor grayColor];
//        label.numberOfLines = 0;
//        label.font = [UIFont systemFontOfSize:15];
//        label.backgroundColor = [UIColor clearColor];
//        label.text = @"提示:7-10公斤是孕期的体重增加适宜范围";
//        [xiaMianBGIV addSubview:label];
//        [label release];
        switch (self.result) {
            case 1:
            {
                [jieguoIV setImage:[UIImage imageNamed:@"pingche_jieguo_pianqing"]];
                label2.text = @"您的体重偏轻了  需要多补充营养!";
            }
                break;
            case 2:
            {
                [jieguoIV setImage:[UIImage imageNamed:@"pingche_jieguo_biaozhun"]];
                label2.text = @"您的体重属于标准范围  请继续保持!";
            }
                break;
            case 3:
            {
                [jieguoIV setImage:[UIImage imageNamed:@"pingche_jieguo_chaozhong"]];
                label2.text = @"您的体重超标了  请多运动!";
            }
                break;
            default:
                break;
        }
    }else
    {
//        UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 55, 200, 60)];
//        label2.font = [UIFont systemFontOfSize:18];
//        label2.numberOfLines =0;
//        label2.textAlignment  = NSTextAlignmentCenter;
//        label2.backgroundColor = [UIColor clearColor];
//        label2.text = @"您宝宝的体重属于标准范围  请继续保持!";
//        label2.textColor = [UIColor colorwithHexString:@"#d470a8"];
//        [xiaMianBGIV  addSubview:label2];
//        [label2 release];
//        [label2 setTag:815];
        switch (self.result) {
           
            case 1:
            {
                [jieguoIV setImage:[UIImage imageNamed:@"pingche_jieguo_pianqing"]];
                label2.text = @"您宝宝严重营养不良  需要多补充!";
                
            }
                break;
            case 2:
            {
                [jieguoIV setImage:[UIImage imageNamed:@"pingche_jieguo_pianqing"]];
                label2.text = @"您宝宝重度营养不良  需要多补充!";
                
            }
                break;
            case 3:
            {
                [jieguoIV setImage:[UIImage imageNamed:@"pingche_jieguo_pianqing"]];
                label2.text = @"您宝宝轻度营养不良  需要多补充!";
                
            }
                break;
            case 4:
            {
                [jieguoIV setImage:[UIImage imageNamed:@"pingche_jieguo_biaozhun"]];
                label2.text = @"您宝宝的体重属于标准范围  请继续保持!";
            }
                break;
            case 5:
            {
                [jieguoIV setImage:[UIImage imageNamed:@"pingche_jieguo_chaozhong"]];
                label2.text = @"您宝宝的体重超重啦";
            }
                break;
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
