//
//  Bank.h
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Bank : NSObject {
    NSString *_id;
    NSString *accountNumber;
    NSString *accountOwner;
	NSString *firstName;
    NSString *lastName;
	NSString *phone;
	NSString *email;
    NSString *dateUpdated;
}

@property (nonatomic, retain) NSString *_id;
@property (nonatomic, retain) NSString *accountNumber;
@property (nonatomic, retain) NSString *accountOwner;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *dateUpdated;

-(NSString *) toString;
@end
