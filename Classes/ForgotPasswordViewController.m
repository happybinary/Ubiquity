//
//  ForgotPasswordViewController.mm
//  Global Directories
//
//  Created by Carey Bernier on 8/13/13.
//
//

#import "ForgotPasswordViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppGlobalData.h"
#import "MFSideMenu.h"
#import "appDataDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+HTML.h"
#import "SideMenuViewController.h"
#import "JSON/JSON.h"

#import "ASIHTTPRequest.h"
#import "UIColor+Hex.h"

extern const NSString *Database_Connector_URL;

extern NSString *THE_APP_FontName;
extern NSString *THE_APP_BoldFontName;
extern NSString *THE_APP_Header_BoldFontName;
extern NSString *THE_APP_Header_DemiFontName;
extern NSString *THE_APP_Header_BookFontName;

extern const CGFloat Header_Text_Height_iPhone;
extern const CGFloat Header_Text_Height_iPad;

#define MAIN_HEIGHT [AppGlobalData screenSize].height
#define MAIN_WIDTH [AppGlobalData screenSize].width

extern const CGFloat X_Status_Bar_Height;
extern const CGFloat X_Bottom_Bar_Safe_Height;

extern const double TAB_BAR_HEIGHT;
extern const double TAB_BAR_X_HEIGHT;

@implementation ForgotPasswordViewController

@synthesize goBackButton;
@synthesize emailGuideLable;
@synthesize mobileNumberField, newpasswordTextField;
@synthesize infoTextLable;
@synthesize sendEmailButton;
@synthesize signinActivityIndicator;
@synthesize mainHomeView;
@synthesize forgotTitleLabel;
@synthesize m_Gradientlayer, m_GradientColorSet, m_CurrentGradient;
@synthesize m_EmailBottomlayer, m_PasswordBottomlayer;

- (id)init {
    
    NSString *controllerNibName = @"ForgotPassword";
    self = [self initWithNibName:controllerNibName bundle:[NSBundle mainBundle]];
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
#if GoogleAnalyticsTracker
    self.screenName = @"Forgot Password View Controller";
#endif
    [super viewDidLoad];

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeAll];
    }
    
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        [self setExtendedLayoutIncludesOpaqueBars:YES];
    }
    
#endif
    [self.signinActivityIndicator setColor:[UIColor grayColor]];
    
    [self.forgotTitleLabel setFont:[UIFont fontWithName:THE_APP_Header_DemiFontName size:self.forgotTitleLabel.font.pointSize]];
    
    [self.sendEmailButton.titleLabel setFont:[UIFont fontWithName:THE_APP_BoldFontName size:self.sendEmailButton.titleLabel.font.pointSize]];

    self.sendEmailButton.layer.cornerRadius = 24;

    [self.emailGuideLable setFont:[UIFont fontWithName:THE_APP_FontName size:self.emailGuideLable.font.pointSize]];
    [self.infoTextLable setFont:[UIFont fontWithName:THE_APP_FontName size:self.infoTextLable.font.pointSize]];

    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    
    [self.mobileNumberField setFont:[UIFont fontWithName:THE_APP_FontName size:self.mobileNumberField.font.pointSize]];
    
    [self.newpasswordTextField setFont:[UIFont fontWithName:THE_APP_BoldFontName size:self.newpasswordTextField.font.pointSize]];
    
    [self.mobileNumberField setValue:[UIColor colorWithHexString:@"#839abd"] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.newpasswordTextField setValue:[UIColor colorWithHexString:@"#839abd"] forKeyPath:@"_placeholderLabel.textColor"];
    self.newpasswordTextField.secureTextEntry = YES;

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
    
   
 }

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    [self toggleShowTabFooter:NO inSeconds:0];
    
    AppGlobalData *sharedManager = [AppGlobalData sharedManager];
    
    
#if GoogleAnalyticsTracker
    [sharedManager.tracker set:kGAIScreenName value:self.screenName];
    [sharedManager.tracker send:[[GAIDictionaryBuilder createScreenView] build]];
#endif
    
    [self addTextFieldGradientlayer];
    //[self addGradientlayer];
    [self.mobileNumberField becomeFirstResponder];
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

