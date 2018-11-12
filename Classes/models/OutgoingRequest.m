//
//  OutgoingRequest.m
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import "OutgoingRequest.h"

extern NSString *kDecodeKeyPrefix;

@implementation OutgoingRequest
@synthesize groupId, splitCorrelationId;
@synthesize transactions;
@synthesize isGroupRequest;

- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [[OutgoingRequest alloc] init])
    {
        self.groupId = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@OutgoingRequestGroupIDKey", kDecodeKeyPrefix]];
        self.splitCorrelationId = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@OutgoingRequestCorrelationKey", kDecodeKeyPrefix]];
        self.transactions = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@OutgoingRequestTListKey", kDecodeKeyPrefix]];
        self.isGroupRequest = [coder decodeBoolForKey:[NSString stringWithFormat:@"%@OutgoingRequestGroupRequestKey", kDecodeKeyPrefix]];
	}
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:groupId forKey:[NSString stringWithFormat:@"%@OutgoingRequestGroupIDKey", kDecodeKeyPrefix]];
    [coder encodeObject:splitCorrelationId forKey:[NSString stringWithFormat:@"%@OutgoingRequestCorrelationKey", kDecodeKeyPrefix]];
    [coder encodeObject:transactions forKey:[NSString stringWithFormat:@"%@OutgoingRequestTListKey", kDecodeKeyPrefix]];
    [coder encodeBool:isGroupRequest forKey:[NSString stringWithFormat:@"%@OutgoingRequestGroupRequestKey", kDecodeKeyPrefix]];
}

+(OutgoingRequest *) createGroupOutgoingRequest:(Transaction *)trans
{
    OutgoingRequest * o = [[OutgoingRequest alloc] init];
    o.isGroupRequest = YES;
    o.splitCorrelationId = trans.splitCorrelationId;
    o.groupId = trans.groupId;
    o.transactions = [NSMutableArray new];
    [o.transactions addObject:trans];
    
    return o;
}

+(OutgoingRequest *) createRegularOutgoingRequest:(Transaction *)trans
{
    OutgoingRequest * o = [[OutgoingRequest alloc] init];
    o.isGroupRequest = NO;
    o.transactions = [NSMutableArray new];
    [o.transactions addObject:trans];
    return o;
}

-(void) addToTransactionList:(Transaction *)trans
{
    [self.transactions addObject:trans];
}

- (void)dealloc {
    [splitCorrelationId release];
    [groupId release];
    [transactions release];
    [super dealloc];
}

@end
