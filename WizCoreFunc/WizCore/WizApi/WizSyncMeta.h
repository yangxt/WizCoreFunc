//
//  WizSyncMeta.h
//  WizCoreFunc
//
//  Created by wiz on 12-9-28.
//  Copyright (c) 2012年 cn.wiz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WizSyncMetaDelegate
- (void) didSyncMetaChangedStatue:(NSString*)discription;
- (void) didSyncMetaSucceed;
- (void) didSyncMetaFaild;
@end

enum WizSyncMetaType {
    WizSyncMetaOnlyDownload = 1,
    WizSyncMetaAll = 2,
    WizSyncMetaUploadTag
};

@interface WizSyncMeta : NSObject
@property (nonatomic, retain)   NSString* kbguid;
@property (nonatomic, retain)   NSString* accountUserId;
@property (nonatomic, readonly) NSString* syncStatueDescription;
@property (nonatomic, assign) id<WizSyncMetaDelegate> delegate;
- (id) initWithType:(enum WizSyncMetaType) type  kbguid:(NSString*)kb accountUserId:(NSString*)userId;
- (void) startSyncMeta;
- (void) stopSyncMeta;
- (BOOL) isSyncingGroupMeta;
@end
