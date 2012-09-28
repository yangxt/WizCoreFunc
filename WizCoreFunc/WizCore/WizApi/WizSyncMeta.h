//
//  WizSyncMeta.h
//  WizCoreFunc
//
//  Created by wiz on 12-9-28.
//  Copyright (c) 2012年 cn.wiz. All rights reserved.
//

#import <Foundation/Foundation.h>

enum WizSyncMetaType {
    WizSyncMetaOnlyDownload = 1,
    WizSyncMetaAll = 2,
    WizSyncMetaUploadTag
};

@interface WizSyncMeta : NSObject
@property (nonatomic, retain)   NSString* kbguid;
@property (nonatomic, retain)   NSString* accountUserId;
@property (nonatomic, readonly) NSString* syncStatueDescription;
@end
