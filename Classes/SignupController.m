//
//  SignupController.m
//  Global Directories
//
//  Created by Steve Ma on 12/17/13.
//  Copyright 2009 InformationPages.com, Inc.. All rights reserved.
//

#import "SignupController.h"
#import "AppGlobalData.h"
#import <QuartzCore/QuartzCore.h>
#import "ASIHTTPRequest.h"
#import "JSON/JSON.h"

#import "MFSideMenu.h"
#import "UIImageView+AFNetworking.h"
#import "UIColor+Hex.h"
#import "SigninController.h"
#import "SideMenuViewController.h"
#import "appDataDelegate.h"
#import "VerificationController.h"

#define IPAlert(title,msg) [[[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
#define MAIN_HEIGHT [AppGlobalData screenSize].height
#define MAIN_WIDTH [AppGlobalData screenSize].width

#define SYSTEM_VERSION_LESS_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
//#pragma GCC diagnostic warning "-Wdeprecated-declarations"

extern const NSString *Database_Connector_URL;

extern NSString *THE_APP_FontName;
extern NSString *THE_APP_BoldFontName;
extern NSString *THE_APP_Header_BoldFontName;
extern NSString *THE_APP_Header_DemiFontName;
extern NSString *THE_APP_Header_BookFontName;

extern const CGFloat Header_Text_Height_iPhone;
extern const CGFloat Header_Text_Height_iPad;

extern NSString *kHasUserSkippedLoginBefore;

extern const CGFloat X_Status_Bar_Height;
extern const CGFloat X_Bottom_Bar_Safe_Height;

extern const double TAB_BAR_HEIGHT;
extern const double TAB_BAR_X_HEIGHT;

@interface SignupController(mymethods)
// these are private methods that outside classes need not use
- (void)resetWithOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)toggleShowTabFooter:(BOOL)show inSeconds: (double)animationDuration;
@end

@implementation SignupController
@synthesize goBackButton, signupButton;
@synthesize signupActivityIndicator;
@synthesize mobileNumberTextField, emailTextField, passwordTextField, confirmPasswordTextField;
@synthesize keyboardControls;
@synthesize mIsParentBottomTabBarHidden;

@synthesize firstNameTextField, lastNameTextField;

@synthesize signinContainer, signinTextView;

@synthesize mainHomeView;
@synthesize m_Gradientlayer, m_GradientColorSet, m_CurrentGradient;

@synthesize m_FirstNameBottomlayer, m_LastNameBottomlayer;
@synthesize m_EmailBottomlayer, m_PasswordBottomlayer;
@synthesize m_RepeatPasswordBottomlayer, m_MobileNumberBottomlayer;

@synthesize signupTitleLabel, termPolicyTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
	
#if GoogleAnalyticsTracker
    self.screenName = @"Signup View Controller";
#endif
	[super viewDidLoad];
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	
	Class classUISwipeGestureRecognizer = NSClassFromString(@"UISwipeGestureRecognizer");
	if(classUISwipeGestureRecognizer != nil)
	{
		//from left to right
		UISwipeGestureRecognizer *backSwipeRecognizer = [[classUISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBackSearchList:)];
		
		if([backSwipeRecognizer respondsToSelector:@selector(locationInView:)])
		{
			backSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
			backSwipeRecognizer.delegate = self;
			[self.view addGestureRecognizer:backSwipeRecognizer];
			[backSwipeRecognizer release];
		}
		else
		{
			[backSwipeRecognizer release];
			backSwipeRecognizer = nil;
		}
        
	}
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeAll];
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        [self setExtendedLayoutIncludesOpaqueBars:YES];
    }
    
