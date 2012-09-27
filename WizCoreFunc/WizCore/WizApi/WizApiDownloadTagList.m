//
//  WizApiDownloadTagList.m
//  WizCoreFunc
//
//  Created by wiz on 12-9-26.
//  Copyright (c) 2012年 cn.wiz. All rights reserved.
//

#import "WizApiDownloadTagList.h"

@implementation WizApiDownloadTagList
- (NSString*) getMethodName
{
    return SyncMethod_GetAllTags;
}

- (NSInteger) getLocalVersion
{
    return [[self groupDataBase] tagVersion];
}
- (void) updateLocaList:(NSArray *)list
{
    [[self groupDataBase] updateTags:list];
}

- (void) updateLocalVersion:(int64_t)version
{
    [[self groupDataBase] setTagVersion:version];
}
@end