//for ios 6.0
- (BOOL)shouldAutorotate
{
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

#pragma mark -
#pragma mark Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.mobileNumberField)
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
        if(textField == self.mobileNumberField)
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
    if(textField == self.mobileNumberField)
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
       if(textField == self.mobileNumberField)
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
       if(textField == self.mobileNumberField)
        {
            self.m_EmailBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#8199BE"].CGColor, (id)[UIColor colorWithHexString:@"#8199BE"].CGColor, nil];
        }
        else
        {
            self.m_PasswordBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#8199BE"].CGColor, (id)[UIColor colorWithHexString:@"#8199BE"].CGColor, nil];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    [goBackButton release];
    [forgotTitleLabel release];
    [emailGuideLable release];
    [mobileNumberField release];
    [newpasswordTextField release];
    [infoTextLable release];
    [sendEmailButton release];
    [signinActivityIndicator release];
    [mainHomeView release];
    [m_Gradientlayer release];
    [m_GradientColorSet release];
    
    [m_EmailBottomlayer release];
    [m_PasswordBottomlayer release];

    [super dealloc];
}

-(IBAction)menuCloseButtonClick:(id)sender
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

-(IBAction)sendEmailButtonClick:(id)sender
{
    AppGlobalData *sharedManager = [AppGlobalData sharedManager];

    if(self.mobileNumberField.text.length == 0)
    {
        if ([UIAlertController class]) {
            // use UIAlertController
            
            UIAlertController *emailAlert = [UIAlertController alertControllerWithTitle:nil message:@"Email cannot be empty!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [emailAlert dismissViewControllerAnimated:YES completion:nil];
                                                                      
                                                                  }];
            
            
            
            [emailAlert addAction:defaultAction];
            [self presentViewController:emailAlert animated:YES completion:nil];
        }
        
        return;
    }
    
    if(![AppGlobalData validateEmail:self.mobileNumberField.text])
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
    
    NSString * newpasswordString = self.newpasswordTextField.text;
    if(newpasswordString != nil && newpasswordString.length > 0 )
    {
        if (![AppGlobalData validatePassword:newpasswordString])
        {
            if ([UIAlertController class]) {
                // use UIAlertController
                
                UIAlertController *passwordAlert = [UIAlertController alertControllerWithTitle:@"Invalid Password" message:@"The password should have at least 8 characters, and the password must include at least 3 out of the 4 categories of characters (upper-case letters, lower-case letters, numbers, and special characters)" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    [passwordAlert dismissViewControllerAnimated:YES completion:nil];
                    
                }];
                
                [passwordAlert addAction:defaultAction];
                [self presentViewController:passwordAlert animated:YES completion:nil];
            }
            return;
        }
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@/forgotpassword?email=%@&password=%@", Database_Connector_URL,   [sharedManager encodeSpecialCharacters:[self.mobileNumberField.text  stringByAddingPercentEscapesUsingEncoding:NSWindowsCP1252StringEncoding]], [sharedManager encodeSpecialCharacters:[newpasswordString stringByAddingPercentEscapesUsingEncoding:NSWindowsCP1252StringEncoding]]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request setTimeOutSeconds:sharedManager.SETTING_HTTP_REQUEST_TIME_OUT];
    [request setDidFinishSelector:@selector(forgotPasswordtaskFinished:)];
    
    [request setDelegate:self];
    [request startAsynchronous];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", error);
}

- (void)forgotPasswordtaskFinished:(ASIHTTPRequest *)request
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
                
                UIAlertController *signupAlert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                     message:[lerrorList objectAtIndex:0] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {
                                                                          [signupAlert dismissViewControllerAnimated:YES completion:nil];
                                                                          
                                                                      }];
                
                
                
                [signupAlert addAction:defaultAction];
                [self presentViewController:signupAlert animated:YES completion:nil];
            } else {
                // use UIAlertView
                UIAlertView *signupAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[lerrorList objectAtIndex:0]
                                                                     delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [signupAlert show];
                [signupAlert release];
            }
            
            return;
        }
    }
    
    else
    {
        //send successfully

        if ([UIAlertController class]) {
            // use UIAlertController
            
            UIAlertController *signupAlert = [UIAlertController alertControllerWithTitle:nil message:@"Sent successfully!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [signupAlert dismissViewControllerAnimated:YES completion:nil];
                                                                      
                                                                  }];
            
            
            
            [signupAlert addAction:defaultAction];
            [self presentViewController:signupAlert animated:YES completion:nil];
        } else {
            // use UIAlertView
            UIAlertView *signupAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Sent successfully!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [signupAlert show];
            [signupAlert release];
        }
        
         [self.navigationController popViewControllerAnimated:YES];
    }
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
    self.m_EmailBottomlayer = [CAGradientLayer layer];
    self.m_PasswordBottomlayer = [CAGradientLayer layer];
  
    CGFloat borderWidth = 2;
    float x = 90.0/360.0;
    //create coordinates
    float a = pow(sinf((2*M_PI*((x+0.75)/2))),2);
    float b = pow(sinf((2*M_PI*((x+0.0)/2))),2);
    float c = pow(sinf((2*M_PI*((x+0.25)/2))),2);
    float d = pow(sinf((2*M_PI*((x+0.5)/2))),2);
    
    self.m_EmailBottomlayer.frame = CGRectMake(0, self.mobileNumberField.frame.size.height - borderWidth, self.mobileNumberField.frame.size.width, self.mobileNumberField.frame.size.height);
    self.m_EmailBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#8199BE"].CGColor, (id)[UIColor colorWithHexString:@"#8199BE"].CGColor, nil];
    
    //set the gradient direction
    [self.m_EmailBottomlayer setStartPoint:CGPointMake(a, b)];
    [self.m_EmailBottomlayer setEndPoint:CGPointMake(c, d)];
    self.m_EmailBottomlayer.drawsAsynchronously = YES;
    
    [self.mobileNumberField.layer addSublayer:self.m_EmailBottomlayer];
    self.mobileNumberField.layer.masksToBounds = YES;
    
    self.m_PasswordBottomlayer.frame = CGRectMake(0, self.newpasswordTextField.frame.size.height - borderWidth, self.newpasswordTextField.frame.size.width, self.newpasswordTextField.frame.size.height);
    self.m_PasswordBottomlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#8199BE"].CGColor, (id)[UIColor colorWithHexString:@"#8199BE"].CGColor, nil];
    
    //set the gradient direction
    [self.m_PasswordBottomlayer setStartPoint:CGPointMake(a, b)];
    [self.m_PasswordBottomlayer setEndPoint:CGPointMake(c, d)];
    self.m_PasswordBottomlayer.drawsAsynchronously = YES;
    
    [self.newpasswordTextField.layer addSublayer:self.m_PasswordBottomlayer];
    self.newpasswordTextField.layer.masksToBounds = YES;
}
@end

