//
//  SetupViewController.m
//  BMWE3
//
//  Created by Doug Strittmatter on 12/2/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import "SetupViewController.h"
#import "DataManager.h"

@implementation SetupViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


-(IBAction) continueIntroPressed:(id)sender
{
	introView.hidden = YES;
}


-(IBAction) continueStep1Pressed:(id)sender
{
	if ([txtFieldZipCode.text length] != 5) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Zip Code" 
														message:@"Please enter a valid zip code."
													   delegate:self 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else {
		[[DataManager sharedManager] setZipCode:txtFieldZipCode.text];
		step1View.hidden = YES;
	}
}


-(IBAction) continueStep2Pressed:(id)sender
{
	[[DataManager sharedManager] setShareData:swchShareData.on];
	step2View.hidden = YES;
}


-(IBAction) submitStep3Pressed:(id)sender
{
	if ([txtFieldFirstName.text isEqualToString:@""] || [txtFieldLastName.text isEqualToString:@""] || [txtFieldEmail.text isEqualToString:@""]) 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incomplete Fields" 
														message:@"Please enter information in all the fields."
													   delegate:self 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else if (![self validateEmail:txtFieldEmail.text]) 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Email" 
														message:@"Please enter a valid email address."
													   delegate:self 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else
	{
		[[DataManager sharedManager] setFirstName:txtFieldFirstName.text];
		[[DataManager sharedManager] setLastName:txtFieldLastName.text];
		[[DataManager sharedManager] setEmail:txtFieldEmail.text];
		[[DataManager sharedManager] setSubmitInfo:4];
		step3View.hidden = YES;
	}
}


-(IBAction) skipStep3Pressed:(id)sender
{
	step3View.hidden = YES;
}


-(IBAction) continueFinishPressed:(id)sender
{
	if ([[DataManager sharedManager] getShareData]) 
		[[DataManager sharedManager] sendUserData];
	[[DataManager sharedManager] setSetupComplete:TRUE];
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	[applicationDelegate displayStartTripView];
}


-(IBAction) continueURLPressed:(id)sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.BMWActivateTheFuture.com"]];
}


-(void) helpPressed:(id)sender
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" 
													message:@"Click the share button with confidence knowing none of your personal information will be connected with this data, and will only be used to calculate average usage patterns."
												   delegate:self 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}


- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    
    return [emailTest evaluateWithObject:candidate];
}



#pragma mark - text field methods

- (BOOL)textFieldShouldReturn: (UITextField *)textField {
	[textField resignFirstResponder];
	
	// animate image views
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationRepeatCount:0];
	
	CGRect frame = self.view.frame;	
	frame.origin.y = 0;
	self.view.frame = frame;
	
	[UIView commitAnimations];
	
	return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)sender
{
	float flYPos = 0;
    if ([sender isEqual:txtFieldLastName])
    {
        flYPos = -60;
        
    } else if ([sender isEqual:txtFieldEmail])
    {
        flYPos = -120;
        
    }
	
	// animate image views
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationRepeatCount:0];
	
	CGRect frame = self.view.frame;	
	frame.origin.y = flYPos;
	self.view.frame = frame;
}



- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
	
	// animate image views
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationRepeatCount:0];
	
	CGRect frame = self.view.frame;	
	frame.origin.y = 0;
	self.view.frame = frame;
	
	[UIView commitAnimations];
	
	[txtFieldFirstName resignFirstResponder];
	[txtFieldLastName resignFirstResponder];
	[txtFieldEmail resignFirstResponder];
	[txtFieldZipCode resignFirstResponder];
}




/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