#endif
    [self.signupActivityIndicator setColor:[UIColor grayColor]];
    
    self.view.frame =(CGRect){{0,0}, {MAIN_WIDTH, MAIN_HEIGHT}};
    
    CGFloat mainHomeTop = 0;
    CGFloat mainHomeHeightDelta = 0;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 812)
        {
            mainHomeTop = X_Status_Bar_Height;
            mainHomeHeightDelta = X_Bottom_Bar_Safe_Height;
        }
    }
    self.mainHomeView.frame = CGRectMake(0, mainHomeTop, MAIN_WIDTH, MAIN_HEIGHT-mainHomeTop-mainHomeHeightDelta);
    
    [self.firstNameTextField setValue:[UIColor colorWithHexString:@"#B370bfd1"] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.lastNameTextField setValue:[UIColor colorWithHexString:@"#B370bfd1"] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.emailTextField setValue:[UIColor colorWithHexString:@"#B370bfd1"] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.passwordTextField setValue:[UIColor colorWithHexString:@"#B370bfd1"] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.confirmPasswordTextField setValue:[UIColor colorWithHexString:@"#B370bfd1"] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.mobileNumberTextField setValue:[UIColor colorWithHexString:@"#B370bfd1"] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.passwordTextField.secureTextEntry = YES;
    self.confirmPasswordTextField.secureTextEntry = YES;

    NSArray *fields = [[NSArray alloc] initWithObjects:
                       self.firstNameTextField, self.lastNameTextField,
                       self.emailTextField,
                       self.passwordTextField, self.confirmPasswordTextField, self.mobileNumberTextField,
                       nil];
    [self setKeyboardControls:[[IPKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
    
    if([self.signupActivityIndicator isAnimating])
    {
        [self.signupActivityIndicator stopAnimating];
    }
    
    [self.firstNameTextField setFont:[UIFont fontWithName:THE_APP_BoldFontName size:self.firstNameTextField.font.pointSize]];
    [self.lastNameTextField setFont:[UIFont fontWithName:THE_APP_BoldFontName size:self.lastNameTextField.font.pointSize]];
    [self.mobileNumberTextField setFont:[UIFont fontWithName:THE_APP_BoldFontName size:self.mobileNumberTextField.font.pointSize]];
   
    [self.emailTextField setFont:[UIFont fontWithName:THE_APP_BoldFontName size:self.emailTextField.font.pointSize]];
    [self.passwordTextField setFont:[UIFont fontWithName:THE_APP_BoldFontName size:self.passwordTextField.font.pointSize]];
     [self.confirmPasswordTextField setFont:[UIFont fontWithName:THE_APP_BoldFontName size:self.confirmPasswordTextField.font.pointSize]];
    
    [self.signupTitleLabel setFont:[UIFont fontWithName:THE_APP_BoldFontName size:self.signupTitleLabel.font.pointSize]];
    
    [self.signupButton.titleLabel setFont:[UIFont fontWithName:THE_APP_BoldFontName size:self.signupButton.titleLabel.font.pointSize]];
    self.signupButton.layer.cornerRadius = 24.0;
    
    NSString *signupText = @"Already have an account? Sign in here";
    UIColor *blueTextColor = [UIColor colorWithHexString:@"#7fbaff"];
    
    UIFont *signupTextNormal = [UIFont fontWithName:THE_APP_FontName size:self.signinTextView.font.pointSize];
    
    NSDictionary *signup_attribs = @{NSForegroundColorAttributeName: blueTextColor, NSFontAttributeName: signupTextNormal
                                     };
    NSMutableAttributedString *attributedSignupString = [[NSMutableAttributedString alloc] initWithString:signupText attributes:signup_attribs];
    
    [attributedSignupString addAttribute:NSLinkAttributeName
                                   value:@"CustomSignInOpen://signin"
                                   range:[[attributedSignupString string] rangeOfString:@"Sign in here"]];
    
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                     NSUnderlineColorAttributeName: [UIColor lightGrayColor],
                                     NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    
    self.signinTextView.linkTextAttributes = linkAttributes; // customizes the appearance of links
    self.signinTextView.attributedText = attributedSignupString;
    
    
    UIColor *blueTextTermColor = [UIColor colorWithHexString:@"#4782ca"];
    UIColor *termTextColor = [UIColor colorWithHexString:@"#c6d0de"];
    
    NSString *termText = @"Verification number will be sent in the phone number in 5 minutes. Once you click next you agree with \"Terms and condition\"";
    
    UIFont *termTextNormalFont = [UIFont fontWithName:THE_APP_BoldFontName size:self.termPolicyTextView.font.pointSize];
    
    NSDictionary *term_attribs = @{NSForegroundColorAttributeName: termTextColor, NSFontAttributeName: termTextNormalFont
                                     };
    NSMutableAttributedString *attributedTermString = [[NSMutableAttributedString alloc] initWithString:termText attributes:term_attribs];
    
    [attributedTermString addAttribute:NSLinkAttributeName
                                   value:@"CustomSignInOpen://terms"
                                   range:[[attributedTermString string] rangeOfString:@"Terms and condition"]];
    
    NSDictionary *linkTermAttributes = @{NSForegroundColorAttributeName: blueTextTermColor,
                                     NSUnderlineColorAttributeName: [UIColor lightGrayColor],
                                     NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    
    self.termPolicyTextView.linkTextAttributes = linkTermAttributes; // customizes the appearance of links
    self.termPolicyTextView.attributedText = attributedTermString;
    
    CGRect textRect = [attributedTermString boundingRectWithSize:CGSizeMake(MAIN_WIDTH-40, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    self.termPolicyTextView.textContainerInset = UIEdgeInsetsZero;

    self.termPolicyTextView.frame = CGRectMake(20, self.mainHomeView.frame.size.height - 16 - textRect.size.height, MAIN_WIDTH-40, textRect.size.height);
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
    {
        [self shouldAutorotate];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    AppGlobalData *sharedManager = [AppGlobalData sharedManager];
    
#if GoogleAnalyticsTracker
    [sharedManager.tracker set:kGAIScreenName value:self.screenName];
    [sharedManager.tracker send:[[GAIDictionaryBuilder createScreenView] build]];
#endif
    self.tabBarController.tabBar.hidden = NO;
    [self toggleShowTabFooter:NO inSeconds:0];
   
    self.signinTextView.editable = YES;
    self.signinTextView.scrollEnabled = YES;
    [self.signinTextView setFont:[UIFont fontWithName:THE_APP_BoldFontName size:self.signinTextView.font.pointSize]];
    self.signinTextView.textAlignment = NSTextAlignmentCenter;
    self.signinTextView.editable = NO;
    self.signinTextView.scrollEnabled = NO;
    
    self.termPolicyTextView.editable = YES;
    self.termPolicyTextView.scrollEnabled = YES;
    [self.termPolicyTextView setFont:[UIFont fontWithName:THE_APP_BoldFontName size:self.termPolicyTextView.font.pointSize]];
    self.termPolicyTextView.textAlignment = NSTextAlignmentCenter;
    self.termPolicyTextView.editable = NO;
    self.termPolicyTextView.scrollEnabled = NO;
    
    [super viewWillAppear:animated];
    
    [self addTextFieldGradientlayer];
    //[self addGradientlayer];
    [self.firstNameTextField becomeFirstResponder];

}

//for ios 6.0
- (BOOL)shouldAutorotate
{
    [self resetWithOrientation:self.interfaceOrientation];
    return UIInterfaceOrientationIsPortrait(self.interfaceOrientation);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

#pragma mark -
#pragma mark Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.keyboardControls setActiveField:textField];
    
    if(textField == self.firstNameTextField)
    {
        self.m_FirstNameBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#B370bfd1"].CGColor, (id)[UIColor colorWithHexString:@"#B370bfd1"].CGColor, nil];
    }
    else if(textField == self.lastNameTextField)
    {
        self.m_LastNameBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#B370bfd1"].CGColor, (id)[UIColor colorWithHexString:@"#B370bfd1"].CGColor, nil];
    }
    else if(textField == self.mobileNumberTextField)
    {
        self.m_MobileNumberBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#B370bfd1"].CGColor, (id)[UIColor colorWithHexString:@"#B370bfd1"].CGColor, nil];
    }
    else if(textField == self.confirmPasswordTextField)
    {
        self.m_RepeatPasswordBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#B370bfd1"].CGColor, (id)[UIColor colorWithHexString:@"#B370bfd1"].CGColor, nil];
    }
    else if(textField == self.emailTextField)
    {
        self.m_EmailBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#B370bfd1"].CGColor, (id)[UIColor colorWithHexString:@"#B370bfd1"].CGColor, nil];
    }
    else
    {
        self.m_PasswordBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#B370bfd1"].CGColor, (id)[UIColor colorWithHexString:@"#B370bfd1"].CGColor, nil];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField.text length] == 0)
    {
        if(textField == self.firstNameTextField)
        {
            self.m_FirstNameBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#8199BE"].CGColor, (id)[UIColor colorWithHexString:@"#8199BE"].CGColor, nil];
        }
        else if(textField == self.lastNameTextField)
        {
            self.m_LastNameBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#8199BE"].CGColor, (id)[UIColor colorWithHexString:@"#8199BE"].CGColor, nil];
        }
        else if(textField == self.mobileNumberTextField)
        {
            self.m_MobileNumberBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#8199BE"].CGColor, (id)[UIColor colorWithHexString:@"#8199BE"].CGColor, nil];
        }
        else if(textField == self.confirmPasswordTextField)
        {
            self.m_RepeatPasswordBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#8199BE"].CGColor, (id)[UIColor colorWithHexString:@"#8199BE"].CGColor, nil];
        }
        else if(textField == self.emailTextField)
        {
            self.m_EmailBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#8199BE"].CGColor, (id)[UIColor colorWithHexString:@"#8199BE"].CGColor, nil];
        }
        else
        {
            self.m_PasswordBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#8199BE"].CGColor, (id)[UIColor colorWithHexString:@"#8199BE"].CGColor, nil];
        }
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.mobileNumberTextField)
    {
        if ([string length] > 0)
        {
            NSCharacterSet *nonNumberSet = NSCharacterSet.decimalDigitCharacterSet.invertedSet;
            
            NSArray *compSepByCharInSet = [string componentsSeparatedByCharactersInSet:nonNumberSet];
            
            NSString * numberFiltered = [compSepByCharInSet componentsJoinedByString:@""];
            
            if([string isEqualToString:numberFiltered])
            {
            }
            else
            {
                textField.text  =  @"";
                return NO;
            }
        }
    }
    
    return YES;
}

- (IBAction)textFieldDidChange: (id)sender
{
    UITextField * textField = sender;
    
    if([textField.text length] > 0)
    {
        if(textField == self.firstNameTextField)
        {
            self.m_FirstNameBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#B370bfd1"].CGColor, (id)[UIColor colorWithHexString:@"#B370bfd1"].CGColor, nil];
        }
        else if(textField == self.lastNameTextField)
        {
            self.m_LastNameBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#B370bfd1"].CGColor, (id)[UIColor colorWithHexString:@"#B370bfd1"].CGColor, nil];
        }
        else if(textField == self.mobileNumberTextField)
        {
            self.m_MobileNumberBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#B370bfd1"].CGColor, (id)[UIColor colorWithHexString:@"#B370bfd1"].CGColor, nil];
        }
        else if(textField == self.confirmPasswordTextField)
        {
            self.m_RepeatPasswordBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#B370bfd1"].CGColor, (id)[UIColor colorWithHexString:@"#B370bfd1"].CGColor, nil];
        }
        else if(textField == self.emailTextField)
        {
            self.m_EmailBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#B370bfd1"].CGColor, (id)[UIColor colorWithHexString:@"#B370bfd1"].CGColor, nil];
        }
        else
        {
            self.m_PasswordBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#B370bfd1"].CGColor, (id)[UIColor colorWithHexString:@"#B370bfd1"].CGColor, nil];
        }
    }
    else
    {
        
    }
}

#pragma mark -
#pragma mark Keyboard Controls Delegate

- (void)keyboardControls:(IPKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(IPKeyboardControlsDirection)direction
{
    //    UIView *view;
    //
    //    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
    //        view = field.superview.superview;
    //    } else {
    //        view = field.superview.superview.superview;
    //    }
    //
    //    [self.tableView scrollRectToVisible:view.frame animated:YES];
}


- (void)keyboardControlsDonePressed:(IPKeyboardControls *)keyboardControls
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);

    [UIView commitAnimations];
    
    [self.view endEditing:YES];
}

-(IBAction)goBackSearchList:(id)sender
{
#if GoogleAnalyticsTracker
    if(sender == nil || [sender isKindOfClass:[UISwipeGestureRecognizer class]])
    {
        [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"GestureRecognizer"     // Event category (required)
                                                                                          action:@"Swipe"  // Event action (required)
                                                                                           label:@"Go Back"          // Event label
                                                                                           value:nil] build]];
    }
    else
    {
        [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Button"     // Event category (required)
                                                                                          action:@"Click"  // Event action (required)
                                                                                           label:@"Go Back"          // Event label
                                                                                           value:nil] build]];
    }
#endif
	[self.navigationController popViewControllerAnimated:YES];
    
	//[self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)signupClicked:(id)sender
{
    if(self.firstNameTextField.text.length == 0)
    {
        if ([UIAlertController class]) {
            // use UIAlertController
            
            UIAlertController *firstnameAlert = [UIAlertController alertControllerWithTitle:nil message:@"Please enter First Name"preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [firstnameAlert dismissViewControllerAnimated:YES completion:nil];
                                                                      
                                                                  }];
            
            
            
            [firstnameAlert addAction:defaultAction];
            [self presentViewController:firstnameAlert animated:YES completion:nil];
        }
        
        return;
    }
    
    if(self.lastNameTextField.text.length == 0)
    {
        if ([UIAlertController class]) {
            // use UIAlertController
            
            UIAlertController *lastnameAlert = [UIAlertController alertControllerWithTitle:nil message:@"Please enter Last Name"preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [lastnameAlert dismissViewControllerAnimated:YES completion:nil];
                                                                      
                                                                  }];
            
            
            
            [lastnameAlert addAction:defaultAction];
            [self presentViewController:lastnameAlert animated:YES completion:nil];
        }
        
        return;
    }
    
   
    if(self.emailTextField.text.length == 0)
    {
        if ([UIAlertController class]) {
            // use UIAlertController
            
            UIAlertController *emailAlert = [UIAlertController alertControllerWithTitle:nil message:@"Please enter Email" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [emailAlert dismissViewControllerAnimated:YES completion:nil];
                                                                      
                                                                  }];
            
            
            
            [emailAlert addAction:defaultAction];
            [self presentViewController:emailAlert animated:YES completion:nil];
        }
        
		return;
    }
    
    if(![AppGlobalData validateEmail:self.emailTextField.text])
    {
        if ([UIAlertController class]) {
            // use UIAlertController
            
            UIAlertController *emailAlert = [UIAlertController alertControllerWithTitle:nil message:@"Invalid Email!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [emailAlert dismissViewControllerAnimated:YES completion:nil];
                                                                      
                                                                  }];
            
            
            
            [emailAlert addAction:defaultAction];
            [self presentViewController:emailAlert animated:YES completion:nil];
        }
        
        return;
        
    }
    
    if(self.passwordTextField.text.length == 0)
    {
        if ([UIAlertController class]) {
            // use UIAlertController
            
            UIAlertController *passwordAlert = [UIAlertController alertControllerWithTitle:nil message:@"Please enter Password" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [passwordAlert dismissViewControllerAnimated:YES completion:nil];
                                                                      
                                                                  }];
            
            
            
            [passwordAlert addAction:defaultAction];
            [self presentViewController:passwordAlert animated:YES completion:nil];
        }
        
        return;
    }
    
