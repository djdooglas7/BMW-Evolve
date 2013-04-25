//
//  FinishTripViewController.m
//  BMWE3
//
//  Created by Doug Strittmatter on 12/22/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import "FinishTripViewController.h"
#import "DataManager.h"
#import "BMWE3ViewController.h"

@implementation FinishTripViewController

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	arrTripTypes = [[NSArray alloc] initWithObjects:@"Work Commute", @"Errands", @"Family Activity", @"Joy Ride", @"Other", nil];
	strTripType = [[NSMutableString alloc] initWithString:@"Work Commute"];
}


-(void) tripTypePressed:(id)sender
{
	[txtFieldName resignFirstResponder];
	
	if (tripTypePickerView.frame.origin.y == 480) 
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.5];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationRepeatCount:0];
		
		CGRect frame = tripTypePickerView.frame;	
		frame.origin.y = 244;
		tripTypePickerView.frame = frame;
		
		[UIView commitAnimations];
	} else 
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.5];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationRepeatCount:0];
		
		CGRect frame = tripTypePickerView.frame;	
		frame.origin.y = 480;
		tripTypePickerView.frame = frame;
		
		[UIView commitAnimations];
	}

}


-(void) backPressed:(id)sender
{
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	[applicationDelegate displayParkView];
}


-(void) endPressed:(id)sender
{
	if ([btnTripType.titleLabel.text isEqualToString:@"Select"]) 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Trip Type" message:@"Please select a trip type."
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else {
		id applicationDelegate = [[UIApplication sharedApplication] delegate];
		[applicationDelegate displayResultsView];
		NSMutableArray *arrTripSegments = [[DataManager sharedManager] arrTripSegments];
		
		if ([arrTripSegments count] > 0)
		{
			[[applicationDelegate bmwe3ViewController] storeTripInfo:strTripType
														 andTripName:txtFieldName.text];
			[[DataManager sharedManager] setHitZero:FALSE];
			[applicationDelegate resetDrivingScreen];
            txtFieldName.text = @"";
		}
	}
}


#pragma mark - picker view methods

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
	[btnTripType setTitle:[arrTripTypes objectAtIndex:row] forState:UIControlStateNormal];
	[strTripType release];
	strTripType = [[NSMutableString alloc] initWithString:[arrTripTypes objectAtIndex:row]];
    
    if (tripTypePickerView.frame.origin.y == 244) 
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.5];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationRepeatCount:0];
		
		CGRect frame = tripTypePickerView.frame;	
		frame.origin.y = 480;
		tripTypePickerView.frame = frame;
		
		[UIView commitAnimations];
	}
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	
	return 1;
}


- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	
	return [arrTripTypes count];
}


- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
	return [arrTripTypes objectAtIndex:row];
}


#pragma mark - text field methods

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
	if (tripTypePickerView.frame.origin.y == 244) 
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.5];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationRepeatCount:0];
		
		CGRect frame = tripTypePickerView.frame;	
		frame.origin.y = 480;
		tripTypePickerView.frame = frame;
		
		[UIView commitAnimations];
	}
	return YES;
}


- (BOOL)textFieldShouldReturn: (UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}


- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
	for (UIView* view in self.view.subviews) {
		if ([view isKindOfClass:[UITextField class]])
			[view resignFirstResponder];
	}
	
	if (tripTypePickerView.frame.origin.y == 244) 
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.5];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationRepeatCount:0];
		
		CGRect frame = tripTypePickerView.frame;	
		frame.origin.y = 480;
		tripTypePickerView.frame = frame;
		
		[UIView commitAnimations];
	}
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
	[strTripType release];
    [super dealloc];
}


@end
