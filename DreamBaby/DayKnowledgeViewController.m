//
//  DayKnowledgeViewController.m
//  DreamBaby
//
//  Created by easaa on 14-1-9.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "DayKnowledgeViewController.h"
#import "DayKnowledgeCell.h"
#import "JsonFactory.h"
#import "FBEncryptorDES.h"
#import "JsonUtil.h"
#import "HTTPRequest.h"
#import "NSString+URLEncoding.h"
#import "UIImageView+WebCache.h"
#import "KnowledgeDetailViewController.h"
#import "ATMHud.h"

@implementation NSCalendar (MyOtherMethod)

-(NSInteger) daysFromDate:(NSDate *) startDate toDate:(NSDate *) endDate {
    
    NSCalendarUnit units=NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *comp1=[self components:units fromDate:startDate];
    NSDateComponents *comp2=[self components:units fromDate: endDate];
    
    [comp1 setHour:12];
    [comp2 setHour:12];
    
    NSDate *date1=[self dateFromComponents: comp1];
    NSDate *date2=[self dateFromComponents: comp2];
    
    return [[self components:NSDayCalendarUnit fromDate:date1 toDate:date2 options:0] day];
}

@end
@interface DayKnowledgeViewController ()
{
    ATMHud *hud;
}
@end

@implementation DayKnowledgeViewController
- (void)dealloc
{
    
    RELEASE_SAFE(_huaiYunDate);
    RELEASE_SAFE(_beforeDate);
    initTag = NO;
    hud.delegate = nil;
    [hud release];
    [mTableView release];
    if (listArray)
    {
        [listArray release];
        listArray = nil;
    }
    [super dealloc];
}


- (void)viewDidUnload
{
  
    [super viewDidUnload];
}

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
    initTag = YES;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    self.navigationItem.title = @"每日知识";
    
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
       
    mTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44-49) style:UITableViewStylePlain];
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        [mTableView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 44 - 49 - 20)];
        
    }
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.backgroundView = nil;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.delegate=self;
    mTableView.dataSource=self;
    [self.view addSubview:mTableView];
    [mTableView release];
    listArray=[[NSMutableArray alloc]init];
    
    hud = [[ATMHud alloc]initWithDelegate:self];
    [self.view addSubview:hud.view];
    
   
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"EveryDayJson1"]] != nil)
    {
        //判断如过有更新重新请求数据
        [hud setCaption:@"加载中"];
        [hud setActivity:YES];
        [hud show];
        NSString *jsonStr=[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"EveryDayJson1"]];
        NSArray *tempArray = [JsonUtil jsonToArray:jsonStr];
        [listArray setArray:tempArray];
//        NSLog(@"list =%@ ",listArray);
        [self rangeResultList:listArray];
        [self performSelectorInBackground:@selector(getRequetForUpdatedInfo) withObject:nil];
    }else
    {
        [hud setCaption:@"加载中"];
        [hud setActivity:YES];
        [hud show];
        
        [NSThread detachNewThreadSelector:@selector(getRequestForListTableView) toTarget:self withObject:nil];

    }

}
#pragma mark--更新判断 是否重新请求数据
-(void)getRequetForUpdatedInfo
{
    NSString *jsonStr=[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"EveryDayJson1"]];
    NSArray *tempArray = [JsonUtil jsonToArray:jsonStr];
    NSLog(@"temp = %@",tempArray);
  
    NSDictionary *sendDic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"cate_id",@"1",@"type",[[[tempArray objectAtIndex:0]  objectForKey:@"obj"]objectForKey:@"addtime"],@"visit_time",nil];

    NSString *reuquest=[HTTPRequest requestForGetWithPramas:sendDic method:@"get_updated_info"];
    if (reuquest.length == 0 || reuquest == nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
        [hud hideAfter:1.0f];
    });
        return;
    }
    
    NSDictionary *json=[JsonUtil jsonToDic:reuquest];
    NSLog(@"%@",json);
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[json objectForKey:@"msg"] boolValue])
        {
         
            [listArray removeAllObjects];
            [hud hideAfter:1.0f];
            [self getRequestForListTableView];
        }else
        {
            [hud hideAfter:1.0f];
            [mTableView reloadData];
            [self performSelectorOnMainThread:@selector(scrollToListTable) withObject:nil waitUntilDone:NO];
        }
    });
    
}
//请求数据
-(void)getRequestForListTableView
{
    NSDictionary *sendDic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"type", nil];
    NSString *paramsJson = [JsonFactory dictoryToJsonStr:sendDic];
    paramsJson = [[FBEncryptorDES encrypt:paramsJson
                                keyString:@"SDFL#)@F"] uppercaseString];
    NSString *signs= [NSString stringWithFormat:@"SDFL#)@FMethod%@Params%@SDFL#)@F",@"get_everyday_info",paramsJson];
    signs = [[FBEncryptorDES md5:signs] uppercaseString];
    NSString *requestStr = [NSString stringWithFormat:BABYAPI,@"get_everyday_info",paramsJson,signs];
    NSLog(@"request %@",requestStr);
    NSString *ajson = [HTTPRequest requestForGet:requestStr];
