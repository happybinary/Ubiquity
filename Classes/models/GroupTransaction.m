//
//  GroupTransaction.m
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import "GroupTransaction.h"
#import "Transaction.h"

extern NSString *kDecodeKeyPrefix;

@implementation GroupTransaction
@synthesize groupId, splitCorrelationId;
@synthesize transactions;

- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [[GroupTransaction alloc] init])
    {
        self.groupId = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@GroupTransactionIDKey", kDecodeKeyPrefix]];
		self.splitCorrelationId = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@GroupTransactionCorrelationKey", kDecodeKeyPrefix]];
		self.transactions = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@GroupTransactionTListKey", kDecodeKeyPrefix]];
	}
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:groupId forKey:[NSString stringWithFormat:@"%@GroupTransactionIDKey", kDecodeKeyPrefix]];
	[coder encodeObject:splitCorrelationId forKey:[NSString stringWithFormat:@"%@GroupTransactionCorrelationKey", kDecodeKeyPrefix]];
	[coder encodeObject:transactions forKey:[NSString stringWithFormat:@"%@GroupTransactionTListKey", kDecodeKeyPrefix]];
}

- (void)dealloc {
	[splitCorrelationId release];
	[groupId release];
	[transactions release];
    [super dealloc];
}

@end