//    if (![AppGlobalData validatePassword:self.passwordTextField.text])
//    {
//        if ([UIAlertController class]) {
//            // use UIAlertController
//
//            UIAlertController *passwordAlert = [UIAlertController alertControllerWithTitle:@"Invalid Password" message:@"The password should have at least 8 characters, and the password must include at least 3 out of the 4 categories of characters (upper-case letters, lower-case letters, numbers, and special characters)" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                [passwordAlert dismissViewControllerAnimated:YES completion:nil];
//
//            }];
//
//            [passwordAlert addAction:defaultAction];
//            [self presentViewController:passwordAlert animated:YES completion:nil];
//        }
//        return;
//    }
    
    if(![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text])
    {
        if ([UIAlertController class]) {
            // use UIAlertController
            
            UIAlertController *passwordAlert = [UIAlertController alertControllerWithTitle:nil message:@"Passwords must match" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [passwordAlert dismissViewControllerAnimated:YES completion:nil];
                                                                      
                                                                  }];
            
            
            
            [passwordAlert addAction:defaultAction];
            [self presentViewController:passwordAlert animated:YES completion:nil];
        }
		
		return;
    }
    
    if(self.mobileNumberTextField.text.length == 0)
    {
        if ([UIAlertController class]) {
            // use UIAlertController
            
            UIAlertController *mobileNumberAlert = [UIAlertController alertControllerWithTitle:nil message:@"Please enter Mobile Number"preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [mobileNumberAlert dismissViewControllerAnimated:YES completion:nil];
                                                                      
                                                                  }];
            
            
            
            [mobileNumberAlert addAction:defaultAction];
            [self presentViewController:mobileNumberAlert animated:YES completion:nil];
        }
    
        return;
    }
    
    AppGlobalData *sharedManager = [AppGlobalData sharedManager];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/user", Database_Connector_URL];
    
    int imageDefaultIndex = arc4random_uniform((int)[AppGlobalData DEFAULT_PDF_IMAGES].count);
    
    NSString *signuppostString = [NSString stringWithFormat:@"mobile=%@&password=%@&firstName=%@&lastName=%@&imageDefaultIndex=%d", [sharedManager encodeSpecialCharacters:[self.mobileNumberTextField.text stringByAddingPercentEscapesUsingEncoding:NSWindowsCP1252StringEncoding]], [sharedManager encodeSpecialCharacters:[self.passwordTextField.text stringByAddingPercentEscapesUsingEncoding:NSWindowsCP1252StringEncoding]],
                                  [sharedManager encodeSpecialCharacters:[self.firstNameTextField.text  stringByAddingPercentEscapesUsingEncoding:NSWindowsCP1252StringEncoding]] ,
                                  [sharedManager encodeSpecialCharacters:[self.lastNameTextField.text  stringByAddingPercentEscapesUsingEncoding:NSWindowsCP1252StringEncoding]], imageDefaultIndex];
    
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request setRequestMethod:@"POST"];
    [request setTimeOutSeconds:sharedManager.SETTING_HTTP_REQUEST_TIME_OUT];
    [request setPostBody:[NSMutableData dataWithData:[signuppostString dataUsingEncoding:NSUTF8StringEncoding]]];
    [request setDidFinishSelector:@selector(registerUserFinished:)];
    
    [request setDelegate:self];
    [request startAsynchronous];
    
    [self keyboardControlsDonePressed:self.keyboardControls];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", error);
}

