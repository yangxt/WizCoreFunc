//
//  WizApiRefreshGroups.m
//  WizCore
//
//  Created by wiz on 12-9-24.
//  Copyright (c) 2012年 cn.wiz. All rights reserved.
//

#import "WizApiRefreshGroups.h"
#import "WizDbManager.h"
#import "WizAccountManager.h"

@implementation WizApiRefreshGroups

- (BOOL) start
{
    if ([super start]) {
        [self executeXmlRpcWithArgs:[NSMutableDictionary dictionary] methodKey:SyncMethod_GetGropKbGuids];
        return YES;
    }
    return NO;
}

- (void) onGetGroupList:(id)retObject
{
    id<WizSettingsDbDelegate> settingDb =  [[WizDbManager shareInstance] getGlobalSettingDb];
    //
    [settingDb updateGroups:retObject accountUserId:self.accountUserId];
    
    [super end];
}

- (void) xmlrpcDoneSucced:(id)retObject forMethod:(NSString *)method
{
    if([method isEqualToString:SyncMethod_GetGropKbGuids])
    {
        [self onGetGroupList:retObject];
    }
}
@end