//    NSLog(@"ajson = %@",ajson);
    if (ajson.length == 0 || ajson == nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAfter:1.0f];
        });
            return;
    }
    [self performSelectorOnMainThread:@selector(decrypt:) withObject:ajson waitUntilDone:NO];
}

#pragma mark  - 解密
- (void)decrypt:(NSString *)string
{
    NSString * ajson = [FBEncryptorDES decrypt:string keyString:@"SDFL#)@F"];
    ajson = [ajson URLDecodedString];
    NSData *data = [ajson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *json =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    //    NSDictionary *json=[JsonUtil jsonToDic:ajson];
//    ChangeDate *change=[ChangeDate instance];
    [hud hideAfter:1.0f];
    
    //列表数据
    if ([[json objectForKey:@"msg"] boolValue]) {
        NSString *listJson = [FBEncryptorDES decrypt:[json objectForKey:@"data"]  keyString:@"SDFL#)@F"];
        listJson = [listJson URLDecodedString];
        NSData *adata = [listJson dataUsingEncoding:NSUTF8StringEncoding];
        //zy memory warning
        NSArray *tempJson =  [NSJSONSerialization JSONObjectWithData:adata options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"tempjson = %@",tempJson);
        [self rangeResultList:tempJson];
        

        [mTableView reloadData];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:listJson forKey:[NSString stringWithFormat:@"EveryDayJson1"]];
        [defaults synchronize];
        //        NSLog(@"---%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"everyday"]);

        [self performSelectorOnMainThread:@selector(scrollToListTable) withObject:nil waitUntilDone:NO];
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
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"获取数据失败,可能是你的网络不给力!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [av show];
            RELEASE_SAFE(av);
        }
    }
}


- (void)rangeResultList:(NSArray *)array
{
    NSMutableArray *tempArray = [NSMutableArray array];
    [tempArray addObjectsFromArray:array];
    
//    NSSortDescriptor* desc = [[NSSortDescriptor alloc] initWithKey:@"time_range" ascending:YES selector:@selector(compare:)];
//    [tempArray sortUsingDescriptors:[NSArray arrayWithObject:desc]];
//    [desc release];
    
    NSMutableArray *elementArray = [NSMutableArray array];
    int intChange = -100;
    for (NSDictionary *dic in array)
    {
        NSNumber *time_range = [dic objectForKey:@"week"];
        
        int int_time = time_range.intValue;
        
        if (int_time != intChange)
        {
            intChange = int_time;
            NSMutableArray *sortedArray = [[[NSMutableArray alloc]init] autorelease];
            [elementArray addObject:sortedArray];
//            NSLog(@"sorted = %@",sortedArray);
//            NSLog(@"elementArray = %@",elementArray);
            [sortedArray removeAllObjects];
            [sortedArray addObject:dic];
        }else
        {
            [[elementArray lastObject] addObject:dic];
        }
    }
    [listArray setArray:elementArray];

}