- (void)registerUserFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    NSMutableDictionary *responseJSON = [responseString JSONValue];
    int response_status = [[responseJSON objectForKey:@"status"] intValue];
    
    if (0 == response_status) {
        NSMutableArray *lerrorList = [responseJSON objectForKey:@"errors"];
        
        if(lerrorList != nil && lerrorList.count > 0)
        {
            
            if ([UIAlertController class]) {
                // use UIAlertController
                
                UIAlertController *signupAlert = [UIAlertController alertControllerWithTitle:@"Signup Error" message:[lerrorList objectAtIndex:0]  preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {
                                                                          [signupAlert dismissViewControllerAnimated:YES completion:nil];
                                                                          
                                                                      }];
                
                
                
                [signupAlert addAction:defaultAction];
                [self presentViewController:signupAlert animated:YES completion:nil];
            }
            
            return;
        }
    }
    
    else
    {
        NSMutableDictionary *userINfo = [responseJSON objectForKey:@"response"];

        AppGlobalData *sharedManager = [AppGlobalData sharedManager];
        sharedManager.loginUserID = [userINfo objectForKey:@"id"];
        sharedManager.loginUserName = [userINfo objectForKey:@"username"];
        sharedManager.loginEmail = [userINfo objectForKey:@"email"];
        
        sharedManager.hasUserLoginedVerified = NO;
        
        //need verification
        VerificationController *verifyController = [[VerificationController alloc] initWithNibName:@"VerificationPin" bundle:[NSBundle mainBundle]];
        
        verifyController.mIsParentBottomTabBarHidden = self.tabBarController.tabBar.hidden;
        
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
        [viewControllers removeLastObject];
        [viewControllers addObject:verifyController];
        [[self navigationController] setViewControllers:viewControllers animated:YES];
    }
}

