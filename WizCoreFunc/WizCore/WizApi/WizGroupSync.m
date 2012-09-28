//
//  WizGroupSync.m
//  WizCore
//
//  Created by wiz on 12-9-20.
//  Copyright (c) 2012年 cn.wiz. All rights reserved.
//

#import "WizGroupSync.h"
#import "WizApiDownloadDeletedGuids.h"
#import "WizApiDownloadTagList.h"
#import "WizApiDownloadDocumentList.h"
#import "WizApiDownloadAttachmentList.h"
#import "WizApiUploadDeletedGuids.h"
#import "WizApiUploadTags.h"
#import "WizUploadObject.h"
#import "WizDownloadObject.h"
#import "WizApiGetAllVersions.h"

#define WizMaxUploadToolCount   1
#define WizMaxDownloadToolCount 4

@interface WizGroupSync() <WizApiDelegate, WizApiDownloadObjectDelegate, WizApiGetAllVersionsDelegate>

@end

@implementation WizGroupSync
@synthesize kbguid;
@synthesize accountUserId;
- (void) dealloc
{
    [kbguid release];
    [accountUserId release];
    [super dealloc];
}

- (id) init
{
    self = [super init];
    if (self) {

    }
    return  self;
}


- (void) didDownloadObjectFaild:(WizObject *)obj
{
    
}
- (void) didDownloadObjectSucceed:(WizObject *)obj
{
    static int i = 0;
    i++;
    NSLog(@"%d ***** %@",i,obj.strTitle);
}
- (WizDownloadObject*) getAvailbleDownloadTool
{
    if ([downloadToolsQueque count] < WizMaxDownloadToolCount) {
        WizDownloadObject* downloadObject = [[WizDownloadObject alloc] initWithKbguid:self.kbguid accountUserId:self.accountUserId apiDelegate:self];
        downloadObject.delegate = self;
        [downloadToolsQueque addObject:downloadObject];
        [downloadObject release];
        return downloadObject;
    }
    else
    {
        for (WizDownloadObject* eachTool in downloadToolsQueque) {
            if (eachTool.statue == WizApiStatueNormal) {
                return eachTool;
            }
        }
    }
    return nil;
}

- (WizUploadObject*) getAvailbelUploadTool
{
    if ([uploadToolsQueque count] <= WizMaxUploadToolCount) {
        WizUploadObject* upload = [[WizUploadObject alloc]initWithKbguid:self.kbguid accountUserId:self.accountUserId apiDelegate:self];
        upload.delegate = self;
        [uploadToolsQueque addObject:upload];
        [upload release];
        return upload;
    }
    else
    {
        for (WizUploadObject* eachTool in uploadToolsQueque) {
            if (eachTool.statue == WizApiStatueNormal) {
                return eachTool;
            }
        }
    }
    return nil;
}

- (void) startDownload
{
    WizDownloadObject* downloadTool = [self getAvailbleDownloadTool];
    if (downloadTool != nil) {
        WizObject* downObj = [downloadArray lastObject];
        if (nil != downObj) {
            downloadTool.downloadObject = downObj;
            [downloadTool start];
            [downloadArray removeObject:downObj];
        }
    }
}

- (void) downloadWizObject:(WizObject *)wizObject
{
    @synchronized(downloadArray)
    {
        if (wizObject != nil) {
            [downloadArray addObject:wizObject];
        }
    }
    [self startDownload];
}

- (void) uploadWizObject:(WizObject *)wizObject
{
    @synchronized(uploadArray)
    {
        if (wizObject != nil) {
            
        }
    }
}
- (void) didGetAllObjectVersions:(NSDictionary *)dic
{
    NSLog(@"versions %@",dic);
    NSNumber* attachmentVer = [dic objectForKey:@"attachment_version"];
    NSNumber* documentVer = [dic objectForKey:@"document_version"];
    NSNumber* tagVer = [dic objectForKey:@"tag_version"];
    NSNumber* deletedVer = [dic objectForKey:@"deleted_version"];
    
    WizApiDownloadDeletedGuids* deleted = [[WizApiDownloadDeletedGuids alloc] initWithKbguid:self.kbguid accountUserId:self.accountUserId apiDelegate:self];
    deleted.serverVersion = [deletedVer integerValue];
    //
    WizApiUploadDeletedGuids* upDeleted = [[WizApiUploadDeletedGuids alloc] initWithKbguid:self.kbguid accountUserId:self.accountUserId apiDelegate:self];
    //
    WizApiDownloadTagList* tagList = [[WizApiDownloadTagList alloc] initWithKbguid:self.kbguid accountUserId:self.accountUserId apiDelegate:self];
    tagList.serverVersion = [tagVer integerValue];
    //
    WizApiUploadTags* upTags = [[WizApiUploadTags alloc] initWithKbguid:self.kbguid accountUserId:self.accountUserId apiDelegate:self];
    //
    WizApiDownloadDocumentList* documentList = [[WizApiDownloadDocumentList alloc] initWithKbguid:self.kbguid accountUserId:self.accountUserId apiDelegate:self];
    documentList.serverVersion = [documentVer integerValue];
    //
    WizApiDownloadAttachmentList* attachmentList = [[WizApiDownloadAttachmentList alloc] initWithKbguid:self.kbguid accountUserId:self.accountUserId apiDelegate:self];
    attachmentList.serverVersion = [attachmentVer integerValue];
    //
    [syncMetaApiQueque addObject:deleted];
    [syncMetaApiQueque addObject:upDeleted];
    [syncMetaApiQueque addObject:tagList];
    [syncMetaApiQueque addObject:upTags];
    [syncMetaApiQueque addObject:documentList];
    [syncMetaApiQueque addObject:attachmentList];
    //
    [deleted release];
    [tagList release];
    [documentList release];
    [attachmentList release];
    [upDeleted release];
    [upTags release];
}
- (void) setupSyncQueque
{
    WizApiGetAllVersions* getVersions = [[WizApiGetAllVersions alloc] initWithKbguid:self.kbguid accountUserId:self.accountUserId apiDelegate:self];
    getVersions.delegate = self;
    [syncMetaApiQueque addObject:getVersions];
    [getVersions release];
}
- (void) doNextSyncMetaApi
{
    if ([syncMetaApiQueque count]) {
        WizApi* api = [syncMetaApiQueque objectAtIndex:0];
        [api start];
    }
    else
    {
        NSLog(@"over ************* %@",self.kbguid);
    }

}
- (void) syncEndWithError
{
    [syncMetaApiQueque removeAllObjects];
}
- (void) wizApiEnd:(WizApi *)api withSatue:(enum WizApiStatue)statue
{
    if (WizApiStatueNormal == statue) {
        if ([api isKindOfClass:[WizDownloadObject class]]) {
            [self startDownload];
        }
        else if ([api isKindOfClass:[WizUploadObject class]])
        {
            
        }
        else
        {
            [syncMetaApiQueque removeObject:api];
            [self doNextSyncMetaApi];
        }
    }
    else
    {
        if ([api isKindOfClass:[WizDownloadObject class]]) {
            [downloadToolsQueque removeObject:api];
        }
        else if ([api isKindOfClass:[WizUploadObject class]])
        {
            [uploadToolsQueque removeObject:api];
        }
        [self syncEndWithError];
    }
}

- (void) startSyncMeta
{
    if ([syncMetaApiQueque count]) {
        return;
    }
    [self setupSyncQueque];
    WizApi* api = [syncMetaApiQueque objectAtIndex:0];
    [api start];
}

@end
