//
//  MemberRegController.m
//  DreamBaby
//
//  Created by easaa on 14-1-7.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "MemberRegController.h"

@interface MemberRegController ()

@end


@implementation MemberRegController

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
    
    self.navigationItem.title = @"会员注册";
    
    
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
    
    
   
    //
    nichengText = [[CustomTextField alloc] initWithFrame:CGRectMake(90, 13, 200, 25)];
    nichengText.font = [UIFont systemFontOfSize:13];
    nichengText.textColor =  [UIColor colorwithHexString:@"#f9d5c3"];
    nichengText.backgroundColor = [UIColor clearColor];
    nichengText.placeholder = @"包括英文及数字";
    //
    mimaText = [[CustomTextField alloc] initWithFrame:CGRectMake(90, 13, 200, 25)];
    mimaText.font = [UIFont systemFontOfSize:13];
    mimaText.textColor =  [UIColor colorwithHexString:@"#f9d5c3"];
    mimaText.backgroundColor = [UIColor clearColor];
    mimaText.placeholder = @"字母及数字，长度不超过6位";
    mimaText.secureTextEntry = YES;
    //
    sfzText = [[CustomTextField alloc] initWithFrame:CGRectMake(115, 13, 200, 25)];
    sfzText.font = [UIFont systemFontOfSize:13];
    sfzText.textColor =  [UIColor colorwithHexString:@"#f9d5c3"];
    sfzText.backgroundColor = [UIColor clearColor];
    sfzText.placeholder = @"";
    //
    hujiText = [[CustomTextField alloc] initWithFrame:CGRectMake(110, 13, 200, 25)];
    hujiText.font = [UIFont systemFontOfSize:13];
    hujiText.textColor =  [UIColor colorwithHexString:@"#f9d5c3"];
    hujiText.backgroundColor = [UIColor clearColor];
    hujiText.delegate = self;
    hujiText.placeholder=@"";
  
    //
    phoneText = [[CustomTextField alloc] initWithFrame:CGRectMake(80, 8, 120, 30)];
    phoneText.font = [UIFont systemFontOfSize:13];
    phoneText.textColor =  [UIColor colorwithHexString:@"#f9d5c3"];
    //phoneText.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"tongyong_shurukuang"] stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
    phoneText.background =[[UIImage imageNamed:@"tongyong_shurukuang"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    phoneText.delegate = self;
    phoneText.placeholder=@"";
    
    //
    yanZhengText = [[CustomTextField alloc] initWithFrame:CGRectMake(90, 13, 200, 25)];
    yanZhengText.font = [UIFont systemFontOfSize:13];
    yanZhengText.textColor =  [UIColor colorwithHexString:@"#f9d5c3"];
    yanZhengText.backgroundColor = [UIColor clearColor];
    yanZhengText.placeholder = @"";

    
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    memberTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44-49) style:UITableViewStyleGrouped];
    if(version>=7.0f){
        memberTable.frame = CGRectMake(10, 0, 300, self.view.frame.size.height-44-49);
    }
    
    
    //memberTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44-49) style:UITableViewStyleGrouped];
    memberTable.backgroundView = nil;
    memberTable.backgroundColor = [UIColor clearColor];
    memberTable.delegate = self;
    memberTable.dataSource = self;
    [self.view addSubview:memberTable];
    [memberTable release];

}

