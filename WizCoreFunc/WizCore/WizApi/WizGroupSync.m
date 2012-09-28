//
//  WizGroupSync.m
//  WizCore
//
//  Created by wiz on 12-9-20.
//  Copyright (c) 2012年 cn.wiz. All rights reserved.
//

#import "WizGroupSync.h"
#import "WizSyncMeta.h"

#define WizMaxUploadToolCount   1
#define WizMaxDownloadToolCount 4

@interface WizGroupSync() <WizSyncMetaDelegate>

@property (nonatomic , retain)    WizSyncMeta* syncMetaTool;

@end

@implementation WizGroupSync
@synthesize kbguid;
@synthesize accountUserId;
@synthesize syncMetaTool;
- (void) dealloc
{
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
    WizSyncMeta* syncMeta = [[WizSyncMeta alloc] initWithType:WizSyncMetaAll kbguid:self.kbguid accountUserId:self.accountUserId];
    self.syncMetaTool = syncMeta;
    [syncMeta release];
    syncMeta.delegate = self;
    [self.syncMetaTool startSyncMeta];
}

@end