- (NSString *)getOnlyNum:(NSString *)str
{
    
    NSString *onlyNumStr = [str stringByReplacingOccurrencesOfString:@"[^0-9,]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [str length])];
    NSArray *numArr = [onlyNumStr componentsSeparatedByString:@","];
    return [numArr firstObject];
}

#pragma mark-根据日期判断tableview滚动位置
-(void)scrollToListTable
{
   // ;
    NSDate * putDate =  [[NSUserDefaults standardUserDefaults]objectForKey:ProductionDate];
    
    //从现在开始到预产期还有多少天   212
    if ([putDate compare:[NSDate date]]>0) {
//        NSDate * putDate =  [[NSUserDefaults standardUserDefaults]objectForKey:ProductionDate];
        //从现在开始到预产期还有多少天   212
        int days=[self _getTime:putDate];
        [self calculateAllDay];
        days = 280 - days;
        int whichWeak = 0;

//        if (days > 0)
//        {
////            days = days - ((NSArray *)listArray[0]).count;
//            if (days<0) {
//                whichWeak = 0;
//            }else{
//                    whichWeak = days/7;
//            }
//        }
        if (days > 0)
        {
            whichWeak = days / 7 - 2;
            
        }
        if (whichWeak < 0)
        {
            whichWeak = 0;
        }
        else
        {
//            if ((days + 1) % 7 == 0)
//            {
//                whichWeak += 1;
//            }
        }
        NSLog(@"wichWeak =%d",whichWeak);
        if (whichWeak != 0)
        {
            whichWeak += 2;
        }
        int location = 0;
        for (NSArray *arr in listArray)
        {
            NSDictionary *dic = [arr firstObject];
            if ([[dic objectForKey:@"week"]intValue] == whichWeak)
            {
                if (arr.count > days % 7)
                {
                    [mTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:days % 7 inSection:location] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    break;

                }
                else
                {
                    [mTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:location] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    break;
                }
                
            }
            location ++;
        }
//        if ([[listArray objectAtIndex:whichWeak] isKindOfClass:[NSArray class]])
//        {
//            NSArray *weekArray = [listArray objectAtIndex:whichWeak];
//            NSDictionary *weekDictionary = [weekArray firstObject];
//            
//            if ([[weekDictionary objectForKey:@"week"]intValue] == whichWeak + 2 || [[weekDictionary objectForKey:@"week"]intValue] == 0)
//            {
//                if (weekArray.count >= days % 7)
//                {
//                    [mTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:days % 7 inSection:whichWeak] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//                }
//                else
//                {
//                    [mTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:whichWeak] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//                }
//            }
//            
//        }
//         NSDictionary *dictionary = [listArray objectAtIndex:section][0];
        
        

    }
}

- (int)_getTime:(NSDate *)lastOnlineTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *nowStr = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *nowDate = [dateFormatter dateFromString:nowStr];
    NSTimeInterval time=[lastOnlineTime timeIntervalSinceDate:nowDate];
    int days=((int)time)/(3600*24);
    [dateFormatter release];
    NSLog(@"days= %d",days);
    return days;
}
//返回距离今日间隔日期的日历
- (NSDateComponents *)timerChuFaWithNSDateComponents:(NSDate *)components
{
    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    //    NSDate *todate = [cal dateFromComponents:components];//把目标时间装载入date
    NSDate *today = [NSDate date];//得到当前时间
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit|kCFCalendarUnitWeekday|NSWeekCalendarUnit | kCFCalendarUnitWeekday;
    NSDateComponents *d = [cal components:unitFlags fromDate:components toDate:today options:0];
    NSString * str = [NSString stringWithFormat:@"%d年%d月%d日%d时%d分%d秒%d周 %d星期几",[d year],[d month], [d day], [d hour], [d minute], [d second],[d week],[d weekday]];
    NSLog(@"%@",str);
    return [[d retain]autorelease];
}

//计算孕妇所有天数
- (void) calculateAllDay
{
    if (listArray != nil && listArray.count > 0)
    {
        allDay = 0;
        for (NSArray *ary in listArray)
        {
            allDay += ary.count;
        }
    }
}

//计算怀孕日期
- (NSDate *) calculateHuaiYuanDate
{
    [self calculateAllDay];
    
    NSDate *yuanChanDate = [[NSUserDefaults standardUserDefaults]objectForKey:ProductionDate];

    NSDate *huaiYunDate = [NSDate dateWithTimeIntervalSince1970:([yuanChanDate timeIntervalSince1970] - (allDay*24*60*60))];

    return huaiYunDate;
}
- (NSDate *) calculateHuaiYuanDate:(int )section
{
    
    //返回该周的具体时间数据
    NSDate *yuanChanDate = [[NSUserDefaults standardUserDefaults]objectForKey:ProductionDate];

    NSDate *huaiYunDate = [NSDate dateWithTimeIntervalSince1970:([yuanChanDate timeIntervalSince1970] - ((280-section * 7)*24*60*60))];
    //    NSLog(@"section== %d",self.section);
    //    NSLog(@"huai = %@", huaiYunDate);
    return huaiYunDate;
}

