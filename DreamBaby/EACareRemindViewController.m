//
//  EACareRemindViewController.m
//  梦想宝贝
//
//  Created by easaa on 7/11/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EACareRemindViewController.h"
#import "EACareRemindCell.h"
#import "DailyDetailViewController.h"


#import "ATMHud.h"
#import "HTTPRequest.h"
#import "JsonUtil.h"
#import "FBEncryptorDES.h"
#import "NSString+URLEncoding.h"
#import "SVPullToRefresh.h"
#import "JsonFactory.h"
#import "UIImageView+WebCache.h"


@interface EACareRemindViewController ()
{
    ATMHud *hud;
    
    UIView *rightView;
    UIView *selectView;
    UIScrollView *selectScrollView;
    NSMutableArray *buttonArray;
    UIButton *arrowButton;

}

@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic ,retain) NSMutableArray *loveArray;

@end

@implementation EACareRemindViewController



- (void)dealloc {
    hud.delegate=nil;
    [hud release];
    
    RELEASE_SAFE(_loveArray);
    
    [buttonArray release];
    [_myTableView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setMyTableView:nil];
    [super viewDidUnload];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        buttonArray = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [rightView setHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [rightView setHidden:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.loveArray = [NSMutableArray array];
    
    // Do any additional setup after loading the view from its nib.
    
    int week = [[[NSUserDefaults standardUserDefaults]objectForKey:@"week"]intValue];
    if (week > 40||week < 0)
    {
        week = 0;
    }
    
    selectView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 46)] autorelease];
    selectView.hidden = YES;
    [selectView setBackgroundColor:[UIColor colorWithRed:249/255.0 green:223/255.0 blue:239/255. alpha:1]];
    
    selectScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 300, 46)];
    selectScrollView.backgroundColor = [UIColor clearColor];
    selectScrollView.contentSize = CGSizeMake(300 * 8, 46);
    selectScrollView.contentOffset = CGPointMake( week / 5 * 300, 0);
    [selectScrollView setPagingEnabled:YES];
    [selectView addSubview:selectScrollView];
    [selectScrollView release];

    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setFrame:CGRectMake(300 , 10, 19, 25)];
    [nextBtn setImage:[UIImage imageNamed:@"list_arrow02-03"] forState:UIControlStateNormal];
