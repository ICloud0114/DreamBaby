//
//  ChangeDate.m
//  GoodMom
//
//  Created by easaa on 8/14/13.
//  Copyright (c) 2013 easaa. All rights reserved.
//

#import "ChangeDate.h"

@implementation ChangeDate
@synthesize type_id;
+(ChangeDate *)instance
{
    static ChangeDate * s_changeDate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_changeDate = [[ChangeDate alloc]init];
    });
    return s_changeDate;
}
- (id)init
{
    self = [super init];
    if (self) {
        self.type_id=@"1";
    }
    return self;
}
- (void)dealloc
{
    RELEASE_SAFE(type_id);
    [super dealloc];
}
@end
