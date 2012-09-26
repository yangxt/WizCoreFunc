//
//  WizSyncDataCenter.h
//  WizCore
//
//  Created by wiz on 12-9-24.
//  Copyright (c) 2012年 cn.wiz. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSString* WizServerUrl = @"";

@protocol WizSyncShareParamsDelegate <NSObject>
- (NSString*) tokenForKbguid:(NSString*)kbguid;
- (NSURL*)    apiUrlForKbguid:(NSString*)kbguid;
- (void)  refreshToken:(NSString*)token  kbguid:(NSString*)kbguid;
- (void)  refreshApiurl:(NSURL*)apiUrl  kbguid:(NSString*)kbguid;
@end
@interface WizSyncDataCenter : NSObject <WizSyncShareParamsDelegate>
+ (id<WizSyncShareParamsDelegate>) shareInstance;
@end
