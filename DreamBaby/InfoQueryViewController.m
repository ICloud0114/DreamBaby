//
//  InfoQueryViewController.m
//  DreamBaby
//
//  Created by easaa on 14-2-19.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "InfoQueryViewController.h"
#import "ATMHud.h"
#import "HTTPRequest.h"
#import "FBEncryptorDES.h"
#import "NSString+URLEncoding.h"
#import "JsonUtil.h"
#import "HospitalViewController.h"
#import "MoreControllerCell.h"
@interface InfoQueryViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    ATMHud *hud;
    UITableView *infoCheckTable;
}
@property (nonatomic ,retain) NSMutableArray *infoArray;
@end

@implementation InfoQueryViewController

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
    [hud release];
    RELEASE_SAFE(_infoArray);
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    self.navigationItem.title = @"信息查询";
    
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

    
    
    NSMutableArray *tempArray = [NSMutableArray array];
    self.infoArray = tempArray;
    //
    CGFloat version = [[[UIDevice currentDevice]systemVersion]floatValue];
    infoCheckTable = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, 300, self.view.frame.size.height-44-49 - 20) style:UITableViewStylePlain];
    
    infoCheckTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    if(version >= 7.0f)
    {
        infoCheckTable.frame = CGRectMake(10, 10, 300, self.view.frame.size.height- 44 - 49 - 20 - 20);
    }
    infoCheckTable.backgroundView = nil;
    infoCheckTable.showsHorizontalScrollIndicator = NO;
    infoCheckTable.showsVerticalScrollIndicator = NO;
    infoCheckTable.backgroundColor = [UIColor clearColor];
    infoCheckTable.bounces = NO;
    infoCheckTable.delegate = self;
    infoCheckTable.dataSource = self;
    [self.view addSubview:infoCheckTable];
    [infoCheckTable release];
    
    hud = [[ATMHud alloc]initWithDelegate:self];
    [self.view addSubview:hud.view];
    
    [self getInfoQueryRequest];
}


#pragma mark - request info query
- (void)getInfoQueryRequest
{
    [hud setCaption:@"加载中"];
    [hud setActivity:YES];
    [hud show];
    
    dispatch_queue_t network;
    network = dispatch_queue_create("get_msg_category_list", nil);
    dispatch_async(network, ^{
        NSString *request = [HTTPRequest requestForGetWithPramas:nil method:@"get_msg_category_list"];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dictionary objectForKey:@"msg"]integerValue] == 1)
            {
                
                NSString *dataString = [dictionary objectForKey:@"data"];
                dataString = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
                dataString = [dataString URLDecodedString];
                NSArray *array = [JsonUtil jsonToArray:dataString];
                [self.infoArray addObjectsFromArray:array];
                
                [infoCheckTable reloadData];
                
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

#pragma mark---TableVeiw methods
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *hideView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 5)] autorelease];
    hideView.backgroundColor = [UIColor clearColor];
    return hideView;
    
    

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == infoCheckTable)
    {
        if (self.infoArray)
        {
            return 1;
        }
    }
//    int num = 0;
//    if (section==0) {
//        num= 2;
//    }
//    else if(section==1)
//    {
//        num= 7;
//    }
//    else if(section==2)
//    {
//        num= 1;
//    }
//    return num;
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (tableView == infoCheckTable)
    {
        if (self.infoArray)
        {
            return self.infoArray.count;
        }
    }
    
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    return 35.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
//    
//    if(version<7.0f)
//    {
//        //tableView.separatorColor = [UIColor colorwithHexString:@"#d470a8"];
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    }
//    else{
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    }
    //static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [ tableView dequeueReusableCellWithIdentifier:nil];
    
    if (tableView==infoCheckTable)
    {
        static NSString *identifier = @"MoreControllerCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell =[[[NSBundle mainBundle]loadNibNamed:@"MoreControllerCell" owner:self options:nil]lastObject];
//            ((MoreControllerCell *)cell).moreArticalLabel.textColor = [UIColor blackColor];
//            ((MoreControllerCell *)cell).moreStateLabel.textColor = [UIColor blackColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundView = nil;
            cell.backgroundColor = [UIColor clearColor];
            
//            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
//            view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tongyong_arrow02"]];
//            cell.accessoryView = view ;
//            [view release];
            
            UIImageView *accessory = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"list_arrow"]];
            [accessory setFrame:CGRectMake(280, 10, 8, 12)];
            [cell addSubview: accessory];
            [accessory release];
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more_b"]]autorelease];
        }
        
        
        NSDictionary *dictionary = [self.infoArray objectAtIndex:indexPath.section];
        cell.textLabel.text = [dictionary objectForKey:@"title"];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
//        ((MoreControllerCell *)cell).textLabel.text = [dictionary objectForKey:@"title"];
//        ((MoreControllerCell *)cell).moreArticalLabel.hidden = YES;
//        ((MoreControllerCell *)cell).moreStateLabel.hidden = YES;
//        ((MoreControllerCell *)cell).moreAccessView.hidden = YES;
        
        
    }
  
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     
    NSDictionary *dictionary = [self.infoArray objectAtIndex:indexPath.section];
    
    HospitalViewController * zixunVC = [[[HospitalViewController alloc]init]autorelease];
    zixunVC.Id = [dictionary objectForKey:@"id"];
    zixunVC.infoArray = self.infoArray;
    [self.navigationController pushViewController:zixunVC animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
