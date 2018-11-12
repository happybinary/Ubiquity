//
//  Group.m
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import "Group.h"
#import "Friend.h"

extern NSString *kDecodeKeyPrefix;

@implementation Group
@synthesize _id, groupName, userID;
@synthesize friends, isDeleted;

- (id)initWithName:(NSString *)aGroupName
               uid:(NSString *)aUserID
        friendlist:(NSMutableArray<Friend *> *)friendList
          isDelete:(int) aDeleted
{
	if (self = [super init]) {
		[self setGroupName:aGroupName];
        [self setUserID:aUserID];
		[self setFriends:friendList];
		[self setIsDeleted:aDeleted];
        
        [self set_id:nil];
	}
    
    return self;
}

- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [[Group alloc] init])
    {
		self.groupName = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@GroupNameKey", kDecodeKeyPrefix]];
        self.userID = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@GroupUserNameKey", kDecodeKeyPrefix]];
        self._id = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@GroupIDKey", kDecodeKeyPrefix]];
		self.friends = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@GroupFriendListKey", kDecodeKeyPrefix]];
		self.isDeleted = [coder decodeIntForKey:[NSString stringWithFormat:@"%@GroupIsDeletedKey", kDecodeKeyPrefix]];
	}
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
	[coder encodeObject:groupName forKey:[NSString stringWithFormat:@"%@GroupNameKey", kDecodeKeyPrefix]];
    [coder encodeObject:userID forKey:[NSString stringWithFormat:@"%@GroupUserNameKey", kDecodeKeyPrefix]];
    [coder encodeObject:_id forKey:[NSString stringWithFormat:@"%@GroupIDKey", kDecodeKeyPrefix]];
	[coder encodeObject:friends forKey:[NSString stringWithFormat:@"%@GroupFriendListKey", kDecodeKeyPrefix]];
	[coder encodeInteger:isDeleted forKey:[NSString stringWithFormat:@"%@GroupIsDeletedKey", kDecodeKeyPrefix]];
}

- (void)dealloc {
	[groupName release];
    [userID release];
	[_id release];
	[friends release];
    [super dealloc];
}

@end
