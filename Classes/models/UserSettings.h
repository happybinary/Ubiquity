//
//  UserSettings.h
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserSettings : NSObject {
    int paymentNotification;
    int requestNotification;
    int systemNotification;
    int soundOn;
    int vibrateOn;
    int emailVerified;
    int driversLicenseVerified;
    int privateProfile;
    int boltVisibilityDefault;
}

@property (nonatomic) int paymentNotification;
@property (nonatomic) int requestNotification;
@property (nonatomic) int systemNotification;
@property (nonatomic) int soundOn;
@property (nonatomic) int vibrateOn;
@property (nonatomic) int emailVerified;
@property (nonatomic) int driversLicenseVerified;
@property (nonatomic) int privateProfile;
@property (nonatomic) int boltVisibilityDefault;

@end
