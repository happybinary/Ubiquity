//
//  SignupController.h
//  Global Directories
//
//  Created by Steve Ma on 12/17/13.
//  Copyright 2009 InformationPages.com, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPKeyboardControls.h"

#if GoogleAnalyticsTracker
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#endif

@interface SignupController :
#if GoogleAnalyticsTracker
GAITrackedViewController
#else
UIViewController
#endif
<UITextFieldDelegate, UIGestureRecognizerDelegate, IPKeyboardControlsDelegate, UITextViewDelegate, CAAnimationDelegate>
{
	UIActivityIndicatorView * signupActivityIndicator;
    
    UIButton *goBackButton;
    UIButton *signupButton;
    
    UITextField *mobileNumberTextField;
    UITextField *emailTextField;
    UITextField *passwordTextField;
    UITextField *confirmPasswordTextField;
    
    UITextField *firstNameTextField;
    UITextField *lastNameTextField;
    
    UIView *signinContainer;
    UITextView *signinTextView;
   
    IPKeyboardControls *keyboardControls;
    
    Boolean mIsParentBottomTabBarHidden;
    
    UIView * mainHomeView;
    
    CAGradientLayer *m_FirstNameBottomlayer;
    CAGradientLayer *m_LastNameBottomlayer;
    CAGradientLayer *m_EmailBottomlayer;
    CAGradientLayer *m_PasswordBottomlayer;
    CAGradientLayer *m_RepeatPasswordBottomlayer;
    CAGradientLayer *m_MobileNumberBottomlayer;
    
    CAGradientLayer *m_Gradientlayer;
    NSMutableArray * m_GradientColorSet;
    int m_CurrentGradient;
    
    UILabel *signupTitleLabel;

    UITextView * termPolicyTextView;
}

@property (nonatomic, retain) IBOutlet UILabel *signupTitleLabel;

@property (nonatomic, retain) IBOutlet UITextView * termPolicyTextView;

@property (nonatomic, retain) IBOutlet UIView * mainHomeView;

@property (nonatomic, retain) CAGradientLayer *m_Gradientlayer;
@property (nonatomic, retain) NSMutableArray * m_GradientColorSet;
@property (nonatomic) int m_CurrentGradient;

@property (nonatomic, retain) CAGradientLayer *m_FirstNameBottomlayer;
@property (nonatomic, retain) CAGradientLayer *m_LastNameBottomlayer;
@property (nonatomic, retain) CAGradientLayer *m_EmailBottomlayer;
@property (nonatomic, retain) CAGradientLayer *m_PasswordBottomlayer;
@property (nonatomic, retain) CAGradientLayer *m_RepeatPasswordBottomlayer;
@property (nonatomic, retain) CAGradientLayer *m_MobileNumberBottomlayer;

@property (nonatomic) Boolean mIsParentBottomTabBarHidden;

@property (nonatomic, retain) IPKeyboardControls *keyboardControls;

@property (nonatomic, retain) IBOutlet UITextField *emailTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;
@property (nonatomic, retain) IBOutlet UITextField *mobileNumberTextField;
@property (nonatomic, retain) IBOutlet UITextField *confirmPasswordTextField;

@property (nonatomic, retain) IBOutlet UITextField *firstNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *lastNameTextField;

@property (nonatomic, retain) IBOutlet UIView *signinContainer;
@property (nonatomic, retain) IBOutlet UITextView *signinTextView;
@property (nonatomic, retain) IBOutlet UIButton *signupButton;

@property (nonatomic, retain) IBOutlet UIButton *goBackButton;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView * signupActivityIndicator;

-(IBAction)goBackSearchList:(id)sender;
-(IBAction)signupClicked:(id)sender;
- (IBAction)textFieldDidChange: (id)sender;

@end
