//
//  AccountsDO.h
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Bank;
@class CreditCard;

@interface AccountsDO : NSObject {
    NSMutableArray<CreditCard *> *creditCards;
    Bank *bank;
}
@property (nonatomic, retain) NSMutableArray<CreditCard *> *creditCards;
@property (nonatomic, retain) Bank *bank;
@end
