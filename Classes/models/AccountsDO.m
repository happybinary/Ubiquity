//
//  AccountsDO.m
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import "AccountsDO.h"
#import "Bank.h"
#import "CreditCard.h"

extern NSString *kDecodeKeyPrefix;

@implementation AccountsDO
@synthesize creditCards, bank;

- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [[AccountsDO alloc] init])
    {
        self.bank = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@AccountsDOBankKey", kDecodeKeyPrefix]];
        self.creditCards = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@AccountsDOCreditCardKey", kDecodeKeyPrefix]];
	}
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:bank forKey:[NSString stringWithFormat:@"%@AccountsDOIDKey", kDecodeKeyPrefix]];
    [coder encodeObject:creditCards forKey:[NSString stringWithFormat:@"%@AccountsDOCreditCardKey", kDecodeKeyPrefix]];
}

- (void)dealloc {
    [creditCards release];
	[bank release];

    [super dealloc];
}

@end
