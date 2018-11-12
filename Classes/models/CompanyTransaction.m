//
//  CompanyTransaction.m
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import "CompanyTransaction.h"

extern NSString *kDecodeKeyPrefix;

@implementation CompanyTransaction
@synthesize _id, companyId, companyName;
@synthesize userId, description, amount;
@synthesize complete, visibility, dateUpdated;

- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [[CompanyTransaction alloc] init])
    {
        self._id = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@CompanyTransactionIDKey", kDecodeKeyPrefix]];
        self.companyId = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@CompanyTransactionComapnyIDKey", kDecodeKeyPrefix]];
        self.companyName = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@CompanyTransactionNameKey", kDecodeKeyPrefix]];
        self.userId = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@CompanyTransactionUserIDKey", kDecodeKeyPrefix]];
        self.description = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@CompanyTransactionDescriptionKey", kDecodeKeyPrefix]];
        self.amount = [coder decodeDoubleForKey:[NSString stringWithFormat:@"%@CompanyTransactionAmountKey", kDecodeKeyPrefix]];
		self.complete = [coder decodeIntForKey:[NSString stringWithFormat:@"%@CompanyTransactionCompleteKey", kDecodeKeyPrefix]];
        self.visibility = [coder decodeIntForKey:[NSString stringWithFormat:@"%@CompanyTransactionVisibilityKey", kDecodeKeyPrefix]];
        self.dateUpdated = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@CompanyTransactionDateUpdatedKey", kDecodeKeyPrefix]];
	}
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:_id forKey:[NSString stringWithFormat:@"%@CompanyTransactionIDKey", kDecodeKeyPrefix]];
    [coder encodeObject:companyId forKey:[NSString stringWithFormat:@"%@CompanyTransactionComapnyIDKey", kDecodeKeyPrefix]];
    [coder encodeObject:companyName forKey:[NSString stringWithFormat:@"%@CompanyTransactionNameKey", kDecodeKeyPrefix]];
    [coder encodeObject:userId forKey:[NSString stringWithFormat:@"%@CompanyTransactionUserIDKey", kDecodeKeyPrefix]];
    [coder encodeObject:description forKey:[NSString stringWithFormat:@"%@CompanyTransactionDescriptionKey", kDecodeKeyPrefix]];
    [coder encodeDouble:amount forKey:[NSString stringWithFormat:@"%@CompanyTransactionAmountKey", kDecodeKeyPrefix]];
	[coder encodeInt:complete forKey:[NSString stringWithFormat:@"%@CompanyTransactionCompleteKey", kDecodeKeyPrefix]];
    [coder encodeInt:visibility forKey:[NSString stringWithFormat:@"%@CompanyTransactionVisibilityKey", kDecodeKeyPrefix]];
    [coder encodeObject:dateUpdated forKey:[NSString stringWithFormat:@"%@CompanyTransactionDateUpdatedKey", kDecodeKeyPrefix]];
}

- (void)dealloc {
    [companyId release];
    [companyName release];
    [userId release];
    [description release];
	[_id release];
    [dateUpdated release];
    
    [super dealloc];
}

@end
