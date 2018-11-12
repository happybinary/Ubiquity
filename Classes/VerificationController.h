//
//  VerificationController.h
//  Global Directories
//
//  Created by Steve Ma on 12/17/13.
//  Copyright 2009 InformationPages.com, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>

#if GoogleAnalyticsTracker
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#endif

@interface VerificationController :
#if GoogleAnalyticsTracker
GAITrackedViewController
#else
UIViewController
#endif
<UITextFieldDelegate, UIGestureRecognizerDelegate, UITextViewDelegate, CAAnimationDelegate>
{
	UIActivityIndicatorView * verifyActivityIndicator;
    
    UIButton *goBackButton;
    UIButton *verifyButton;
    
    UITextField *firstTextField;
    UITextField *secondTextField;
    UITextField *thirdTextField;
    UITextField *fourthTextField;
    
    UIView *resendContainer;
    UITextView *resendTextView;
    
    Boolean mIsParentBottomTabBarHidden;
    
    UIView * mainHomeView;
    
    CAGradientLayer *m_Gradientlayer;
    NSMutableArray * m_GradientColorSet;
    int m_CurrentGradient;
    
    UILabel *verificationTitleLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *verificationTitleLabel;

@property (nonatomic, retain) IBOutlet UIView * mainHomeView;

@property (nonatomic, retain) CAGradientLayer *m_Gradientlayer;
@property (nonatomic, retain) NSMutableArray * m_GradientColorSet;
@property (nonatomic) int m_CurrentGradient;

@property (nonatomic) Boolean mIsParentBottomTabBarHidden;

@property (nonatomic, retain) IBOutlet UITextField *firstTextField;
@property (nonatomic, retain) IBOutlet UITextField *secondTextField;
@property (nonatomic, retain) IBOutlet UITextField *thirdTextField;
@property (nonatomic, retain) IBOutlet UITextField *fourthTextField;

@property (nonatomic, retain) IBOutlet UIView *resendContainer;
@property (nonatomic, retain) IBOutlet UITextView *resendTextView;
@property (nonatomic, retain) IBOutlet UIButton *verifyButton;

@property (nonatomic, retain) IBOutlet UIButton *goBackButton;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView * verifyActivityIndicator;

-(IBAction)goBackSearchList:(id)sender;
-(IBAction)verifyButtonClicked:(id)sender;

@end
