//
//  GroupTransaction.h
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Transaction;

@interface GroupTransaction : NSObject {
    NSString *groupId;
	NSString *splitCorrelationId;
	NSMutableArray<Transaction *> *transactions;
}

@property (nonatomic, retain) NSString *groupId;
@property (nonatomic, retain) NSString *splitCorrelationId;
@property (nonatomic, retain) NSMutableArray<Transaction *> *transactions;

@end
