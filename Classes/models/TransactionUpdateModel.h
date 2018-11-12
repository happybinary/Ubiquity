//
//  TransactionUpdateModel.h
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TransactionUpdateModel : NSObject {
    NSString *balance;
	NSMutableArray *transactionList;
}

@property (nonatomic, retain) NSString *balance;
@property (nonatomic, retain) NSMutableArray *transactionList;

@end
