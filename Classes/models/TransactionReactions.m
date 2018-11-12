//
//  TransactionReactions.m
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import "TransactionReactions.h"

extern NSString *kDecodeKeyPrefix;

@implementation TransactionReactions
@synthesize myReactionId;
@synthesize reactionList;

- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [[TransactionReactions alloc] init])
    {
        self.myReactionId = [coder decodeIntForKey:[NSString stringWithFormat:@"%@TransactionReactionIDKey", kDecodeKeyPrefix]];
		self.reactionList = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@TransactionReactionTListKey", kDecodeKeyPrefix]];
	}
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeInt:myReactionId forKey:[NSString stringWithFormat:@"%@TransactionReactionIDKey", kDecodeKeyPrefix]];
	[coder encodeObject:reactionList forKey:[NSString stringWithFormat:@"%@TransactionReactionTListKey", kDecodeKeyPrefix]];
}

- (void)dealloc {
	[reactionList release];
    [super dealloc];
}

@end