//计算日期
- (void)caclulateDate
{
    if (initTag)
    {
        initTag = NO;
        self.huaiYunDate = [self calculateHuaiYuanDate];
        self.beforeDate = self.huaiYunDate;
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:listArray.count];
        for (int index = 0; index < listArray.count; ++index)
        {
            NSMutableArray *mAry = [[NSMutableArray alloc] init];
            NSArray *ary = [listArray objectAtIndex:index];
            for (NSDictionary *dic in ary)
            {
                NSMutableDictionary *mDic = [dic mutableCopy];
//                [dic release];
                self.beforeDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:self.beforeDate];
                
                //                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                //                [dateFormatter setDateFormat:@"MM/dd/yyyy"];
                [mDic setObject:self.beforeDate forKey:@"myDate"];
//                NSLog(@"beforedate = %@", self.beforeDate);
                //                [dateFormatter release];
                [mAry addObject:mDic];
                [mDic release];
            }
            [temp addObject:mAry];
            //[listArray replaceObjectAtIndex:index withObject:mAry];
            [mAry release], mAry = nil;
        }
        if (listArray)
        {
            [listArray release], listArray = nil, listArray = [temp mutableCopy];
        }
        //        NSLog(@"%@", temp);
    }
}

#pragma mark -----TableViewDeklegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 35)];
    
    
    UIImageView * shuruBG = [[UIImageView alloc]initWithFrame:CGRectMake(320 - 67, 2, 67, 29)];
    shuruBG.image = [UIImage imageNamed:@"zhouqi"];
    [view addSubview:shuruBG];
    [shuruBG release];
    
    //专家介绍
    UILabel* jieshaoLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 50, 15)];
    //----------lemon 改
//    NSArray *array = [listArray objectAtIndex:section];
    
//    NSDictionary *dictionary = [array firstObject];
    NSDictionary *dictionary = [listArray objectAtIndex:section][0];
//    NSNumber *time_range = [[NSUserDefaults standardUserDefaults]objectForKey:@"week"];
//    NSString *time_range = [[dictionary objectForKey:@"obj"] objectForKey:@"time_range"];
    
//    NSLog(@"time_range :%d",[time_range intValue]);
    
//    int week = time_range.intValue;
    int week = [[dictionary objectForKey:@"week"]intValue];
    if (week == 0)
    {
         jieshaoLabel.text=[NSString stringWithFormat:@"备孕期"];
    } else
    {
        jieshaoLabel.text=[NSString stringWithFormat:@"孕%d周",week];
    }
    
//    if (section == 0)
//    {
//        jieshaoLabel.text=[NSString stringWithFormat:@"备孕期"];
//
//    }else
//    {
//        jieshaoLabel.text=[NSString stringWithFormat:@"孕%d周",section + 2];
//    }
    jieshaoLabel.font = [UIFont boldSystemFontOfSize:14];
    jieshaoLabel.backgroundColor = [UIColor clearColor];
    jieshaoLabel.textColor =[UIColor whiteColor];
    jieshaoLabel.textAlignment = NSTextAlignmentLeft;
    [shuruBG addSubview:jieshaoLabel];
    [jieshaoLabel release];
    
    return  [view autorelease];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (listArray)
    {
        return listArray.count;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (listArray) {
//        NSLog(@"COUnt = %d",[[listArray objectAtIndex:section] count]);
        return [[listArray objectAtIndex:section] count];
    }
    return 0;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([flagType isEqualToString:@"002"]) {
        return 145;
    }
    return 330.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self caclulateDate];
    NSString * idetifer = @"dayKnowledge";
    DayKnowledgeCell  * cell = [tableView dequeueReusableCellWithIdentifier:idetifer ];
    if (cell==nil)
    {
        if ([flagType isEqualToString:@"001"]) {
            cell =[[[NSBundle mainBundle]loadNibNamed:@"DayKnowledgeCell" owner:self options:nil]objectAtIndex:0];
        }
        else
        {
            cell =[[[NSBundle mainBundle]loadNibNamed:@"DayKnowledgeCell" owner:self options:nil]objectAtIndex:1];
        }
            //---------------lemon 改
        NSArray *array = [listArray objectAtIndex:indexPath.section];
        NSDictionary *dictionary = [[array objectAtIndex:indexPath.row]objectForKey:@"obj"];
        NSString *strImageUrl = [dictionary objectForKey:@"imgurl"];
        [cell.IconImage setImage:[UIImage imageNamed:@"icon"]];
        if ([strImageUrl isKindOfClass:[NSString class]])
        {
            if ([strImageUrl length] > 0)
            {
                [cell.IconImage setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"icon"]];
            }
        }
        
        
        cell.ContentLabel.text = [dictionary objectForKey:@"zhaiyao"];
        cell.TilLabel.text = [dictionary objectForKey:@"title"];
        
        
        static BOOL initFlag = YES;
        if (initFlag)
        {
            initFlag = NO;
            self.huaiYunDate = [self calculateHuaiYuanDate];
            self.beforeDate = self.huaiYunDate;
        }
        NSArray *dateArray = [listArray objectAtIndex:indexPath.section];
        
        NSDictionary *dateDictionary = [dateArray firstObject];
        //NSDictionary *dictionary = [listArray objectAtIndex:section];
        NSNumber *time_range = [dateDictionary objectForKey:@"week"];
        //            NSDate *date = [dictionary objectForKey:@"myDate"];
        NSDate *date = [self calculateHuaiYuanDate:time_range.intValue];
        int indexRow = indexPath.row;
        if (indexRow > 6)
        {
            indexRow = 6;
        }
        //到具体天的时间
        date= [NSDate dateWithTimeInterval:(24 * 60 * 60 * indexRow) sinceDate:date];
        NSString *day = [self dayFromDate:date];
        NSString *month = [self monthFromDate:date];
        
        NSString *week = [self weekFromDate:date];
        int currntDay = day.intValue;
        cell.Daylabel.text = [NSString stringWithFormat:@"%@月%d日",month,currntDay];
        cell.WeekLabel.text = week;
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}
//返回当前日期的日历
- (NSDateComponents *)ReturnNSDateComponents:(NSDate *)components{
    //    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendar *calendar = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    
    unsigned int unitFlags =  NSYearCalendarUnit | NSMonthCalendarUnit| NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit| NSWeekCalendarUnit | kCFCalendarUnitWeekday;
    
    NSDateComponents *dateComponets = [calendar components:unitFlags fromDate:components];
    return dateComponets;
}