#pragma mark
#pragma ProductTable methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int num = 0;
    if (section==0) {
        num= 1;
    }
    else if(section==1)
    {
        num= 7;
    }
   
    return num;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    
    if(version<7.0f){
        tableView.separatorColor = [UIColor colorwithHexString:@"#d470a8"];
    }else{
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    //tableView.separatorColor = [UIColor colorwithHexString:@"#d470a8"];
    int index = indexPath.row;
    int section=[indexPath section];
    
//    NSString *SimpleTableIdentifier = @"memberCell";
//    if (section == 0)
//    {
//        SimpleTableIdentifier = @"section";
//    }
    
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        cell =[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor clearColor];
    }
    //IsLogIn * islog = [IsLogIn instance];
    
    switch (section) {
        case 0:
            switch (index) {
                case 0:
                {
                    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"zhishi_kuang_bg"]];
                    if ([cell viewWithTag:1213] == nil)
                    {
                        
                        UIImageView * ivBG = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 62, 62)];
                        ivBG.userInteractionEnabled = YES;
                        ivBG.image = [UIImage imageNamed:@"huiyuan_touxiang_pic_bg"];
                        [cell addSubview:ivBG];
                        [ivBG release];
                        
                        UIImageView * photoImage = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 58, 58)];
                        photoImage.userInteractionEnabled = YES;
                        photoImage.image = [UIImage imageNamed:@"icon"];
                        [ivBG addSubview:photoImage];
                        [photoImage release];
                        
                        
                        //                        iconIV = [[UIImageView alloc]initWithFrame:CGRectMake(20, 2, 75, 75)];
                        //                        iconIV.image = [UIImage imageNamed:@"huiyuan_touxiang_pic_moren"];
                        //                        [cell addSubview:iconIV];
                        //                        [iconIV release];
                        //                        [iconIV setTag:1213];
                        // NSLog(@"islog.memberData.avatar=====%@",islog.memberData.avatar);
                        
                        //                        UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageSelect:)];
                        //                        tap.numberOfTouchesRequired = 1;    //触摸点个数
                        //                        tap.numberOfTapsRequired = 1;    //点击次数
                        //                        [iconIV addGestureRecognizer:tap];
                        //                        iconIV.userInteractionEnabled = YES;
                        //                        [tap release];
                        
                    }else{
                        //                        UIImageView * iv = (UIImageView *)[cell viewWithTag:1213] ;
                        //                        [iv setImageWithURL:[NSURL URLWithString:islog.memberData.avatar]];
                    }
                    
                    if ([cell viewWithTag:814] == nil)
                    {
                        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(120, 30, 80, 20)];
                        label.font = [UIFont systemFontOfSize:14];
                        label.backgroundColor = [UIColor clearColor];
                        label.text = @"上传头像";
                        label.textColor = [UIColor colorwithHexString:@"#8c8c8c"];
                        [cell addSubview:label];
                        [label release];
                        [label setTag:814];
                    }
                    
                    cell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                    UIImageView * iv0 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
                    cell.editingAccessoryView = iv0;
                    [iv0 release];
                }
                    break;
            }
            break;
        case 1:
            switch (index) {
                    cell.backgroundColor = [UIColor clearColor];
                case 0:
                    if (0) {
                        cell.textLabel.text = [NSString stringWithFormat:@"昵      称:%@",@"xiaomin"];
                    }else{
                        cell.textLabel.text = @"昵      称:";
                        [cell addSubview:nichengText];
                    }
                    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xinxi_list_shang_bg"]]autorelease];
                    cell.textLabel.font =[UIFont systemFontOfSize:16];
                    break;
                case 1:
                    if (0) {
                        cell.textLabel.text =[NSString stringWithFormat: @"密      码:%@",@"xiaomin"];
                    }else{
                        cell.textLabel.text = @"密      码:";
                        [cell addSubview:mimaText];
                    }
                    cell.textLabel.font =[UIFont systemFontOfSize:16];
                    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tongyong_list_bg02"]]autorelease];
                    break;
                case 2:
                    if (0) {
                        cell.textLabel.text =[NSString stringWithFormat: @"身份证前6位:%@",@"54545454545"];
                    }else{
                        cell.textLabel.text = @"身份证前6位:";
                        [cell addSubview:sfzText];
                    }
                    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tongyong_list_bg02"]]autorelease];
                    cell.textLabel.font =[UIFont systemFontOfSize:16];
                    break;
                case 3:
                    if (0) {
                        cell.textLabel.text =[NSString stringWithFormat: @"户籍所在地:%@",@"545454@qq.coom"];
                    }else{
                        cell.textLabel.text = @"户籍所在地:";
                        [cell addSubview:hujiText];
                    }
                    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tongyong_list_bg02"]]autorelease];
                    cell.textLabel.font =[UIFont systemFontOfSize:16];
                    break;
                    
                case 4:
                    if (0) {
                        NSString * str = [self changToDate:@"24545-545-144"];
                        cell.textLabel.text =[NSString stringWithFormat: @"现住址:%@",str];
                    }else{
                        cell.textLabel.text = @"现住址:";
                        
                        arrow1Btn=[UIButton buttonWithType:UIButtonTypeCustom];
                        arrow1Btn.frame=CGRectMake(80, 8, 40, 30);
                        [arrow1Btn setBackgroundImage:[UIImage imageNamed:@"tongyong_shurukuang"] forState:UIControlStateNormal];
                        [arrow1Btn addTarget:self action:@selector(getYanzhengma) forControlEvents:UIControlEventTouchUpInside];
                        [cell addSubview:arrow1Btn];
                        
                        
                        UILabel* shengLabel = [[UILabel alloc]initWithFrame:CGRectMake(125, 12, 20, 20)];
                        shengLabel.text= @"省";
                        shengLabel.font = [UIFont boldSystemFontOfSize:16];
                        shengLabel.backgroundColor = [UIColor clearColor];
                        shengLabel.textColor = [UIColor blackColor];
                        shengLabel.textAlignment = NSTextAlignmentCenter;
                        [cell addSubview:shengLabel];
                        [shengLabel release];
                        
                        arrow2Btn=[UIButton buttonWithType:UIButtonTypeCustom];
                        arrow2Btn.frame=CGRectMake(150, 8, 40, 30);
                        [arrow2Btn setBackgroundImage:[UIImage imageNamed:@"tongyong_shurukuang"] forState:UIControlStateNormal];
                        [arrow2Btn addTarget:self action:@selector(getYanzhengma) forControlEvents:UIControlEventTouchUpInside];
                        [cell addSubview:arrow2Btn];
                        
                        UILabel* quLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 12, 20, 20)];
                        quLabel.text= @"区";
                        quLabel.font = [UIFont boldSystemFontOfSize:16];
                        quLabel.backgroundColor = [UIColor clearColor];
                        quLabel.textColor = [UIColor blackColor];
                        quLabel.textAlignment = NSTextAlignmentCenter;
                        [cell addSubview:quLabel];
                        [quLabel release];
                        
                        arrow3Btn=[UIButton buttonWithType:UIButtonTypeCustom];
                        arrow3Btn.frame=CGRectMake(225, 8, 70, 30);
                        [arrow3Btn setBackgroundImage:[[UIImage imageNamed:@"tongyong_shurukuang"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
                        [arrow3Btn addTarget:self action:@selector(getYanzhengma) forControlEvents:UIControlEventTouchUpInside];
                        [cell addSubview:arrow3Btn];
                    }
                    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tongyong_list_bg02"]]autorelease];
                    cell.textLabel.font =[UIFont systemFontOfSize:16];
                    break;
                case 5:
                    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tongyong_list_bg02"]]autorelease];
                    cell.textLabel.text = @"手机:";
                    cell.textLabel.font =[UIFont systemFontOfSize:16];
                    cell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                    UIImageView * iv1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
                    cell.editingAccessoryView = iv1;
                    [iv1 release];
                    [cell addSubview:phoneText];
                    
                    yanZhengBtn=[UIButton buttonWithType:UIButtonTypeCustom];
                    yanZhengBtn.frame=CGRectMake(205, 8, 90, 30);
                    [yanZhengBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                    yanZhengBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                    [yanZhengBtn setBackgroundImage:[UIImage imageNamed:@"tongyong_btn"] forState:UIControlStateNormal];
                    [yanZhengBtn setBackgroundImage:[UIImage imageNamed:@"tongyong_btn_h"] forState:UIControlStateHighlighted];
                    [yanZhengBtn addTarget:self action:@selector(getYanzhengma) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:yanZhengBtn];
                    
                    
                    break;
                    
                case 6:
                    if (0) {
                        cell.textLabel.text =[NSString stringWithFormat: @"验证码:%@",@"242542"];
                    }else{
                        cell.textLabel.text = @"验证码:";
                        [cell addSubview:yanZhengText];
                    }
                    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xinxi_list_xia_bg"]]autorelease];
                    cell.textLabel.font =[UIFont systemFontOfSize:16];
                    cell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                    UIImageView * iv2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
                    cell.editingAccessoryView = iv2;
                    [iv2 release];
                    
                    break;
                
                    
                    
            }
            break;
        case 2:
            switch (index) {
                    
                case 0:
                    //                    cell.backgroundView = nil;
                    //                    cell.backgroundColor = [UIColor clearColor];
                    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"zhishi_kuang_bg"]];
                    //cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"zhishi_kuang_bg"]];
                    cell.textLabel.text = @"请输入详细地址";
                    cell.textLabel.font =[UIFont systemFontOfSize:16];
                    break;
                    
                    
            }
            break;
            
        default:
            break;
    }
    return cell;
    
}
- (void)getYanzhengma
{
    
}
- (NSString *)changToDate:(NSString *)longStr
{
    
    NSRange left = [longStr rangeOfString:@"("];
    NSRange right = [longStr rangeOfString:@")"];
    NSRange range  = {left.location+1,right.location - left.location-1};
    NSString *temp = [longStr substringWithRange:range];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[temp longLongValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd"];
    NSTimeZone* timeZone = [NSTimeZone systemTimeZone];
    [formatter setTimeZone:timeZone];
    NSString * dateStr= [[NSString alloc]initWithString:[formatter stringFromDate:date]] ;
    [formatter release];
    return [dateStr autorelease];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0 && indexPath.row ==0) {
        return 95;
    }
    return 45;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    //    if (cell.editingAccessoryView) {
    //        cell.editingAccessoryView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_h"]] autorelease];
    //    }
    int index = indexPath.row;
    int section=[indexPath section];
    switch (section) {
        case 0:
            switch (index) {
                case 0:
                {
                    
                }
                    break;
            }
            break;
        case 1:
            switch (index) {
                case 0:
                    break;
                case 1:
                    break;
                case 2:
                    
                    break;
                case 3:
                    
                    break;
                    
                case 4:
                    
                    break;
                case 5:
                    
                {
                    //                    UpdatePassController * upDateVc = [[UpdatePassController alloc]init];
                    //                    [self.navigationController pushViewController:upDateVc animated:YES];
                    //                    [upDateVc release];
                }
                    
                    break;
                    
                case 6:
                    
                    
                    break;
                case 7:
                    
                    
                    
                    break;
                    
            }
            break;
        case 2:
            switch (index) {
                case 0:
                    
                    
                    break;
                    
                    
            }
            break;
            
        default:
            break;
    }
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
