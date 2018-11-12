//
//  ReactionPair.m
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import "ReactionPair.h"

extern NSString *kDecodeKeyPrefix;

@implementation ReactionPair
@synthesize reaction;
@synthesize count;

- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [[ReactionPair alloc] init])
    {
        self.reaction = [coder decodeIntForKey:[NSString stringWithFormat:@"%@ReactionPairIDKey", kDecodeKeyPrefix]];
        self.count = [coder decodeIntForKey:[NSString stringWithFormat:@"%@ReactionPairCountKey", kDecodeKeyPrefix]];
	}
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeInt:reaction forKey:[NSString stringWithFormat:@"%@ReactionPairIDKey", kDecodeKeyPrefix]];
    [coder encodeInt:count forKey:[NSString stringWithFormat:@"%@ReactionPairCountKey", kDecodeKeyPrefix]];
}

@end
