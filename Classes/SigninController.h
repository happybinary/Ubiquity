//
//  SigninController.h
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

#import "LoginVerifyDelegate.h"
#import "InfoPagesControllerDelegate.h"

@interface SigninController :
#if GoogleAnalyticsTracker
GAITrackedViewController
#else
UIViewController
#endif

<UITextFieldDelegate, UIGestureRecognizerDelegate, IPKeyboardControlsDelegate, UITextViewDelegate, LoginVerifyDelegate, CAAnimationDelegate, InfoPagesControllerDelegate>
{
    UIButton *keepmeLoggedButton1;
    UIButton *keepmeLoggedButton2;
    UIButton *forgotPasswordButton;
    
    UIView *signupContainer;
    UITextView *signupTextView;
    
	UIActivityIndicatorView * signinActivityIndicator;
    
    UIButton *loginSigninButton;
    
    UITextField *mobileNumberTextField;
    UITextField *passwordTextField;
    
    CAGradientLayer *m_EmailBottomlayer;
    CAGradientLayer *m_PasswordBottomlayer;
    
    UILabel *emailInfoLabel;
    UILabel *passwordInfoLabel;
    
    IPKeyboardControls *keyboardControls;
    
    id <LoginVerifyDelegate> delegate;
    Boolean mIsParentBottomTabBarHidden;
    
    UIView * mainHomeView;
    
    CAGradientLayer *m_Gradientlayer;
    NSMutableArray * m_GradientColorSet;
    int m_CurrentGradient;
}
@property (nonatomic, retain) IBOutlet UIView * mainHomeView;

@property (nonatomic, retain) CAGradientLayer *m_Gradientlayer;
@property (nonatomic, retain) NSMutableArray * m_GradientColorSet;
@property (nonatomic) int m_CurrentGradient;

@property (nonatomic) Boolean mIsParentBottomTabBarHidden;

@property (nonatomic, retain) IBOutlet UIButton *keepmeLoggedButton1;
@property (nonatomic, retain) IBOutlet UIButton *keepmeLoggedButton2;
@property (nonatomic, retain) IBOutlet UIButton *forgotPasswordButton;

@property (nonatomic, retain) IBOutlet UIView *signupContainer;
@property (nonatomic, retain) IBOutlet UITextView *signupTextView;

@property (nonatomic, retain) id <LoginVerifyDelegate> delegate;
@property (nonatomic, retain) IPKeyboardControls *keyboardControls;

@property (nonatomic, retain) IBOutlet UITextField *mobileNumberTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;

@property (nonatomic, retain) CAGradientLayer *m_EmailBottomlayer;
@property (nonatomic, retain) CAGradientLayer *m_PasswordBottomlayer;

@property (nonatomic, retain) IBOutlet UILabel *emailInfoLabel;
@property (nonatomic, retain) IBOutlet UILabel *passwordInfoLabel;

@property (nonatomic, retain) IBOutlet UIButton *loginSigninButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView * signinActivityIndicator;

-(IBAction)loginSigninClicked:(id)sender;
- (IBAction)textFieldDidChange: (id)sender;
-(IBAction)keepMeLogginedInClicked:(id)sender;
-(IBAction)forgotPasswordClicked:(id)sender;

@end
