//
//  UserDO.h
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserDO : NSObject {
    NSString *_id;
    NSString *username;
	NSString *firstName;
    NSString *lastName;
    NSString *address;
	NSString *pin;
	NSString *fingerprint;
    NSString *password;
    double balance;
}

@property (nonatomic, retain) NSString *_id;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *pin;
@property (nonatomic, retain) NSString *fingerprint;
@property (nonatomic, retain) NSString *password;
@property (nonatomic) double balance;

-(NSString *) getUser;
-(NSString *) toString;
@end
