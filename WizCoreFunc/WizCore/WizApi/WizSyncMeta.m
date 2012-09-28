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

- (void) didGetAllObjectVersions:(NSDictionary *)dic
{
    NSLog(@"versions %@",dic);
    NSNumber* attachmentVer = [dic objectForKey:@"attachment_version"];
    NSNumber* documentVer = [dic objectForKey:@"document_version"];
    NSNumber* tagVer = [dic objectForKey:@"tag_version"];
    NSNumber* deletedVer = [dic objectForKey:@"deleted_version"];
    
    WizApiDownloadDeletedGuids* deleted = [[WizApiDownloadDeletedGuids alloc] initWithKbguid:self.kbguid accountUserId:self.accountUserId apiDelegate:self];
    deleted.serverVersion = [deletedVer integerValue];
  
    WizApiDownloadTagList* tagList = [[WizApiDownloadTagList alloc] initWithKbguid:self.kbguid accountUserId:self.accountUserId apiDelegate:self];
    tagList.serverVersion = [tagVer integerValue];
    //

    WizApiDownloadDocumentList* documentList = [[WizApiDownloadDocumentList alloc] initWithKbguid:self.kbguid accountUserId:self.accountUserId apiDelegate:self];
    documentList.serverVersion = [documentVer integerValue];
    //
    WizApiDownloadAttachmentList* attachmentList = [[WizApiDownloadAttachmentList alloc] initWithKbguid:self.kbguid accountUserId:self.accountUserId apiDelegate:self];
    attachmentList.serverVersion = [attachmentVer integerValue];
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

// never release any api
- (void) wizApiEnd:(WizApi *)api withSatue:(enum WizApiStatue)statue
{
    if (statue == WizApistatueError) {
        [self.delegate didSyncMetaFaild];
    }
    else
    {
        NSInteger index = [apiQueque indexOfObject:api];
        if (index + 1 == [apiQueque count]) {
            [self.delegate didSyncMetaSucceed];
        }
        else
        {
            WizApi* nextApi = [apiQueque objectAtIndex:(index +1)];
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
    }
    return self;
}
- (void) startSyncMeta
{
    if ([apiQueque count]) {
        WizApi* api = [apiQueque objectAtIndex:0];
        [api start];
    }
}

@end