//CG_INLINE BOOL arrayIsEmpty(NSArray *array) {
//    if([array isKindOfClass:[NSNull class]]){
//        return YES;
//    }
//    if(array && [array count] > 0){
//        return NO;
//    }
//    return YES;
//}
//CG_INLINE BOOL stringIsEmpty(NSString *string) {
//    if([string isKindOfClass:[NSNull class]]){
//        return YES;
//    }
//    if (string==nil) {
//        return YES;
//    }
//    NSString *text = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    if ([text length] == 0) {
//        return YES;
//    }
//    return NO;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([flagType isEqualToString:@"002"]) {

        if ([[[[listArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"obj"] objectForKey:@"id"]) {
            int week =  [[[listArray objectAtIndex:indexPath.section][0] objectForKey:@"week"] intValue];
            
                DayKnowledgeCell *cell=(DayKnowledgeCell*)[tableView cellForRowAtIndexPath:indexPath];
                KnowledgeDetailViewController *dailyDetailVC=[[KnowledgeDetailViewController alloc]initWithDetail:
                                                              [[[[listArray objectAtIndex:indexPath.section]
                                                                  objectAtIndex:indexPath.row] objectForKey:@"obj"]
                                                                 objectForKey:@"id"]
                                                                                                             Week:week Weekday:cell.WeekLabel.text
                                                                                                             Date:cell.Daylabel.text
                                                                                                            Title:cell.TilLabel.text
                                                                                                            Image:cell.IconImage.image];
                [self.navigationController pushViewController:dailyDetailVC animated:YES];
                [dailyDetailVC release];
        }else
        {
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"没有该文章" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [av show];
            RELEASE_SAFE(av);
        }

        }
    
}


- (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"MM/dd/yyyy HH:mm:ss"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    [dateFormatter release];
    
    return destDate;
    
}

- (NSString *)monthFromDate:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit;
    NSDateComponents *dd = [cal components:unitFlags fromDate:date];
    return [NSString stringWithFormat:@"%ld", (long)[dd month]];
    
}

- (NSString *)dayFromDate:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit;
    NSDateComponents *dd = [cal components:unitFlags fromDate:date];
    return [NSString stringWithFormat:@"%ld", (long)[dd day]];
}


- (NSString *)weekFromDate:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSCalendarUnitWeekday;
    NSDateComponents *dd = [cal components:unitFlags fromDate:date];
    NSString *week = @"";
    switch ([dd weekday] - 1) {
        case 0:
            week = @"星期日";
            break;
        case 1:
            week = @"星期一";
            break;
        case 2:
            week = @"星期二";
            break;
        case 3:
            week = @"星期三";
            break;
        case 4:
            week = @"星期四";
            break;
        case 5:
            week = @"星期五";
            break;
        case 6:
            week = @"星期六";
            break;
        default:
            break;
    }
    return week;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
