//
//  Friend.h
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject {
    NSString *_id;
	NSString *firstName;
    NSString *lastName;
	NSString *username;

	NSString *imageLogoUrl;
	NSInteger imageDefaultIndex;
}

@property (nonatomic, retain) NSString *_id;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *imageLogoUrl;
@property (nonatomic) NSInteger imageDefaultIndex;

- (id)initWithName:(NSString *)aFirstName
              last:(NSString *)aLastName
              user:(NSString *)aUserName
      imageLogoUrl:(NSString *)aImageLogoUrl
        imageIndex:(NSInteger) aImageIndex;

-(NSString *) getFullName;
-(NSString *) getUsername;
-(NSString *) toString;

+(Friend *) getCurrentFriend;
+(void) setCurrentFriend:(Friend *)aFriend;



@end
