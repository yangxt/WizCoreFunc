//
//  WizGroupSync.m
//  WizCore
//
//  Created by wiz on 12-9-20.
//  Copyright (c) 2012年 cn.wiz. All rights reserved.
//

#import "WizGroupSync.h"
#import "WizSyncMeta.h"
#import "WizSyncDownload.h"
#import "WizSyncUpload.h"

#define WizMaxUploadToolCount   1
#define WizMaxDownloadToolCount 4

@interface WizGroupSync() <WizSyncMetaDelegate>

@property (nonatomic , retain)    WizSyncMeta* syncMetaTool;
@property (nonatomic, retain)   WizSyncDownload* downloadTool;
@property (nonatomic, retain) WizSyncUpload*    uploadTool;
@end

@implementation WizGroupSync
@synthesize kbguid;
@synthesize accountUserId;
@synthesize syncMetaTool;
@synthesize downloadTool;
@synthesize uploadTool;
- (void) dealloc
{
    [uploadTool release];
    [downloadTool release];
    [syncMetaTool release];
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
- (void) didSyncMetaFaild
{
    
}
- (void) didSyncMetaSucceed
{
    NSLog(@"ok");
}
- (void) didSyncMetaChangedStatue:(NSString *)discription
{
    
}
- (void) startSyncMeta
{
    if (self.syncMetaTool && [self.syncMetaTool isSyncingGroupMeta]) {
        return;
    }
    WizSyncMeta* syncMeta = [[WizSyncMeta alloc] initWithType:WizSyncMetaAll kbguid:self.kbguid accountUserId:self.accountUserId];
    self.syncMetaTool = syncMeta;
    [syncMeta release];
    syncMeta.delegate = self;
    [self.syncMetaTool startSyncMeta];
}
- (BOOL) isSyncingMeta
{
    return [self.syncMetaTool isSyncingGroupMeta];
}

- (void) downloadWizObject:(WizObject *)wizObject
{
    if (nil == self.downloadTool) {
        WizSyncDownload* dTool = [[WizSyncDownload alloc] init];
        dTool.kbguid = self.kbguid;
        dTool.accountUserId = self.accountUserId;
        self.downloadTool = dTool;
        [dTool release];
    }
    [self.downloadTool shouldDownload:wizObject];
}

- (void) uploadWizObject:(WizObject *)wizObject
{
    if (nil == self.uploadTool) {
        WizSyncUpload* uTool = [[WizSyncUpload alloc] init];
        uTool.kbguid = self.kbguid;
        uTool.accountUserId = self.accountUserId;
        self.uploadTool = uTool;
        [uTool release];
    }
    [self.uploadTool shouldUpload:wizObject];
}

- (void) stopSync
{
    if (self.syncMetaTool) {
        [self.syncMetaTool stopSyncMeta];
    }
    if(self.downloadTool)
    {
        [self.downloadTool stopDownload];
    }
    if(self.uploadTool)
    {
        [self.uploadTool stopUpload];
    }
}

@end
