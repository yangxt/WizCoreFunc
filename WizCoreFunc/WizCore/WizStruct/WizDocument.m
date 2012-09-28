//
//  WizDocument.m
//  Wiz
//
//  Created by 朝 董 on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WizDocument.h"

@implementation WizDocument
@synthesize strLocation;
@synthesize strUrl;
@synthesize dateCreated;
@synthesize dateModified;
@synthesize strType;
@synthesize strFileType;
@synthesize strTagGuids;
@synthesize strDataMd5;
@synthesize bServerChanged;
@synthesize nLocalChanged;
@synthesize nProtected;
@synthesize nAttachmentCount;
@synthesize gpsLatitude;
@synthesize gpsLongtitude;
@synthesize gpsAltitude;
@synthesize gpsDop;
@synthesize nReadCount;
@synthesize gpsAddress;
@synthesize gpsCountry;
@synthesize gpsLevel1;
@synthesize gpsLevel2;
@synthesize gpsLevel3;
@synthesize gpsDescription;

- (void) dealloc
{
    [strLocation release];
    [strUrl release];
    [dateCreated release];
    [dateModified release];
    [strType release];
    [strFileType release];
    [strTagGuids release];
    [strDataMd5 release];
    [gpsCountry release];
    [gpsAddress release];
    [gpsLevel1 release];
    [gpsLevel2 release];
    [gpsLevel3 release];
    [gpsDescription release];
    [super dealloc];
}
- (NSString*) wizObjectType
{
    return @"document";
}
@end
