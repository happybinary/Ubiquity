//
//  SigninController.m
//  Global Directories
//
//  Created by Steve Ma on 12/17/13.
//  Copyright 2009 InformationPages.com, Inc.. All rights reserved.
//

#import "SigninController.h"
#import "AppGlobalData.h"
#import <QuartzCore/QuartzCore.h>
#import "ASIHTTPRequest.h"
#import "JSON/JSON.h"

#import "MFSideMenu.h"
#import "UIImageView+AFNetworking.h"
#import "UIColor+Hex.h"
#import "SignupController.h"
#import "SideMenuViewController.h"
#import "appDataDelegate.h"
#import "ForgotPasswordViewController.h"

#import "User.h"

#import "NSObject+DCKeyValueObjectMapping.h"
#import "DCKeyValueObjectMapping.h"
#import "DCObjectMapping.h"

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

@interface SigninController(mymethods)
// these are private methods that outside classes need not use
- (void)resetWithOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)toggleShowTabFooter:(BOOL)show inSeconds: (double)animationDuration;
@end

@implementation SigninController
@synthesize loginSigninButton;
@synthesize signinActivityIndicator;
@synthesize mobileNumberTextField, passwordTextField;
@synthesize m_EmailBottomlayer, m_PasswordBottomlayer;

@synthesize emailInfoLabel, passwordInfoLabel;
@synthesize keyboardControls;
@synthesize delegate;
@synthesize mIsParentBottomTabBarHidden;

@synthesize keepmeLoggedButton1, keepmeLoggedButton2;
@synthesize forgotPasswordButton;

@synthesize signupContainer;
@synthesize signupTextView;

@synthesize mainHomeView;

@synthesize m_Gradientlayer, m_GradientColorSet, m_CurrentGradient;

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
    self.screenName = @"Signin View Controller";