//    [selectView addSubview:nextBtn];
    
    for (int i = 0; i <= 38; i ++)
    {
        
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.tag = i + 1991;
        [selectBtn setBackgroundColor:[UIColor whiteColor]];
        selectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [selectBtn setTitleColor:[UIColor colorwithHexString:@"#878787"] forState:UIControlStateNormal ];
        [selectBtn setTitleColor:[UIColor colorwithHexString:@"#F94BB3"] forState:UIControlStateSelected];
        
        [selectBtn setTitle:[NSString stringWithFormat:@"孕%d周",i + 2] forState:UIControlStateNormal];
        if (i == 0)
        {
            [selectBtn setTitle:[NSString stringWithFormat:@"备孕期"] forState:UIControlStateNormal];
            if (week > 40||week < 0)
            {
                selectBtn.selected = YES;
            }
        }
        [selectBtn addTarget:self action:@selector(selectWeek:) forControlEvents:UIControlEventTouchUpInside];
        [selectBtn setFrame:CGRectMake((i + 1) * 10 + i * 50, 8, 50, 30)];
        
        if (i + 2 == [[[NSUserDefaults standardUserDefaults] objectForKey:@"week"] intValue])
        {
            selectBtn.selected = YES;
            [selectScrollView setContentOffset:CGPointMake(selectBtn.frame.origin.x - 10, 0) animated:YES];
        }
        [selectScrollView addSubview:selectBtn];
        [buttonArray addObject:selectBtn];
        
        
    }

    
    [self.view insertSubview:selectView aboveSubview:self.myTableView];
    
    self.navigationItem.title = @"关爱提醒";
    
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

    rightView  = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 85, 0, 85, 44)];
    rightView.backgroundColor = [UIColor clearColor];
    
    UIImageView *timeImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guangaitixing01"]];
    [timeImg setFrame:CGRectMake(0, 14, 16, 16)];
    [rightView addSubview:timeImg];
    
    
    arrowButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [arrowButton setFrame:CGRectMake(63, 13, 18, 18)];
    arrowButton.selected = NO;
    
    [arrowButton setBackgroundImage:[UIImage imageNamed:@"list_arrow02_1"] forState:UIControlStateNormal];
    [arrowButton setBackgroundImage:[UIImage imageNamed:@"list_arrow02"] forState:UIControlStateSelected];
    
    [rightView addSubview:arrowButton];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 65, 44)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"备孕期";
    titleLabel.tag = 1213;
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"week"]intValue] > 2 && [[[NSUserDefaults standardUserDefaults]objectForKey:@"week"]intValue] <= 40)
    {
        titleLabel.text = [NSString stringWithFormat:@"孕%@周",[[NSUserDefaults standardUserDefaults]objectForKey:@"week"]];
    }
    
    
    [rightView addSubview:titleLabel];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 85, 44)];
    [rightBtn addTarget:self action:@selector(showOrHideSelectView:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:rightBtn];
    
    [self.navigationController.navigationBar addSubview:rightView];
    
    hud = [[ATMHud alloc]initWithDelegate:self];
    [self.view addSubview:hud.view];
    
//    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"LOVETIPS"]) {
//        NSString *dataString = [[NSUserDefaults standardUserDefaults]objectForKey:@"LOVETIPS"];
//        NSArray *array = [JsonUtil jsonToArray:dataString];
//        [self.loveArray addObjectsFromArray:array];
//        //        NSLog(@"loveArray = %@",self.loveArray);
//        [self getLovetipsUpdate];
//    }else
//    {
//    if (week > 2)
//    {
//        week = week - 2;
//    }
//    else
//    {
//        week = 0;
//    }
    
    
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%d",week] forKey:@"selectWeek"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self getLoveTipsInfo:YES andWeek:week];
//    }
}

