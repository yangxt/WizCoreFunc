//
//  WizNotificationCenter.h
//  WizGroup
//
//  Created by wiz on 12-9-29.
//  Copyright (c) 2012年 cn.wiz. All rights reserved.
//

#import <Foundation/Foundation.h>
#define WizNMDidUpdataGroupList     @"WizNMDidUpdataGroupList"
#define WizNMDidDownloadDocument    @"WizNMDidDownloadDocument"

//
#define WizNMDocumentKeyString      @"WizNMDocumentKeyString"


@interface WizNotificationCenter : NSNotificationCenter
+ (NSString*)getDocumentGuidFromNc:(NSNotification*)nc;
+ (void) addDocumentGuid:(NSString*)guid toUserInfo:(NSMutableDictionary*)userInfo;
@end
