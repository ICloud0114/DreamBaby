//
//  IsLogIn.m
//  GoodMom
//
//  Created by 李东辉 on 13-8-8.
//  Copyright (c) 2013年 easaa. All rights reserved.
//

#import "IsLogIn.h"

@implementation IsLogIn
@synthesize memberData,isLogIn;
@synthesize cityArray;

+(IsLogIn *)instance
{
    static IsLogIn * s_IsLogIn = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_IsLogIn = [[IsLogIn alloc]init];
    });
    return s_IsLogIn;
}
//在已经登录的情况下再次获取数据
//- (void)getmemberInfo
//{
//    NSDictionary *sendDic=[NSDictionary dictionaryWithObjectsAndKeys:self.memberData.idString,@"user_id",nil];
//    NSString *reuquest=[HTTPRequest requestForGetWithPramas:sendDic method:@"user_info"];
//    NSLog(@"reuquest==%@",reuquest);
//    NSDictionary *json=[JsonUtil jsonToDic:reuquest];
//    //if ([[json objectForKey:@"msg"] boolValue]) {
//    NSString *listJson = [FBEncryptorDES decrypt:[json objectForKey:@"data"]  keyString:@"SDFL#)@F"];
//    listJson = [listJson URLDecodedString];
//    
//    
//    NSMutableDictionary *dic=[listJson objectFromJSONString];
//    
//    MemberEntiy * memEty = [[MemberEntiy alloc]init];
//    
//    memEty.idString = [dic objectForKey:@"id"];
//    memEty.user_name = [dic objectForKey:@"user_name"];
//    memEty.mobileNum = [dic objectForKey:@"mobile"];
//    memEty.nick_name = [dic objectForKey:@"nick_name"];
//    memEty.email = [dic objectForKey:@"email"];
//    memEty.birthday = [dic objectForKey:@"child_birth"];
//    memEty.area = [dic objectForKey:@"area"];
//    memEty.rows = [dic objectForKey:@"rows"];
//    memEty.address  = [dic objectForKey:@"address"];
//    memEty.avatar = [dic objectForKey:@"avatar"];
//    self.memberData = memEty;
//    [memEty release];
//    
//    
//    NSLog(@"dic==%@",dic);
//    
//    
//    NSLog(@"error :%@", [json objectForKey:@"msgbox"]);
//}


- (void)memberClean
{
    self.cityArray = nil;
    self.isLogIn = NO;
    self.memberData.user_name = nil;
    self.memberData.idString = nil;
    self.memberData.mobileNum = nil;
    self.memberData.nick_name = nil;
    self.memberData.email = nil;
    self.memberData.birthday = nil;
    self.memberData.area = nil;
    self.memberData.rows = nil;
    self.memberData.address  = nil;
    self.memberData.avatar = nil;
//    self.memberData.isvip = nil;
}

- (void)dealloc
{
    [cityArray release];
    [memberData release];
    [super dealloc];
}

@end
