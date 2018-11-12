//
//  CreditCard.m
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import "CreditCard.h"

extern NSString *kDecodeKeyPrefix;

@implementation CreditCard
@synthesize _id, firstName, lastName, phone;
@synthesize cardHolder, cardNumber;
@synthesize expiryDate, cvv, isPrimary;
@synthesize email, dateUpdated;
@synthesize address;

- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [[CreditCard alloc] init])
    {
        self._id = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@CreditCardIDKey", kDecodeKeyPrefix]];
        self.cardHolder = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@CreditCardHolderKey", kDecodeKeyPrefix]];
        self.cardNumber = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@CreditCardOwnerKey", kDecodeKeyPrefix]];
        self.expiryDate = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@CreditCardExpireKey", kDecodeKeyPrefix]];
        self.cvv = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@CreditCardCVVKey", kDecodeKeyPrefix]];
        self.isPrimary = [coder decodeBoolForKey:[NSString stringWithFormat:@"%@CreditCardPrimaryKey", kDecodeKeyPrefix]];
		self.firstName = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@CreditCardFirstNameKey", kDecodeKeyPrefix]];
        self.lastName = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@CreditCardLastNameKey", kDecodeKeyPrefix]];
        self.address = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@CreditCardAddressKey", kDecodeKeyPrefix]];
        self.phone = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@CreditCardPhoneKey", kDecodeKeyPrefix]];
		self.email = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@CreditCardEmailKey", kDecodeKeyPrefix]];
        self.dateUpdated = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@CreditCardDateUpdatedKey", kDecodeKeyPrefix]];
	}
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:_id forKey:[NSString stringWithFormat:@"%@CreditCardIDKey", kDecodeKeyPrefix]];
    [coder encodeObject:cardHolder forKey:[NSString stringWithFormat:@"%@CreditCardHolderKey", kDecodeKeyPrefix]];
    [coder encodeObject:cardNumber forKey:[NSString stringWithFormat:@"%@CreditCardOwnerKey", kDecodeKeyPrefix]];
    [coder encodeObject:expiryDate forKey:[NSString stringWithFormat:@"%@CreditCardExpireKey", kDecodeKeyPrefix]];
    [coder encodeObject:cvv forKey:[NSString stringWithFormat:@"%@CreditCardCVVKey", kDecodeKeyPrefix]];
    [coder encodeBool:isPrimary forKey:[NSString stringWithFormat:@"%@CreditCardPrimaryKey", kDecodeKeyPrefix]];
	[coder encodeObject:firstName forKey:[NSString stringWithFormat:@"%@CreditCardFirstNameKey", kDecodeKeyPrefix]];
    [coder encodeObject:lastName forKey:[NSString stringWithFormat:@"%@CreditCardLastNameKey", kDecodeKeyPrefix]];
    [coder encodeObject:address forKey:[NSString stringWithFormat:@"%@CreditCardAddressKey", kDecodeKeyPrefix]];
    [coder encodeObject:phone forKey:[NSString stringWithFormat:@"%@CreditCardPhoneKey", kDecodeKeyPrefix]];
	[coder encodeObject:email forKey:[NSString stringWithFormat:@"%@CreditCardEmailKey", kDecodeKeyPrefix]];
    [coder encodeObject:dateUpdated forKey:[NSString stringWithFormat:@"%@CreditCardDateUpdatedKey", kDecodeKeyPrefix]];
}

-(NSString *) toString
{
    return [NSString stringWithFormat:@"Card XXXX-XXXX-XXXX-%@", [self.cardNumber substringFromIndex:12]];

}
-(NSString *) toStringNumber
{
     return [NSString stringWithFormat:@"XXXX-XXXX-XXXX-%@", [self.cardNumber substringFromIndex:12]];
}

- (void)dealloc {
    [cardHolder release];
    [cardNumber release];
    [expiryDate release];
    [cvv release];
	[firstName release];
    [lastName release];
    [address release];
    [phone release];
	[_id release];
	[email release];
    [dateUpdated release];
    
    [super dealloc];
}

@end
