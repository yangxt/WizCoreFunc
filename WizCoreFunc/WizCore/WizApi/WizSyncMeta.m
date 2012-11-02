//
//  WizSyncMeta.m
//  WizCoreFunc
//
//  Created by wiz on 12-9-28.
//  Copyright (c) 2012年 cn.wiz. All rights reserved.
//

#import "WizSyncMeta.h"
#import "WizApiDownloadDeletedGuids.h"
#import "WizApiDownloadTagList.h"
#import "WizApiDownloadDocumentList.h"
#import "WizApiDownloadAttachmentList.h"
#import "WizApiUploadDeletedGuids.h"
#import "WizApiUploadTags.h"
#import "WizUploadObject.h"
#import "WizDownloadObject.h"
#import "WizApiGetAllVersions.h"
@interface WizSyncMeta () <WizApiGetAllVersionsDelegate, WizApiDelegate>
{
    NSMutableArray* apiQueque;
    NSInteger   syncType;
    NSInteger   apiIndex;
    BOOL isStop;
}
@end

@implementation WizSyncMeta
@synthesize kbguid;
@synthesize accountUserId;
@synthesize syncStatueDescription=_syncStatueDescription;
@synthesize delegate;
- (void) dealloc
{
    delegate = nil;
    [kbguid release];
    [accountUserId release];
    [_syncStatueDescription release];
    [apiQueque release];
    [super dealloc];
}


- (void) setupSyncTools
{
    WizApiDownloadDeletedGuids* deleted = [[WizApiDownloadDeletedGuids alloc] initWithKbguid:self.kbguid accountUserId:self.accountUserId apiDelegate:self];

    
    WizApiDownloadTagList* tagList = [[WizApiDownloadTagList alloc] initWithKbguid:self.kbguid accountUserId:self.accountUserId apiDelegate:self];

    //
    
    WizApiDownloadDocumentList* documentList = [[WizApiDownloadDocumentList alloc] initWithKbguid:self.kbguid accountUserId:self.accountUserId apiDelegate:self];

    //
    WizApiDownloadAttachmentList* attachmentList = [[WizApiDownloadAttachmentList alloc] initWithKbguid:self.kbguid accountUserId:self.accountUserId apiDelegate:self];
    //
    
    if (WizSyncMetaAll == syncType) {
        WizApiUploadTags* upTags = [[WizApiUploadTags alloc] initWithKbguid:self.kbguid accountUserId:self.accountUserId apiDelegate:self];
        //
        //
        WizApiUploadDeletedGuids* upDeleted = [[WizApiUploadDeletedGuids alloc] initWithKbguid:self.kbguid accountUserId:self.accountUserId apiDelegate:self];
        //
        [apiQueque addObject:deleted];
        [apiQueque addObject:upDeleted];
        [apiQueque addObject:tagList];
        [apiQueque addObject:upTags];
        [apiQueque addObject:documentList];
        [apiQueque addObject:attachmentList];
        [upDeleted release];
        [upTags release];
    }
    else
    {
        [apiQueque addObject:deleted];
        [apiQueque addObject:tagList];
        [apiQueque addObject:documentList];
        [apiQueque addObject:attachmentList];
    }
    //
    [deleted release];
    [tagList release];
    [documentList release];
    [attachmentList release];
}

- (WizApi*) getSyncTool:(Class)classKind
{
    for (WizApi* each in apiQueque) {
        if ([each isKindOfClass:classKind]) {
            return each;
        }
    }
    return nil;
}

- (void) didGetAllObjectVersions:(NSDictionary *)dic
{
    NSNumber* attachmentVer = [dic objectForKey:@"attachment_version"];
    NSNumber* documentVer = [dic objectForKey:@"document_version"];
    NSNumber* tagVer = [dic objectForKey:@"tag_version"];
    NSNumber* deletedVer = [dic objectForKey:@"deleted_version"];
    
    WizApiDownloadAttachmentList* attachmentList = (WizApiDownloadAttachmentList*)[self getSyncTool:[WizApiDownloadAttachmentList class]];
    WizApiDownloadDeletedGuids* deletedList = (WizApiDownloadDeletedGuids*)[self getSyncTool:[WizApiDownloadDeletedGuids class]];
    WizApiDownloadDocumentList* documentList = (WizApiDownloadDocumentList*)[self getSyncTool:[WizApiDownloadDocumentList class]];
    WizApiDownloadTagList* tagList = (WizApiDownloadTagList*)[self getSyncTool:[WizApiDownloadTagList class]];
    
    attachmentList.serverVersion = [attachmentVer integerValue];
    documentList.serverVersion = [documentVer integerValue];
    deletedList.serverVersion = [deletedVer integerValue];
    tagList.serverVersion = [tagVer integerValue];

}

// never release any api
- (void) wizApiEnd:(WizApi *)api withSatue:(enum WizApiStatue)statue
{
    if (statue == WizApistatueError || isStop) {
        NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
        [WizNotificationCenter addGuid:self.kbguid toUserInfo:userInfo];
        [[WizNotificationCenter defaultCenter] postNotificationName:WizNMSyncGroupError object:nil userInfo:userInfo];
        [self.delegate didSyncMetaFaild];
    }
    else
    {
        apiIndex ++;
        if (apiIndex >= [apiQueque count]) {
            NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
            [WizNotificationCenter addGuid:self.kbguid toUserInfo:userInfo];
            [[WizNotificationCenter defaultCenter] postNotificationName:WizNMSyncGroupEnd object:nil userInfo:userInfo];
            [self.delegate didSyncMetaSucceed];
        }
        else
        {
            WizApi* nextApi = [apiQueque objectAtIndex:apiIndex];
            [self.delegate didSyncMetaChangedStatue:@"asdfasdf"];
            [nextApi start];
        }
    }
}

- (id) initWithType:(enum WizSyncMetaType) type  kbguid:(NSString*)kb accountUserId:(NSString*)userId
{
    self = [super init];
    if (self) {
        apiQueque = [[NSMutableArray alloc] init];
        syncType = type;
        kbguid = [kb retain];
        accountUserId = [userId retain];
        WizApiGetAllVersions* getAllVersion = [[WizApiGetAllVersions alloc] initWithKbguid:kb accountUserId:userId apiDelegate:self];
        getAllVersion.delegate = self;
        [apiQueque addObject:getAllVersion];
        [getAllVersion release];
        apiIndex = 0;
        isStop = NO;
        [self setupSyncTools];
    }
    return self;
}
- (void) startSyncMeta
{
    isStop = NO;
    if ([apiQueque count]) {
        WizApi* api = [apiQueque objectAtIndex:0];
        NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
        [WizNotificationCenter addGuid:self.kbguid toUserInfo:userInfo];
        [[WizNotificationCenter defaultCenter] postNotificationName:WizNMSyncGroupStart object:nil userInfo:userInfo];
        [api start];
    }
}
- (void) stopSyncMeta
{
    isStop = YES;
    if (apiIndex >= [apiQueque count]) {
        [self.delegate didSyncMetaSucceed];
    }
    else
    {
        WizApi* nextApi = [apiQueque objectAtIndex:apiIndex];
        [nextApi cancel];
    }
}

- (BOOL) isSyncingGroupMeta
{
    if ([apiQueque count]) {
        for (WizApi* each in apiQueque) {
            if (each.statue != WizApiStatueNormal) {
                return YES;
            }
        }
    }
    return NO;
}
@end
