//
//  WizApiDownloadAttachmentList.m
//  WizCoreFunc
//
//  Created by wiz on 12-9-26.
//  Copyright (c) 2012年 cn.wiz. All rights reserved.
//

#import "WizApiDownloadAttachmentList.h"

@implementation WizApiDownloadAttachmentList
- (NSString*) getMethodName
{
    return SyncMethod_GetAttachmentList;
}

- (NSInteger) getLocalVersion
{
    return [[self groupDataBase] attachmentVersion];
}
- (void) updateLocaList:(NSArray *)list
{
    [[self groupDataBase] updateAttachments:list];
}

- (void) updateLocalVersion:(int64_t)version
{
    [[self groupDataBase] setAttachmentVersion:version];
}
@end