- (void)resetWithOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    
}

- (void)dealloc {
    [goBackButton release];
    
	[signupButton release];
	[signupActivityIndicator release];
    [mobileNumberTextField release];
    [emailTextField release];
    [passwordTextField release];
    [confirmPasswordTextField release];
    
    [firstNameTextField release];
    [lastNameTextField release];
    
    [keyboardControls release];
    
    [signinContainer release];
    [signinTextView release];
   
    [mainHomeView release];
    
    [m_Gradientlayer release];
    [m_GradientColorSet release];
    
    [m_FirstNameBottomlayer release];
    [m_LastNameBottomlayer release];
    [m_EmailBottomlayer release];
    [m_PasswordBottomlayer release];
    [m_RepeatPasswordBottomlayer release];
    [m_MobileNumberBottomlayer release];
    
    [signupTitleLabel release];
    [termPolicyTextView release];
    [super dealloc];
}

- (void)toggleShowTabFooter:(BOOL)show inSeconds: (double)animationDuration
{
    if (show == YES && self.tabBarController.tabBar.hidden == YES) {
        
        CGRect tab_footer_frame = self.tabBarController.tabBar.frame;
        tab_footer_frame.origin.y = self.tabBarController.view.frame.size.height - self.tabBarController.tabBar.frame.size.height;
        
        self.tabBarController.tabBar.hidden = NO;
        
        [UIView animateWithDuration:animationDuration
                         animations:^(void) {
                             
                             self.tabBarController.tabBar.frame = tab_footer_frame;
                         }
                         completion:^(BOOL finished) {
                             [[self.tabBarController.view.subviews objectAtIndex:0]
                              setFrame:CGRectMake(0, 0,
                                                  self.tabBarController.view.frame.size.width,
                                                  self.tabBarController.view.frame.size.height - self.tabBarController.tabBar.frame.size.height)];
                         }
         ];
    }
    else if (show == NO && self.tabBarController.tabBar.hidden == NO) {
        
        CGRect tab_footer_frame = self.tabBarController.tabBar.frame;
        tab_footer_frame.origin.y = self.tabBarController.view.frame.size.height;
        
        [UIView animateWithDuration:animationDuration
                         animations:^(void) {
                             self.tabBarController.tabBar.frame = tab_footer_frame;
                         }
                         completion:^(BOOL finished) {
                             self.tabBarController.tabBar.hidden = YES;
                             [[self.tabBarController.view.subviews objectAtIndex:0]
                              setFrame:CGRectMake(0, 0,
                                                  self.tabBarController.view.frame.size.width,
                                                  self.tabBarController.view.frame.size.height)];
                         }
         ];
    }
}


