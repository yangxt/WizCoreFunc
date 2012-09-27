//
//  WizApiDownloadDeletedGuids.m
//  WizCoreFunc
//
//  Created by wiz on 12-9-26.
//  Copyright (c) 2012年 cn.wiz. All rights reserved.
//

#import "WizApiDownloadDeletedGuids.h"

@implementation WizApiDownloadDeletedGuids
- (NSString*) getMethodName
{
    return SyncMethod_DownloadDeletedList;
}

- (NSInteger) getLocalVersion
{
    return [[self groupDataBase] deletedGUIDVersion];
}
- (void) updateLocaList:(NSArray *)list
{
    
}

- (void) updateLocalVersion:(int64_t)version
{
    [[self groupDataBase] setDeletedGUIDVersion:version];
}

@end