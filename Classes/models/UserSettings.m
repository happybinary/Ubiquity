//
//  UserSettings.m
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import "UserSettings.h"

extern NSString *kDecodeKeyPrefix;

@implementation UserSettings
@synthesize paymentNotification, requestNotification;
@synthesize systemNotification;
@synthesize soundOn, vibrateOn, emailVerified;
@synthesize driversLicenseVerified;
@synthesize privateProfile;
@synthesize boltVisibilityDefault;


- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [[UserSettings alloc] init])
    {
        self.paymentNotification = [coder decodeIntForKey:[NSString stringWithFormat:@"%@UserSettingsPaymentKey", kDecodeKeyPrefix]];
        self.requestNotification = [coder decodeIntForKey:[NSString stringWithFormat:@"%@UserSettingsRequestKey", kDecodeKeyPrefix]];
        self.systemNotification = [coder decodeIntForKey:[NSString stringWithFormat:@"%@UserSettingsSystemKey", kDecodeKeyPrefix]];
        self.soundOn = [coder decodeIntForKey:[NSString stringWithFormat:@"%@UserSettingsSoundOnKey", kDecodeKeyPrefix]];
        
        self.vibrateOn = [coder decodeIntForKey:[NSString stringWithFormat:@"%@UserSettingsVibrateOnKey", kDecodeKeyPrefix]];
        self.emailVerified = [coder decodeIntForKey:[NSString stringWithFormat:@"%@UserSettingsEmailKey", kDecodeKeyPrefix]];
        self.driversLicenseVerified = [coder decodeIntForKey:[NSString stringWithFormat:@"%@UserSettingsDriverKey", kDecodeKeyPrefix]];
        self.privateProfile = [coder decodeIntForKey:[NSString stringWithFormat:@"%@UserSettingsProfileKey", kDecodeKeyPrefix]];
        self.boltVisibilityDefault = [coder decodeIntForKey:[NSString stringWithFormat:@"%@UserSettingsBoltVisibilityKey", kDecodeKeyPrefix]];
	}
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeInt:paymentNotification forKey:[NSString stringWithFormat:@"%@UserSettingsPaymentKey", kDecodeKeyPrefix]];
    [coder encodeInt:requestNotification forKey:[NSString stringWithFormat:@"%@UserSettingsRequestKey", kDecodeKeyPrefix]];
    [coder encodeInt:systemNotification forKey:[NSString stringWithFormat:@"%@UserSettingsSystemKey", kDecodeKeyPrefix]];
    [coder encodeInt:soundOn forKey:[NSString stringWithFormat:@"%@UserSettingsSoundOnKey", kDecodeKeyPrefix]];
    
    [coder encodeInt:vibrateOn forKey:[NSString stringWithFormat:@"%@UserSettingsVibrateOnKey", kDecodeKeyPrefix]];
    [coder encodeInt:emailVerified forKey:[NSString stringWithFormat:@"%@UserSettingsEmailKey", kDecodeKeyPrefix]];
    [coder encodeInt:driversLicenseVerified forKey:[NSString stringWithFormat:@"%@UserSettingsDriverKey", kDecodeKeyPrefix]];
    [coder encodeInt:privateProfile forKey:[NSString stringWithFormat:@"%@UserSettingsProfileKey", kDecodeKeyPrefix]];
    [coder encodeInt:boltVisibilityDefault forKey:[NSString stringWithFormat:@"%@UserSettingsBoltVisibilityKey", kDecodeKeyPrefix]];
}

@end
