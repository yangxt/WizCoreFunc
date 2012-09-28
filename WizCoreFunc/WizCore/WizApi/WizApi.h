//
//  WizApi.h
//  WizCore
//
//  Created by wiz on 12-8-1.
//  Copyright (c) 2012年 cn.wiz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLRPCConnection.h"
#import "XMLRPCRequest.h"
#import "WizDbManager.h"

#define SyncMethod_ClientLogin                  @"accounts.clientLogin"
#define SyncMethod_ClientLogout                 @"accounts.clientLogout"
#define SyncMethod_CreateAccount                @"accounts.createAccount"
#define SyncMethod_ChangeAccountPassword        @"accounts.changePassword"
#define SyncMethod_GetAllCategories             @"category.getAll"
#define SyncMethod_GetAllTags                   @"tag.getList"
#define SyncMethod_PostTagList                  @"tag.postList"
#define SyncMethod_DocumentsByKey               @"document.getSimpleListByKey"
#define SyncMethod_DownloadDocumentList         @"document.getSimpleList"
#define SyncMethod_DocumentsByCategory          @"document.getSimpleListByCategory"
#define SyncMethod_DocumentsByTag               @"document.getSimpleListByTag"
#define SyncMethod_DocumentPostSimpleData       @"document.postSimpleData"
#define SyncMethod_DownloadDeletedList          @"deleted.getList"
#define SyncMethod_UploadDeletedList            @"deleted.postList"
#define SyncMethod_DownloadObject               @"data.download"
#define SyncMethod_UploadObject                 @"data.upload"
#define SyncMethod_AttachmentPostSimpleData     @"attachment.postSimpleData"
#define SyncMethod_GetAttachmentList            @"attachment.getList"
#define SyncMethod_GetUserInfo                  @"wiz.getInfo"
#define SyncMethod_GetGropKbGuids               @"accounts.getGroupKbList"
#define SyncMethod_GetAllObjectVersion          @"wiz.getVersion"
enum WizApiStatue {
    WizApiStatueNormal = 0,
    WizApiStatueBusy = 1,
    WizApistatueError =2
};

const static NSInteger WizApiAttemptTimeMax = 5;

@class WizApi;
@protocol WizApiDelegate
- (void) wizApiEnd:(WizApi*)api withSatue:(enum WizApiStatue)statue;
@end

@interface WizApi : NSObject
{
    NSInteger attemptTime;
}
@property (nonatomic, assign)   id<WizApiDelegate> apiDelegate;
@property (nonatomic, readonly) enum WizApiStatue statue;
@property (nonatomic ,retain)   XMLRPCConnection* connection;
@property (nonatomic, retain)   NSString* kbGuid;
@property (nonatomic, retain)   NSString* accountUserId;
- (BOOL) start;
- (void) end;
- (void) cancel;
- (void) onError:(NSError*)error;
- (void) xmlrpcDoneSucced:(id)retObject forMethod:(NSString*)method;
- (BOOL) executeXmlRpcWithArgs:(NSMutableDictionary*)postParams  methodKey:(NSString*)methodKey;
- (void) reduceAttempTime;
- (id<WizMetaDataBaseDelegate>) groupDataBase;
//
- (void) changeStatue:(enum WizApiStatue) statue;

- (NSInteger) listCount;

- (id) initWithKbguid:(NSString*)kbguid accountUserId:(NSString*)accountUserId apiDelegate:(id<WizApiDelegate>)delegate;
@end