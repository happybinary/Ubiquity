//
//  ForgotPasswordViewController.h
//  Global Directories
//
//  Created by Steve Ma on 8/13/13.
//
//

#import <UIKit/UIKit.h>

#if GoogleAnalyticsTracker
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#endif

@interface ForgotPasswordViewController :
#if GoogleAnalyticsTracker
GAITrackedViewController
#else
UIViewController
#endif

<UITextViewDelegate, CAAnimationDelegate>
{
    UILabel *forgotTitleLabel;

    UIButton *goBackButton;
    
    UILabel *emailGuideLable;
    UITextField *mobileNumberField;
    UITextField *newpasswordTextField;
    
    UILabel *infoTextLable;
    UIButton *sendEmailButton;

    UIActivityIndicatorView * signinActivityIndicator;

    UIView * mainHomeView;
    
    CAGradientLayer *m_EmailBottomlayer;
    CAGradientLayer *m_PasswordBottomlayer;
    
    CAGradientLayer *m_Gradientlayer;
    NSMutableArray * m_GradientColorSet;
    int m_CurrentGradient;
}
@property (nonatomic, retain) IBOutlet UILabel *forgotTitleLabel;

@property (nonatomic, retain) CAGradientLayer *m_Gradientlayer;
@property (nonatomic, retain) NSMutableArray * m_GradientColorSet;
@property (nonatomic) int m_CurrentGradient;

@property (nonatomic, retain) CAGradientLayer *m_EmailBottomlayer;
@property (nonatomic, retain) CAGradientLayer *m_PasswordBottomlayer;

@property (nonatomic, retain) IBOutlet UIView * mainHomeView;

@property (nonatomic, retain) IBOutlet UIButton *goBackButton;

@property (nonatomic, retain) IBOutlet UILabel *emailGuideLable;
@property (nonatomic, retain) IBOutlet UITextField *mobileNumberField;
@property (nonatomic, retain) IBOutlet UITextField *newpasswordTextField;

@property (nonatomic, retain) IBOutlet UILabel *infoTextLable;
@property (nonatomic, retain) IBOutlet UIButton *sendEmailButton;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView * signinActivityIndicator;

-(IBAction)sendEmailButtonClick:(id)sender;
-(IBAction)menuCloseButtonClick:(id)sender;
- (IBAction)textFieldDidChange: (id)sender;

@end

