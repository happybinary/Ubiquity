//
//  ScannedQR.m
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import "ScannedQR.h"
#import "ScannedQRType.h"

extern NSString *kDecodeKeyPrefix;

@implementation ScannedQR
@synthesize userId;
@synthesize transactionId, type;

- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [[ScannedQR alloc] init])
    {
        self.userId = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@ScannedQRIDKey", kDecodeKeyPrefix]];
        self.transactionId = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@ScannedQRTransactionKey", kDecodeKeyPrefix]];
        self.type = [coder decodeIntForKey:[NSString stringWithFormat:@"%@ScannedQRTypeKey", kDecodeKeyPrefix]];
    }
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:userId forKey:[NSString stringWithFormat:@"%@ScannedQRIDKey", kDecodeKeyPrefix]];
    [coder encodeObject:transactionId forKey:[NSString stringWithFormat:@"%@ScannedQRTransactionKey", kDecodeKeyPrefix]];
    [coder encodeInt:type forKey:[NSString stringWithFormat:@"%@ScannedQRTypeKey", kDecodeKeyPrefix]];
}

-(NSString *) getId
{
    return self.type == QR_USER_ID?self.userId:self.transactionId;
}

- (void)dealloc {
    [transactionId release];
	[userId release];
    [super dealloc];
}

@end