#endif
	[super viewDidLoad];
    
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
    [self.signinActivityIndicator setColor:[UIColor grayColor]];
    
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
    
    [self.mobileNumberTextField setValue:[UIColor colorWithHexString:@"#B370bfd1"] forKeyPath:@"_placeholderLabel.textColor"];

    [self.passwordTextField setValue:[UIColor colorWithHexString:@"#B370bfd1"] forKeyPath:@"_placeholderLabel.textColor"];
    self.passwordTextField.secureTextEntry = YES;
    
    [self.mobileNumberTextField setFont:[UIFont fontWithName:THE_APP_BoldFontName size:self.mobileNumberTextField.font.pointSize]];
    [self.passwordTextField setFont:[UIFont fontWithName:THE_APP_BoldFontName size:self.passwordTextField.font.pointSize]];
    
    self.loginSigninButton.layer.cornerRadius = 24.0;
    
    [self.keepmeLoggedButton2.titleLabel setFont:[UIFont fontWithName:THE_APP_BoldFontName size:self.keepmeLoggedButton2.titleLabel.font.pointSize]];
    [self.forgotPasswordButton.titleLabel setFont:[UIFont fontWithName:THE_APP_BoldFontName size:self.forgotPasswordButton.titleLabel.font.pointSize]];
    
     [self.emailInfoLabel setFont:[UIFont fontWithName:THE_APP_BoldFontName size:self.emailInfoLabel.font.pointSize]];
     [self.passwordInfoLabel setFont:[UIFont fontWithName:THE_APP_BoldFontName size:self.passwordInfoLabel.font.pointSize]];
    
    [self.loginSigninButton.titleLabel setFont:[UIFont fontWithName:THE_APP_BoldFontName size:self.loginSigninButton.titleLabel.font.pointSize]];
    
    NSArray *fields = [[NSArray alloc] initWithObjects:
                       self.mobileNumberTextField,
                       self.passwordTextField,
                       nil];
    [self setKeyboardControls:[[IPKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
    
    if([self.signinActivityIndicator isAnimating])
    {
        [self.signinActivityIndicator stopAnimating];
    }

    NSString *signupText = @"New to bolt? Sign up here";
    UIColor *blueTextColor = [UIColor colorWithHexString:@"#7fbaff"];
    UIFont *signupTextNormal = [UIFont fontWithName:THE_APP_FontName size:self.signupTextView.font.pointSize];
    NSDictionary *signup_attribs = @{NSForegroundColorAttributeName: blueTextColor, NSFontAttributeName: signupTextNormal
                                     };
    NSMutableAttributedString *attributedSignupString = [[NSMutableAttributedString alloc] initWithString:signupText attributes:signup_attribs];
    
    [attributedSignupString addAttribute:NSLinkAttributeName
                             value:@"CustomSignUpOpen://signup"
                             range:[[attributedSignupString string] rangeOfString:@"Sign up here"]];
    
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                     NSUnderlineColorAttributeName: [UIColor lightGrayColor],
                                     NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    
    self.signupTextView.linkTextAttributes = linkAttributes; // customizes the appearance of links
    self.signupTextView.attributedText = attributedSignupString;
    
    [self.keepmeLoggedButton1.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
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
    
    if(sharedManager.hasRemebermeLoginOption)
        [self.keepmeLoggedButton1 setImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateNormal];
    else
        [self.keepmeLoggedButton1 setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    
    self.signupTextView.editable = YES;
    self.signupTextView.scrollEnabled = YES;
    [self.signupTextView setFont:[UIFont fontWithName:THE_APP_BoldFontName size:self.signupTextView.font.pointSize]];
    self.signupTextView.textAlignment = NSTextAlignmentCenter;
    
    self.signupTextView.editable = NO;
    self.signupTextView.scrollEnabled = NO;
    
    [super viewWillAppear:animated];

    [self addEmailAndPasswordGradientlayer];
    //[self addGradientlayer];
    [self.mobileNumberTextField becomeFirstResponder];
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
    
    if(textField == self.mobileNumberTextField)
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
        if(textField == self.mobileNumberTextField)
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
        if(textField == self.mobileNumberTextField)
        {
            self.m_EmailBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#B370bfd1"].CGColor, (id)[UIColor colorWithHexString:@"#B370bfd1"].CGColor, nil];
            self.emailInfoLabel.hidden = NO;
        }
        else
        {
            self.m_PasswordBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#B370bfd1"].CGColor, (id)[UIColor colorWithHexString:@"#B370bfd1"].CGColor, nil];
            self.passwordInfoLabel.hidden = NO;
        }
    }
    else
    {
        if(textField == self.mobileNumberTextField)
        {
            self.emailInfoLabel.hidden = YES;
        }
        else
        {
            self.passwordInfoLabel.hidden = YES;
        }
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

-(IBAction)keepMeLogginedInClicked:(id)sender
{
    AppGlobalData *sharedManager = [AppGlobalData sharedManager];
    
    sharedManager.hasRemebermeLoginOption = !sharedManager.hasRemebermeLoginOption;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:sharedManager.hasRemebermeLoginOption] forKey:kHasUserSkippedLoginBefore];
    
    if(sharedManager.hasRemebermeLoginOption)
        [self.keepmeLoggedButton1 setImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateNormal];
    else
        [self.keepmeLoggedButton1 setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
}
-(IBAction)forgotPasswordClicked:(id)sender
{
    AppGlobalData *sharedManager = [AppGlobalData sharedManager];
    
    NSString *controllerNibName = @"ForgotPassword";
    if (sharedManager.Include_iPad_Interface && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        controllerNibName = @"ForgotPassword-iPad";
    }
    
     UIViewController* mainViewController = (UIViewController*)[self getMainViewController];
    
    if(nil == mainViewController)
        return;
    
    ForgotPasswordViewController *thisVC = [[ForgotPasswordViewController alloc] initWithNibName:controllerNibName bundle:[NSBundle mainBundle]];
    
    [mainViewController.navigationController pushViewController:thisVC animated:YES];
}

-(IBAction)loginSigninClicked:(id)sender
{
    if(self.mobileNumberTextField.text.length == 0)
    {
        if ([UIAlertController class]) {
            // use UIAlertController
            
            UIAlertController *mobilrNumberAlert = [UIAlertController alertControllerWithTitle:nil message:@"Please enter Mobile Number" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [mobilrNumberAlert dismissViewControllerAnimated:YES completion:nil];
                                                                      
                                                                  }];
            
            
            
            [mobilrNumberAlert addAction:defaultAction];
            [self presentViewController:mobilrNumberAlert animated:YES completion:nil];
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
    
     if (!self.signinActivityIndicator.isAnimating) [self.signinActivityIndicator startAnimating];
    
    AppGlobalData *sharedManager = [AppGlobalData sharedManager];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/user?mobileNum=%@&password=%@", Database_Connector_URL, [sharedManager encodeSpecialCharacters:[self.mobileNumberTextField.text stringByAddingPercentEscapesUsingEncoding:NSWindowsCP1252StringEncoding]], [sharedManager encodeSpecialCharacters:[self.passwordTextField.text stringByAddingPercentEscapesUsingEncoding:NSWindowsCP1252StringEncoding]]];
    
    NSLog(@"%@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:sharedManager.SETTING_HTTP_REQUEST_TIME_OUT];
    [request setDidFinishSelector:@selector(loginUserFinished:)];
    [request setDelegate:self];
    [request startAsynchronous];
    
    [self keyboardControlsDonePressed:self.keyboardControls];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", error);
     if (self.signinActivityIndicator.isAnimating) [self.signinActivityIndicator stopAnimating];
}

-(void)loginVerified
{
    [(SideMenuViewController *)(self.menuContainerViewController.leftMenuViewController) updateSlideMenu];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    
    [self closeButtonClick:nil];
    
    if (self.signinActivityIndicator.isAnimating) [self.signinActivityIndicator stopAnimating];
}

- (void)resetWithOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    
}

- (void)dealloc {

	[loginSigninButton release];
	[signinActivityIndicator release];
    [mobileNumberTextField release];
    [passwordTextField release];

    [keyboardControls release];
    [delegate release];
    
    [keepmeLoggedButton1 release];
    [keepmeLoggedButton2 release];
    [forgotPasswordButton release];
    
    [signupContainer release];
    [signupTextView release];

    [mainHomeView release];
    [m_Gradientlayer release];
    [m_GradientColorSet release];
    
    [emailInfoLabel release];
    [passwordInfoLabel release];
    [m_EmailBottomlayer release];
    [m_PasswordBottomlayer release];
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
    if ([[URL scheme] isEqualToString:@"CustomSignUpOpen"]) {
   
        AppGlobalData *sharedManager = [AppGlobalData sharedManager];
        
        UIViewController* mainViewController = (UIViewController*)[self getMainViewController];
        
        if(nil == mainViewController)
            return YES;
        
        NSString *controllerNibName = @"SignupWithEmail";
        if (sharedManager.Include_iPad_Interface && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            controllerNibName = @"SignupWithEmail-iPad";
        }
        
        SignupController *thisVC = [[SignupController alloc] initWithNibName:controllerNibName bundle:[NSBundle mainBundle]];
        
        thisVC.mIsParentBottomTabBarHidden = self.tabBarController.tabBar.hidden;
        [mainViewController.navigationController pushViewController:thisVC animated:YES];
        return NO;
    }
    return YES; // let the system open this URL
}

- (void)loginUserFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    
    NSMutableDictionary *responseJSON = [responseString JSONValue];
    
    if(nil == responseJSON)
    {
        if ([UIAlertController class]) {
            // use UIAlertController
            
            UIAlertController *signupAlert = [UIAlertController alertControllerWithTitle:@"Login Error" message:responseString preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [signupAlert dismissViewControllerAnimated:YES completion:nil];
                                                                      
                                                                  }];
            
            [signupAlert addAction:defaultAction];
            [self presentViewController:signupAlert animated:YES completion:nil];
        }
        if (self.signinActivityIndicator.isAnimating) [self.signinActivityIndicator stopAnimating];

        return;
    }
    
    @try {
        
        DCParserConfiguration *config = [DCParserConfiguration configuration];
        
        DCObjectMapping *idTo_id = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"_id" onClass:[User class]];
        
        [config addObjectMapping:idTo_id];
        
        DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass: [User class]  andConfiguration:config];
        
        User *user = [parser parseDictionary:responseJSON];
        
        [User loadUser:user];
        
        AppGlobalData *sharedManager = [AppGlobalData sharedManager];
        sharedManager.loginUserID = user._id;
        sharedManager.loginUserName = user.username;
        sharedManager.loginEmail = user.email;

        sharedManager.hasUserLoginedVerified = YES;

    } @catch (NSException *exc) {
    }
    
    [self loginVerified];
        
}

- (void)addEmailAndPasswordGradientlayer
{
    self.m_EmailBottomlayer = [CAGradientLayer layer];
    self.m_PasswordBottomlayer = [CAGradientLayer layer];
    
    CGFloat borderWidth = 2;
    float x = 90.0/360.0;
    //create coordinates
    float a = pow(sinf((2*M_PI*((x+0.75)/2))),2);
    float b = pow(sinf((2*M_PI*((x+0.0)/2))),2);
    float c = pow(sinf((2*M_PI*((x+0.25)/2))),2);
    float d = pow(sinf((2*M_PI*((x+0.5)/2))),2);
    
    self.m_EmailBottomlayer.frame = CGRectMake(0, self.mobileNumberTextField.frame.size.height - borderWidth, self.mobileNumberTextField.frame.size.width, self.mobileNumberTextField.frame.size.height);
    self.m_EmailBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#8199BE"].CGColor, (id)[UIColor colorWithHexString:@"#8199BE"].CGColor, nil];
    
    //set the gradient direction
    [self.m_EmailBottomlayer setStartPoint:CGPointMake(a, b)];
    [self.m_EmailBottomlayer setEndPoint:CGPointMake(c, d)];
    self.m_EmailBottomlayer.drawsAsynchronously = YES;
    
    [self.mobileNumberTextField.layer addSublayer:self.m_EmailBottomlayer];
    self.mobileNumberTextField.layer.masksToBounds = YES;
    
    self.m_PasswordBottomlayer.frame = CGRectMake(0, self.passwordTextField.frame.size.height - borderWidth, self.passwordTextField.frame.size.width, self.passwordTextField.frame.size.height);
    self.m_PasswordBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#8199BE"].CGColor, (id)[UIColor colorWithHexString:@"#8199BE"].CGColor, nil];
    
    //set the gradient direction
    [self.m_PasswordBottomlayer setStartPoint:CGPointMake(a, b)];
    [self.m_PasswordBottomlayer setEndPoint:CGPointMake(c, d)];
    self.m_PasswordBottomlayer.drawsAsynchronously = YES;
    
    [self.passwordTextField.layer addSublayer:self.m_PasswordBottomlayer];
    self.passwordTextField.layer.masksToBounds = YES;
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

-(IBAction)closeButtonClick:(id)sender
{
    //restore: call main container controller back
    id<InfoPagesControllerDelegate> mainViewController = (id<InfoPagesControllerDelegate>)[self getMainViewController];
    
    [mainViewController goBackToMainController];
}

- (id)getMainViewController
{
    UIView *startView = self.view.superview;
    
    //chained to get
    while(startView != nil)
    {
        id vc = [startView nextResponder];
        if([vc isKindOfClass:[UIViewController class]])
            return vc;
        startView = startView.superview;
    }
    
    return self;
}

@end
