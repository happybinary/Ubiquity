//
//  TransactionUpdateModel.m
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import "TransactionUpdateModel.h"

extern NSString *kDecodeKeyPrefix;

@implementation TransactionUpdateModel
@synthesize balance;
@synthesize transactionList;

- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [[TransactionUpdateModel alloc] init])
    {
        self.balance = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@TransactionBalanceKey", kDecodeKeyPrefix]];
		self.transactionList = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@TransactionModelListKey", kDecodeKeyPrefix]];
	}
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:balance forKey:[NSString stringWithFormat:@"%@TransactionBalanceKey", kDecodeKeyPrefix]];
	[coder encodeObject:transactionList forKey:[NSString stringWithFormat:@"%@TransactionModelListKey", kDecodeKeyPrefix]];
}

- (void)dealloc {
    [balance release];
	[transactionList release];
    [super dealloc];
}

@end
