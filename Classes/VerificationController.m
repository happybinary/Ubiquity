//
//  VerificationController.m
//  Global Directories
//
//  Created by Steve Ma on 12/17/13.
//  Copyright 2009 InformationPages.com, Inc.. All rights reserved.
//

#import "VerificationController.h"
#import "AppGlobalData.h"
#import <QuartzCore/QuartzCore.h>
#import "ASIHTTPRequest.h"
#import "JSON/JSON.h"

#import "MFSideMenu.h"
#import "UIImageView+AFNetworking.h"
#import "UIColor+Hex.h"
#import "SideMenuViewController.h"
#import "appDataDelegate.h"

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

@interface VerificationController(mymethods)
// these are private methods that outside classes need not use
- (void)resetWithOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)toggleShowTabFooter:(BOOL)show inSeconds: (double)animationDuration;
@end

@implementation VerificationController
@synthesize goBackButton, verifyButton;
@synthesize verifyActivityIndicator;
@synthesize firstTextField, secondTextField;
@synthesize thirdTextField, fourthTextField;
@synthesize mIsParentBottomTabBarHidden;

@synthesize resendContainer, resendTextView;

@synthesize mainHomeView;
@synthesize m_Gradientlayer, m_GradientColorSet, m_CurrentGradient;

@synthesize verificationTitleLabel;

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
    [self.verifyActivityIndicator setColor:[UIColor grayColor]];
    
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
    
    [self.firstTextField setValue:[UIColor colorWithHexString:@"#839abd"] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.secondTextField setValue:[UIColor colorWithHexString:@"#839abd"] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.thirdTextField setValue:[UIColor colorWithHexString:@"#839abd"] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.fourthTextField setValue:[UIColor colorWithHexString:@"#839abd"] forKeyPath:@"_placeholderLabel.textColor"];
    
    if([self.verifyActivityIndicator isAnimating])
    {
        [self.verifyActivityIndicator stopAnimating];
    }
    
    self.firstTextField.layer.borderWidth = 1;
    self.firstTextField.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.secondTextField.layer.borderWidth = 1;
    self.secondTextField.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.thirdTextField.layer.borderWidth = 1;
    self.thirdTextField.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.fourthTextField.layer.borderWidth = 1;
    self.fourthTextField.layer.borderColor = [UIColor whiteColor].CGColor;

    [self.firstTextField setFont:[UIFont fontWithName:THE_APP_BoldFontName size:self.firstTextField.font.pointSize]];
    [self.secondTextField setFont:[UIFont fontWithName:THE_APP_BoldFontName size:self.secondTextField.font.pointSize]];
    [self.thirdTextField setFont:[UIFont fontWithName:THE_APP_BoldFontName size:self.thirdTextField.font.pointSize]];
    [self.fourthTextField setFont:[UIFont fontWithName:THE_APP_BoldFontName size:self.fourthTextField.font.pointSize]];
   
    [self.verificationTitleLabel setFont:[UIFont fontWithName:THE_APP_BoldFontName size:self.verificationTitleLabel.font.pointSize]];
    
    [self.verifyButton.titleLabel setFont:[UIFont fontWithName:THE_APP_BoldFontName size:self.verifyButton.titleLabel.font.pointSize]];
    
    self.verifyButton.layer.cornerRadius = 24.0;
    
    NSString *resendCodeText = @"Didn't get code? Resent";
    UIColor *blueTextColor = [UIColor colorWithHexString:@"#7fbaff"];

    UIFont *resendTextNormal = [UIFont fontWithName:THE_APP_FontName size:self.resendTextView.font.pointSize];
    
    NSDictionary *resend_attribs = @{NSForegroundColorAttributeName: blueTextColor, NSFontAttributeName: resendTextNormal
                                     };
    NSMutableAttributedString *attributedResendString = [[NSMutableAttributedString alloc] initWithString:resendCodeText attributes:resend_attribs];
    
    [attributedResendString addAttribute:NSLinkAttributeName
                                   value:@"CustomResendOpen://resend"
                                   range:[[attributedResendString string] rangeOfString:@"Resent"]];
    
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                     NSUnderlineColorAttributeName: [UIColor lightGrayColor],
                                     NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    
    self.resendTextView.linkTextAttributes = linkAttributes; // customizes the appearance of links
    self.resendTextView.attributedText = attributedResendString;
    
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
   
    self.resendTextView.editable = YES;
    self.resendTextView.scrollEnabled = YES;
    [self.resendTextView setFont:[UIFont fontWithName:THE_APP_BoldFontName size:self.resendTextView.font.pointSize]];
    self.resendTextView.textAlignment = NSTextAlignmentCenter;
    self.resendTextView.editable = NO;
    self.resendTextView.scrollEnabled = NO;
    
    [super viewWillAppear:animated];
    
    //[self addGradientlayer];
    [self.firstTextField becomeFirstResponder];
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
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *oneDigitString = string;
    if ([string length] > 1)
    {
        oneDigitString  =  [string substringToIndex:1];
    }
    
    textField.text  =  oneDigitString;

    if ([oneDigitString length] > 0) {
        NSCharacterSet *nonNumberSet = NSCharacterSet.decimalDigitCharacterSet.invertedSet;
        
        NSArray *compSepByCharInSet = [oneDigitString componentsSeparatedByCharactersInSet:nonNumberSet];
        
        NSString * numberFiltered = [compSepByCharInSet componentsJoinedByString:@""];
        
        if([oneDigitString isEqualToString:numberFiltered])
        {
            if ([textField isEqual:self.firstTextField]) {
                [self.secondTextField becomeFirstResponder];
                
            }else if([textField isEqual:self.secondTextField]) {
                
                [self.thirdTextField becomeFirstResponder];
                
            }else if([textField isEqual:self.thirdTextField]) {
                
                [self.fourthTextField becomeFirstResponder];
                
            }else if([textField isEqual:self.fourthTextField]) {
                
                [textField resignFirstResponder];
            }
        }
        else
        {
            textField.text  =  @"";
        }
  }
    return FALSE;
}

