//
//  Bank.m
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import "Bank.h"

extern NSString *kDecodeKeyPrefix;

@implementation Bank
@synthesize _id, firstName, lastName, phone;
@synthesize accountNumber, accountOwner;
@synthesize email, dateUpdated;


- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [[Bank alloc] init])
    {
        self._id = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@BankIDKey", kDecodeKeyPrefix]];
        self.accountNumber = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@BankAccountNumberKey", kDecodeKeyPrefix]];
        self.accountOwner = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@BankAccountOwnerKey", kDecodeKeyPrefix]];
        
		self.firstName = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@BankFirstNameKey", kDecodeKeyPrefix]];
        self.lastName = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@BankLastNameKey", kDecodeKeyPrefix]];
        self.phone = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@BankPhoneKey", kDecodeKeyPrefix]];
		self.email = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@BankEmailKey", kDecodeKeyPrefix]];
        self.dateUpdated = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@BankDateUpdatedKey", kDecodeKeyPrefix]];
	}
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:_id forKey:[NSString stringWithFormat:@"%@BankIDKey", kDecodeKeyPrefix]];
    [coder encodeObject:accountNumber forKey:[NSString stringWithFormat:@"%@BankAccountNumberKey", kDecodeKeyPrefix]];
    [coder encodeObject:accountOwner forKey:[NSString stringWithFormat:@"%@BankAccountOwnerKey", kDecodeKeyPrefix]];
	[coder encodeObject:firstName forKey:[NSString stringWithFormat:@"%@BankFirstNameKey", kDecodeKeyPrefix]];
    [coder encodeObject:lastName forKey:[NSString stringWithFormat:@"%@BankLastNameKey", kDecodeKeyPrefix]];
    [coder encodeObject:phone forKey:[NSString stringWithFormat:@"%@BankPhoneKey", kDecodeKeyPrefix]];

	[coder encodeObject:email forKey:[NSString stringWithFormat:@"%@BankEmailKey", kDecodeKeyPrefix]];
    [coder encodeObject:dateUpdated forKey:[NSString stringWithFormat:@"%@BankDateUpdatedKey", kDecodeKeyPrefix]];
}

-(NSString *) toString
{
    return [NSString stringWithFormat:@"Bank %@", self.accountNumber];
}
- (void)dealloc {
    [accountNumber release];
    [accountOwner release];
	[firstName release];
    [lastName release];
    [phone release];
	[_id release];
	[email release];
    [dateUpdated release];
    [super dealloc];
}

@end