#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if ([[URL scheme] isEqualToString:@"CustomSignInOpen"]) {
        
        NSLog(@"Host: %@", URL.host);
 
        if([URL.host isEqualToString:@"signin"])
        {
            //        AppGlobalData *sharedManager = [AppGlobalData sharedManager];
            //
            //        NSString *controllerNibName = @"Signin";
            //        if (sharedManager.Include_iPad_Interface && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            //        {
            //            controllerNibName = @"Signin-iPad";
            //        }
            //
            //        SigninController *thisVC = [[SigninController alloc] initWithNibName:controllerNibName bundle:[NSBundle mainBundle]];
            //
            //        thisVC.mIsParentBottomTabBarHidden = self.tabBarController.tabBar.hidden;
            //        [self.navigationController pushViewController:thisVC animated:YES];
            
            [self goBackSearchList:nil];
            return NO;
        }
        else if([URL.host isEqualToString:@"terms"])
        {
            
        }

    }
    return YES; // let the system open this URL
}

- (void)addGradientlayer
{
    self.m_Gradientlayer = [CAGradientLayer layer];
    self.m_GradientColorSet = [NSMutableArray new];
    
    self.m_CurrentGradient = 0;
    id firstColor = (id)[UIColor colorWithHexString:@"#345bdb"].CGColor;
    id secondColor = (id)[UIColor colorWithHexString:@"#34bfdb"].CGColor;
    id thirdColor = (id)[UIColor colorWithHexString:@"#db348d"].CGColor;
    id fourthColor = (id)[UIColor colorWithHexString:@"#34bfdb"].CGColor;
    
    [self.m_GradientColorSet addObject:[NSArray arrayWithObjects:firstColor, secondColor, nil]];
    [self.m_GradientColorSet addObject:[NSArray arrayWithObjects:firstColor, thirdColor, nil]];
    [self.m_GradientColorSet addObject:[NSArray arrayWithObjects:firstColor, fourthColor, nil]];
    
    float x = 0.0/360.0;
    
    //Set up layer and add it to view
    self.m_Gradientlayer.frame = (CGRect){{0,0}, {MAIN_WIDTH, MAIN_HEIGHT}};
    [self.view.layer insertSublayer:self.m_Gradientlayer atIndex:0];
    
    self.m_Gradientlayer.colors = [self.m_GradientColorSet objectAtIndex:self.m_CurrentGradient];
    
    //create coordinates
    float a = pow(sinf((2*M_PI*((x+0.75)/2))),2);
    float b = pow(sinf((2*M_PI*((x+0.0)/2))),2);
    float c = pow(sinf((2*M_PI*((x+0.25)/2))),2);
    float d = pow(sinf((2*M_PI*((x+0.5)/2))),2);
    
    //set the gradient direction
    [self.m_Gradientlayer setStartPoint:CGPointMake(a, b)];
    [self.m_Gradientlayer setEndPoint:CGPointMake(c, d)];
    self.m_Gradientlayer.drawsAsynchronously = YES;
    
    [self continueGradientlayerAnimation];
}

