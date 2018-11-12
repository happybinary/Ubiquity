//
//  CreditCard.h
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CreditCard : NSObject {
    NSString *_id;
    NSString *cardHolder;
    NSString *cardNumber;
    NSString *expiryDate;
    NSString *cvv;
    BOOL isPrimary;
    
	NSString *firstName;
    NSString *lastName;
	NSString *phone;
	NSString *email;
    NSString *address;
    NSString *dateUpdated;
}

@property (nonatomic, retain) NSString *_id;
@property (nonatomic, retain) NSString *cardHolder;
@property (nonatomic, retain) NSString *cardNumber;
@property (nonatomic, retain) NSString *expiryDate;
@property (nonatomic, retain) NSString *cvv;
@property (nonatomic) BOOL isPrimary;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *dateUpdated;

-(NSString *) toString;
-(NSString *) toStringNumber;

@end