- (IBAction)textFieldDidChange: (id)sender
{

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

-(IBAction)verifyButtonClicked:(id)sender
{
    if(self.firstTextField.text.length == 0 || self.secondTextField.text.length == 0 || self.thirdTextField.text.length == 0 || self.fourthTextField.text.length == 0)
    {
        if ([UIAlertController class]) {
            // use UIAlertController
            
            UIAlertController *pinAlert = [UIAlertController alertControllerWithTitle:nil message:@"Please enter Verification PIN" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [pinAlert dismissViewControllerAnimated:YES completion:nil];
                                                                      
                                                                  }];
            
            
            
            [pinAlert addAction:defaultAction];
            [self presentViewController:pinAlert animated:YES completion:nil];
        }
        
        return;
    }
    
    AppGlobalData *sharedManager = [AppGlobalData sharedManager];

    NSString *verifyPin = [NSString stringWithFormat:@"%@%@%@%@",  self.firstTextField.text,self.secondTextField.text, self.thirdTextField.text, self.fourthTextField.text];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/user?id=%@&pin=%@", Database_Connector_URL, sharedManager.loginUserID, verifyPin];
    
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];

    [request setTimeOutSeconds:sharedManager.SETTING_HTTP_REQUEST_TIME_OUT];
    [request setDidFinishSelector:@selector(verifyPinFinished:)];
    
    [request setDelegate:self];
    [request startAsynchronous];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", error);
}

- (void)verifyPinFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    NSMutableDictionary *responseJSON = [responseString JSONValue];
    if(nil == responseJSON)
    {
        if ([UIAlertController class]) {
            // use UIAlertController
            UIAlertController *verificationAlert = [UIAlertController alertControllerWithTitle:@"Verify Error" message:responseString preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [verificationAlert dismissViewControllerAnimated:YES completion:nil];
                                                                      
                                                                  }];
            [verificationAlert addAction:defaultAction];
            [self presentViewController:verificationAlert animated:YES completion:nil];
        }
        
        return;
    }

    int response_status = [[responseJSON objectForKey:@"status"] intValue];
    
    if (0 == response_status) {
        NSMutableArray *lerrorList = [responseJSON objectForKey:@"errors"];
        
        if(lerrorList != nil && lerrorList.count > 0)
        {
            if ([UIAlertController class]) {
                // use UIAlertController
                
                UIAlertController *verificationAlert = [UIAlertController alertControllerWithTitle:@"Verify Error" message:[lerrorList objectAtIndex:0]  preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {
                                                                          [verificationAlert dismissViewControllerAnimated:YES completion:nil];
                                                                          
                                                                      }];
                
                
                
                [verificationAlert addAction:defaultAction];
                [self presentViewController:verificationAlert animated:YES completion:nil];
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
        
        int requireVerification = [[userINfo objectForKey:@"requiresverification"] intValue];
        
        if(0 == requireVerification)
        {
            sharedManager.hasUserLoginedVerified = YES;

            if (self.presentingViewController != nil)
            {
                CATransition *transition = [CATransition animation];
                transition.duration = 0.5;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromLeft;
                [self.view.window.layer addAnimation:transition forKey:kCATransition];
                
                [self dismissViewControllerAnimated:NO completion:^(void){
                }];
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
        else
        {
            if ([UIAlertController class]) {
                // use UIAlertController
                
                UIAlertController *signupAlert = [UIAlertController alertControllerWithTitle:@"Need Verification" message:nil  preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {
                                                                          [signupAlert dismissViewControllerAnimated:YES completion:nil];
                                                                          
                                                                      }];
                
                
                
                [signupAlert addAction:defaultAction];
                [self presentViewController:signupAlert animated:YES completion:nil];
            }
           
        }
    }
}

- (void)resetWithOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    
}

- (void)dealloc {
    [goBackButton release];
    
	[verifyButton release];
	[verifyActivityIndicator release];
    [firstTextField release];
    [secondTextField release];
    [thirdTextField release];
    [fourthTextField release];
        
    [resendContainer release];
    [resendTextView release];
   
    [mainHomeView release];
    
    [m_Gradientlayer release];
    [m_GradientColorSet release];
    
    [verificationTitleLabel release];
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
    if ([[URL scheme] isEqualToString:@"CustomResendOpen"]) {
        
        NSLog(@"Host: %@", URL.host);
 
        if([URL.host isEqualToString:@"resend"])
        {

         
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

@end