#pragma CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim
                finished:(BOOL)flag
{
    if(flag) {
        self.m_Gradientlayer.colors = [self.m_GradientColorSet objectAtIndex:self.m_CurrentGradient];
        [self continueGradientlayerAnimation];
    }
}

- (void)continueGradientlayerAnimation
{
    if(self.m_CurrentGradient < self.m_GradientColorSet.count - 1)
        self.m_CurrentGradient++;
    else
        self.m_CurrentGradient = 0;
    
    CABasicAnimation *gradientChangeAnimation = [CABasicAnimation animationWithKeyPath:@"colors"];
    
    gradientChangeAnimation.duration = 4.5;
    gradientChangeAnimation.toValue = [self.m_GradientColorSet objectAtIndex:self.m_CurrentGradient];
    gradientChangeAnimation.fillMode = kCAFillModeForwards;
    gradientChangeAnimation.removedOnCompletion = NO;
    
    gradientChangeAnimation.delegate = self;
    
    [self.m_Gradientlayer addAnimation:gradientChangeAnimation forKey:@"colorChange"];
}


- (void)addTextFieldGradientlayer
{
    self.m_FirstNameBottomlayer = [CAGradientLayer layer];
    self.m_LastNameBottomlayer = [CAGradientLayer layer];
    self.m_EmailBottomlayer = [CAGradientLayer layer];
    self.m_PasswordBottomlayer = [CAGradientLayer layer];
    self.m_RepeatPasswordBottomlayer = [CAGradientLayer layer];
    self.m_MobileNumberBottomlayer = [CAGradientLayer layer];
    
    CGFloat borderWidth = 2;
    float x = 90.0/360.0;
    //create coordinates
    float a = pow(sinf((2*M_PI*((x+0.75)/2))),2);
    float b = pow(sinf((2*M_PI*((x+0.0)/2))),2);
    float c = pow(sinf((2*M_PI*((x+0.25)/2))),2);
    float d = pow(sinf((2*M_PI*((x+0.5)/2))),2);
    
    self.m_EmailBottomlayer.frame = CGRectMake(0, self.emailTextField.frame.size.height - borderWidth, self.emailTextField.frame.size.width, self.emailTextField.frame.size.height);
    self.m_EmailBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#8199BE"].CGColor, (id)[UIColor colorWithHexString:@"#8199BE"].CGColor, nil];
    
    //set the gradient direction
    [self.m_EmailBottomlayer setStartPoint:CGPointMake(a, b)];
    [self.m_EmailBottomlayer setEndPoint:CGPointMake(c, d)];
    self.m_EmailBottomlayer.drawsAsynchronously = YES;
    
    [self.emailTextField.layer addSublayer:self.m_EmailBottomlayer];
    self.emailTextField.layer.masksToBounds = YES;
    
    self.m_PasswordBottomlayer.frame = CGRectMake(0, self.passwordTextField.frame.size.height - borderWidth, self.passwordTextField.frame.size.width, self.passwordTextField.frame.size.height);
    self.m_PasswordBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#8199BE"].CGColor, (id)[UIColor colorWithHexString:@"#8199BE"].CGColor, nil];
    
    //set the gradient direction
    [self.m_PasswordBottomlayer setStartPoint:CGPointMake(a, b)];
    [self.m_PasswordBottomlayer setEndPoint:CGPointMake(c, d)];
    self.m_PasswordBottomlayer.drawsAsynchronously = YES;
    
    [self.passwordTextField.layer addSublayer:self.m_PasswordBottomlayer];
    self.passwordTextField.layer.masksToBounds = YES;
    
    self.m_FirstNameBottomlayer.frame = CGRectMake(0, self.firstNameTextField.frame.size.height - borderWidth, self.firstNameTextField.frame.size.width, self.firstNameTextField.frame.size.height);
    self.m_FirstNameBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#8199BE"].CGColor, (id)[UIColor colorWithHexString:@"#8199BE"].CGColor, nil];
    
    //set the gradient direction
    [self.m_FirstNameBottomlayer setStartPoint:CGPointMake(a, b)];
    [self.m_FirstNameBottomlayer setEndPoint:CGPointMake(c, d)];
    self.m_FirstNameBottomlayer.drawsAsynchronously = YES;
    
    [self.firstNameTextField.layer addSublayer:self.m_FirstNameBottomlayer];
    self.firstNameTextField.layer.masksToBounds = YES;
    
    self.m_LastNameBottomlayer.frame = CGRectMake(0, self.lastNameTextField.frame.size.height - borderWidth, self.lastNameTextField.frame.size.width, self.lastNameTextField.frame.size.height);
    self.m_LastNameBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#8199BE"].CGColor, (id)[UIColor colorWithHexString:@"#8199BE"].CGColor, nil];
    
    //set the gradient direction
    [self.m_LastNameBottomlayer setStartPoint:CGPointMake(a, b)];
    [self.m_LastNameBottomlayer setEndPoint:CGPointMake(c, d)];
    self.m_LastNameBottomlayer.drawsAsynchronously = YES;
    
    [self.lastNameTextField.layer addSublayer:self.m_LastNameBottomlayer];
    self.lastNameTextField.layer.masksToBounds = YES;
    
    self.m_RepeatPasswordBottomlayer.frame = CGRectMake(0, self.confirmPasswordTextField.frame.size.height - borderWidth, self.confirmPasswordTextField.frame.size.width, self.confirmPasswordTextField.frame.size.height);
    self.m_RepeatPasswordBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#8199BE"].CGColor, (id)[UIColor colorWithHexString:@"#8199BE"].CGColor, nil];
    
    //set the gradient direction
    [self.m_RepeatPasswordBottomlayer setStartPoint:CGPointMake(a, b)];
    [self.m_RepeatPasswordBottomlayer setEndPoint:CGPointMake(c, d)];
    self.m_RepeatPasswordBottomlayer.drawsAsynchronously = YES;
    
    [self.confirmPasswordTextField.layer addSublayer:self.m_RepeatPasswordBottomlayer];
    self.confirmPasswordTextField.layer.masksToBounds = YES;
    
    self.m_MobileNumberBottomlayer.frame = CGRectMake(0, self.mobileNumberTextField.frame.size.height - borderWidth, self.mobileNumberTextField.frame.size.width, self.mobileNumberTextField.frame.size.height);
    self.m_MobileNumberBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#8199BE"].CGColor, (id)[UIColor colorWithHexString:@"#8199BE"].CGColor, nil];
    
    //set the gradient direction
    [self.m_MobileNumberBottomlayer setStartPoint:CGPointMake(a, b)];
    [self.m_MobileNumberBottomlayer setEndPoint:CGPointMake(c, d)];
    self.m_MobileNumberBottomlayer.drawsAsynchronously = YES;
    
    [self.mobileNumberTextField.layer addSublayer:self.m_MobileNumberBottomlayer];
    self.mobileNumberTextField.layer.masksToBounds = YES;

}
@end
