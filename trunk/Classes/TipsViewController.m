//
//  TipsViewController.m
//  BMWE3
//
//  Created by Doug Strittmatter on 12/16/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import "TipsViewController.h"


@implementation TipsViewController

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
	
	// get tips from plist
	NSString *finalPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Tips.plist"];
	NSDictionary *dictPlistData = [[NSDictionary dictionaryWithContentsOfFile:finalPath] retain];
	arrTips = [dictPlistData objectForKey:@"Tips"];
	
	[self changeTip];
}
 

-(void) changeTip
{
	intTipCounter1 = (arc4random() % ([arrTips count]-1));
	dictTip1 = [arrTips objectAtIndex:intTipCounter1];
	lblTip1.text = [dictTip1 objectForKey:@"tip"];
	if ([[dictTip1 objectForKey:@"badge"] isEqualToString:@"YES"])
		imgBadge1.hidden = NO;
	imgTip1.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [dictTip1 objectForKey:@"condition"]]];
	
	intTipCounter2 = (arc4random() % ([arrTips count]-1));
	while (intTipCounter1 == intTipCounter2) {
		intTipCounter2 = (arc4random() % ([arrTips count]-1));
	}
	
	dictTip2 = [arrTips objectAtIndex:intTipCounter2];
	lblTip2.text = [dictTip2 objectForKey:@"tip"];
	if ([[dictTip2 objectForKey:@"badge"] isEqualToString:@"YES"]) 
		imgBadge2.hidden = NO;
	imgTip2.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [dictTip2 objectForKey:@"condition"]]];
	
	intTipCounter3 = (arc4random() % ([arrTips count]-1));
	while (intTipCounter2 == intTipCounter3 || intTipCounter1 == intTipCounter3) {
		intTipCounter3 = (arc4random() % ([arrTips count]-1));
	}
	
	dictTip3 = [arrTips objectAtIndex:intTipCounter3];
	lblTip3.text = [dictTip3 objectForKey:@"tip"];
	if ([[dictTip3 objectForKey:@"badge"] isEqualToString:@"YES"]) 
		imgBadge3.hidden = NO;
	imgTip3.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [dictTip3 objectForKey:@"condition"]]];
	
	intTipCounter4 = (arc4random() % ([arrTips count]-1));
	while (intTipCounter3 == intTipCounter4 || intTipCounter2 == intTipCounter4 || intTipCounter1 == intTipCounter4) {
		intTipCounter4 = (arc4random() % ([arrTips count]-1));
	}
	
	dictTip4 = [arrTips objectAtIndex:intTipCounter4];
	lblTip4.text = [dictTip4 objectForKey:@"tip"];
	if ([[dictTip4 objectForKey:@"badge"] isEqualToString:@"YES"]) 
		imgBadge4.hidden = NO;
	imgTip4.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [dictTip4 objectForKey:@"condition"]]];
	
	/*if (intTipCounter == [arrTips count]) {
	 intTipCounter = 0;
	 } else {
	 intTipCounter++;
	 }*/
	
}


-(void) backPressed:(id)sender
{
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	[applicationDelegate displayDiveView];
	[applicationDelegate resetTips];
}


-(void) tipsPressed:(id)sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://forum.BMWActivateTheFuture.com/tips"]];
}


-(void) tipDetailPressed1:(id)sender
{
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	[applicationDelegate displayTipDetailView];	
	NSDictionary *dictTip = [arrTips objectAtIndex:intTipCounter1];
	[[applicationDelegate tipDetailViewController] setText:[dictTip objectForKey:@"tip"] andBadge:imgBadge1.hidden andType:[dictTip1 objectForKey:@"condition"]];
}


-(void) tipDetailPressed2:(id)sender
{
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	[applicationDelegate displayTipDetailView];	
	NSDictionary *dictTip = [arrTips objectAtIndex:intTipCounter2];
	[[applicationDelegate tipDetailViewController] setText:[dictTip objectForKey:@"tip"] andBadge:imgBadge2.hidden andType:[dictTip2 objectForKey:@"condition"]];
}


-(void) tipDetailPressed3:(id)sender
{
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	[applicationDelegate displayTipDetailView];	
	NSDictionary *dictTip = [arrTips objectAtIndex:intTipCounter3];
	[[applicationDelegate tipDetailViewController] setText:[dictTip objectForKey:@"tip"] andBadge:imgBadge3.hidden andType:[dictTip3 objectForKey:@"condition"]];
}


-(void) tipDetailPressed4:(id)sender
{
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	[applicationDelegate displayTipDetailView];	
	NSDictionary *dictTip = [arrTips objectAtIndex:intTipCounter4];
	[[applicationDelegate tipDetailViewController] setText:[dictTip objectForKey:@"tip"] andBadge:imgBadge4.hidden andType:[dictTip4 objectForKey:@"condition"]];
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
