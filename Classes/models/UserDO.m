//
//  UserDO.m
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import "UserDO.h"

extern NSString *kDecodeKeyPrefix;

@implementation UserDO
@synthesize _id, firstName, lastName, pin;
@synthesize username, address;
@synthesize fingerprint, password;
@synthesize balance;


- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [[UserDO alloc] init])
    {
        self._id = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@UserDOIDKey", kDecodeKeyPrefix]];
        self.username = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@UserDOUserNameKey", kDecodeKeyPrefix]];
        self.firstName = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@UserDOFirstNameKey", kDecodeKeyPrefix]];
        self.lastName = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@UserDOLastNameKey", kDecodeKeyPrefix]];
        self.address = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@UserDOAddressKey", kDecodeKeyPrefix]];
        self.pin = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@UserDOPINKey", kDecodeKeyPrefix]];
		self.fingerprint = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@UserDOFingerKey", kDecodeKeyPrefix]];
        self.password = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@UserDOPasswordKey", kDecodeKeyPrefix]];
        self.balance = [coder decodeDoubleForKey:[NSString stringWithFormat:@"%@UserDOBalanceKey", kDecodeKeyPrefix]];

	}
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:_id forKey:[NSString stringWithFormat:@"%@UserDOIDKey", kDecodeKeyPrefix]];
    [coder encodeObject:username forKey:[NSString stringWithFormat:@"%@UserDOUserNameKey", kDecodeKeyPrefix]];
    [coder encodeObject:address forKey:[NSString stringWithFormat:@"%@UserDOAddressKey", kDecodeKeyPrefix]];
	[coder encodeObject:firstName forKey:[NSString stringWithFormat:@"%@UserDOFirstNameKey", kDecodeKeyPrefix]];
    [coder encodeObject:lastName forKey:[NSString stringWithFormat:@"%@UserDOLastNameKey", kDecodeKeyPrefix]];
    [coder encodeObject:pin forKey:[NSString stringWithFormat:@"%@UserDOPINKey", kDecodeKeyPrefix]];
	[coder encodeObject:fingerprint forKey:[NSString stringWithFormat:@"%@UserDOFingerKey", kDecodeKeyPrefix]];
    [coder encodeObject:password forKey:[NSString stringWithFormat:@"%@UserDOPasswordKey", kDecodeKeyPrefix]];
    [coder encodeDouble:balance forKey:[NSString stringWithFormat:@"%@UserDOBalanceKey", kDecodeKeyPrefix]];
}

-(NSString *) getUser
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];

}
-(NSString *) toString
{
    return self._id;
}
- (void)dealloc {
    [username release];
    [address release];
	[firstName release];
    [lastName release];
    [pin release];
	[_id release];
	[fingerprint release];
    [password release];
    [super dealloc];
}

@end
