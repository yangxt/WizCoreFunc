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
    NSInteger   apiIndex;
    NSInteger   syncType;
}
@end

@implementation WizSyncMeta
@synthesize kbguid;
@synthesize accountUserId;
@synthesize syncStatueDescription=_syncStatueDescription;
- (void) dealloc
{
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
    [apiQueque addObject:deleted];
    [apiQueque addObject:upDeleted];
    [apiQueque addObject:tagList];
    [apiQueque addObject:upTags];
    [apiQueque addObject:documentList];
    [apiQueque addObject:attachmentList];
    //
    [deleted release];
    [tagList release];
    [documentList release];
    [attachmentList release];
    [upDeleted release];
    [upTags release];
}

// never release any api
- (void) wizApiEnd:(WizApi *)api withSatue:(enum WizApiStatue)statue
{
    if (statue == WizApistatueError) {
#warning do something end the sync process
    }
    else
    {
        NSInteger index = [apiQueque indexOfObject:api];
        if (index + 1 == [apiQueque count]) {
            
        }
        else
        {
            WizApi* nextApi = [apiQueque objectAtIndex:(index +1)];
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
        apiIndex = 0;
    }
    return self;
}

@end
