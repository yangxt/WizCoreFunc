//
//  WizApiDownloadDocumentList.m
//  WizCoreFunc
//
//  Created by wiz on 12-9-26.
//  Copyright (c) 2012年 cn.wiz. All rights reserved.
//

#import "WizApiDownloadDocumentList.h"

@implementation WizApiDownloadDocumentList
- (NSString*) getMethodName
{
    return SyncMethod_DownloadDocumentList;
}

- (NSInteger) getLocalVersion
{
    return [[self groupDataBase] documentVersion];
}
- (void) updateLocaList:(NSArray *)list
{
    [[self groupDataBase] updateDocuments:list];
}

- (void) updateLocalVersion:(int64_t)version
{
    [[self groupDataBase] setDocumentVersion:version];
}
@end
