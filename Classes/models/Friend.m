//
//  Friend.m
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import "Friend.h"

extern NSString *kDecodeKeyPrefix;

static Friend *CURRENT_FRIEND = nil;

@implementation Friend
@synthesize _id, firstName, lastName, username;
@synthesize imageLogoUrl, imageDefaultIndex;

+ (void)initialize {
    if(!CURRENT_FRIEND) {
        //CURRENT_FRIEND = @"Default Friend";
    }
}

- (id)initWithName:(NSString *)aFirstName
              last:(NSString *)aLastName
              user:(NSString *)aUserName
      imageLogoUrl:(NSString *)aImageLogoUrl
        imageIndex:(NSInteger) aImageIndex
{
	if (self = [super init]) {
		[self setFirstName:aFirstName];
        [self setLastName:aLastName];
        [self setUsername:aUserName];
		[self setImageLogoUrl:aImageLogoUrl];
		[self setImageDefaultIndex:aImageIndex];
        
        [self set_id:nil];
	}
    
    return self;
}

-(NSString *) getFullName
{
    return [NSString  stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

-(NSString *) getUsername
{
    return [NSString  stringWithFormat:@"@%@", self.username];
}

-(NSString *) toString
{
    return [self getFullName];
}

- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [[Friend alloc] init])
    {
		self.firstName = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@FriendFirstNameKey", kDecodeKeyPrefix]];
        self.lastName = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@FriendLastNameKey", kDecodeKeyPrefix]];
        self.username = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@FriendUserNameKey", kDecodeKeyPrefix]];
        self._id = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@FriendIDKey", kDecodeKeyPrefix]];
		self.imageLogoUrl = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@FriendImageLogoUrlKey", kDecodeKeyPrefix]];
		self.imageDefaultIndex = [coder decodeIntegerForKey:[NSString stringWithFormat:@"%@FriendImageDefaultIndexKey", kDecodeKeyPrefix]];
	}
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
	[coder encodeObject:firstName forKey:[NSString stringWithFormat:@"%@FriendFirstNameKey", kDecodeKeyPrefix]];
    [coder encodeObject:lastName forKey:[NSString stringWithFormat:@"%@FriendLastNameKey", kDecodeKeyPrefix]];
    [coder encodeObject:username forKey:[NSString stringWithFormat:@"%@FriendUserNameKey", kDecodeKeyPrefix]];
    [coder encodeObject:_id forKey:[NSString stringWithFormat:@"%@FriendIDKey", kDecodeKeyPrefix]];
	[coder encodeObject:imageLogoUrl forKey:[NSString stringWithFormat:@"%@FriendImageLogoUrlKey", kDecodeKeyPrefix]];
	[coder encodeInteger:imageDefaultIndex forKey:[NSString stringWithFormat:@"%@FriendImageDefaultIndexKey", kDecodeKeyPrefix]];
}

+(Friend *) getCurrentFriend
{
    return CURRENT_FRIEND;
}
+(void) setCurrentFriend:(Friend *)aFriend
{
    if(CURRENT_FRIEND != aFriend) {
        [CURRENT_FRIEND release];
        CURRENT_FRIEND = [aFriend retain];
    }
}

- (void)dealloc {
	[firstName release];
    [lastName release];
    [username release];
	[_id release];
	[imageLogoUrl release];
    [super dealloc];
}

@end