- (void)selectWeek:(UIButton *)sender
{

    int temp = sender.tag - 1991 + 2;
    NSString *timeString = @"备孕期";
    
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%d",temp] forKey:@"selectWeek"];
    if (temp == 2)
    {
        [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%d",0] forKey:@"selectWeek"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (temp > 2)
    {
        timeString = [NSString stringWithFormat:@"孕%d周",temp];
    }
    [((UILabel *)[rightView viewWithTag:1213]) setText:timeString];
    
    for (UIButton *weekButton in buttonArray)
    {
        if (sender == weekButton)
        {
            weekButton.selected = YES;
            [weekButton.layer setBorderColor:[UIColor colorwithHexString:@"#F0037F"].CGColor];
            [weekButton.layer setBorderWidth:1];
        }
        else
        {
            [weekButton.layer setBorderWidth:0];
            weekButton.selected = NO;
        }
        
    }
    
    
    [self getLoveTipsInfo:YES andWeek:temp];

    
}

-(void)showOrHideSelectView:(id)sender
{
    arrowButton.selected = !arrowButton.selected;
    selectView.hidden = !selectView.hidden;
    
    NSLog(@"helloworld");
}
#pragma mark - request love tips
- (void)getLoveTipsInfo:(BOOL)showActivity andWeek:(int)week
{
    if (showActivity) {
        [hud setCaption:@"加载中"];
        [hud setActivity:YES];
        [hud show];
    }
    
    
    NSString *type = @"1";
    dispatch_queue_t network;
    network = dispatch_queue_create("get_remain_info", nil);
    dispatch_async(network, ^{
        NSString *request = [HTTPRequest requestForGetWithPramas:[NSDictionary dictionaryWithObjectsAndKeys:type,@"type",[NSNumber numberWithInt:week],@"week",Nil]
                                                          method:@"get_remain_info"];
        
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        NSLog(@"dic=  %@",dictionary);
    

        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dictionary objectForKey:@"msg"]integerValue] == 1)
            {
                NSLog(@"dictioanry :%@",[dictionary description]);
                NSString *dataString = [dictionary objectForKey:@"data"];
                dataString = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
                dataString = [dataString URLDecodedString];
                NSArray *array = [JsonUtil jsonToArray:dataString];
                
                [self.loveArray removeAllObjects];
                
                [self.loveArray addObjectsFromArray:array];
                NSLog(@"LOVE= %@",self.loveArray);
                [self.myTableView reloadData];
                
                [[NSUserDefaults standardUserDefaults]setValue:dataString forKey:@"LOVETIPS"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [hud hideAfter:1.0f];
                
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

- (void)getLovetipsUpdate
{
    [hud setCaption:@"加载中"];
    [hud setActivity:YES];
    [hud show];
    NSString *type = @"2";
    NSLog(@"self.loveArray = %@",self.loveArray);
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"cate_id",type,@"type",[[[self.loveArray objectAtIndex:1] objectForKey:@"obj"][0] objectForKey:@"add_time"] ,@"visit_time", nil];
    dispatch_queue_t network;
    network = dispatch_queue_create("get_updated_info", nil);
    dispatch_async(network, ^{
        NSString *updateRequest=[HTTPRequest requestForGetWithPramas:param method:@"get_updated_info"];
        NSDictionary *json=[JsonUtil jsonToDic:updateRequest];
        NSLog(@"json = %@",json);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[json objectForKey:@"msg"] intValue] == 1) {
                [self.loveArray removeAllObjects];
//                [self getLoveTipsInfo:NO];
            }else
            {
                [hud hideAfter:1.0f];
                [self.myTableView reloadData];

                
            }
        });
    });
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.loveArray.count) {
        return [[[self.loveArray objectAtIndex:0]objectForKey:@"obj"] count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 37;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EACareRemindCell *cell = [[NSBundle mainBundle]loadNibNamed:@"EACareRemindCell" owner:self options:nil][0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row % 2) {
        cell.bgImageView.image = [UIImage imageNamed:@"row_type_2"];
    }

    
    if ([[[[self.loveArray objectAtIndex:0] objectForKey:@"obj"]objectAtIndex:indexPath.row] objectForKey:@"title"]!=[NSNull null]) {
        
        cell.titleLabel.text = [[[[self.loveArray objectAtIndex:indexPath.section] objectForKey:@"obj" ] objectAtIndex:indexPath.row] objectForKey:@"title"];
    }
    if ([[[[[self.loveArray objectAtIndex:0] objectForKey:@"obj"]objectAtIndex:indexPath.row] objectForKey:@"img_url"] isEqualToString:@"http://183.61.84.207:1234"])
    {
        cell.headPic.image = [UIImage imageNamed:@"icon"];
    }
    else
    {
        [cell.headPic setImageWithURL:[NSURL URLWithString:[[[[self.loveArray objectAtIndex:0] objectForKey:@"obj"]objectAtIndex:indexPath.row] objectForKey:@"img_url"]] placeholderImage:[UIImage imageNamed:@"icon"]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DailyDetailViewController *dailyDetailVC=[[DailyDetailViewController alloc]initWithDetail:[[[[self.loveArray objectAtIndex:indexPath.section] objectForKey:@"obj"] objectAtIndex:indexPath.row] objectForKey:@"id"]];
    
    NSNumber *number = [self.loveArray[indexPath.section] objectForKey:@"week"];
    int week = number.intValue;
    dailyDetailVC.section = week;
    
    int day = indexPath.row;
    
    if (week == 2)
    {
        if (day >= 20)
        {
            day = 20;
        }
    }
    else
    {
        if (day >= 6)
        {
            day = 6;
        }
    }
    dailyDetailVC.row = day;
    
    NSLog(@"id ---->%@",[[[[self.loveArray objectAtIndex:indexPath.section] objectForKey:@"obj"] objectAtIndex:indexPath.row] objectForKey:@"id"]);
    NSLog(@"begin================");
    NSLog(@"day---->%d", day);
    NSLog(@"end==================");
    NSLog(@"week----->%d",week);
    
    [self.navigationController pushViewController:dailyDetailVC animated:YES];
    [dailyDetailVC release];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
