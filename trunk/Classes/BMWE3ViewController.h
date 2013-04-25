//
//  BMWE3ViewController.h
//  BMWE3
//
//  Created by Doug Strittmatter on 11/2/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <AVFoundation/AVFoundation.h>

#import "CrumbPath.h"
#import "CrumbPathView.h"
#import "GDataXMLNode.h"

@interface BMWE3ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate>
{
@private
    
    UIView *containerView;
	MKMapView *map;
	
	IBOutlet UIView *resultsView;
    
    CrumbPath *crumbs;
    CrumbPathView *crumbView;
    
    CLLocationManager *locationManager;
	
	IBOutlet UILabel *distLabel;
	IBOutlet UIButton *tripButton;
	
	NSTimer *timerIdle;
	
	NSSet *setTripSegments;
	
	IBOutlet UILabel *chargeLabel;
	IBOutlet UIImageView *imgProgressBar;
	
	IBOutlet UIImageView *currentDigit1;
	IBOutlet UIImageView *newDigit1;
	IBOutlet UIImageView *currentDigit2;
	IBOutlet UIImageView *newDigit2;
	IBOutlet UIImageView *currentDigit3;
	IBOutlet UIImageView *newDigit3;
	IBOutlet UIImageView *currentDigit4;
	IBOutlet UIImageView *newDigit4;
	IBOutlet UIImageView *currentDigit5;
	IBOutlet UIImageView *newDigit5;
	double dLastDist;
    
    int intDigit1;
    int intDigit2;
    int intDigit3;
    int intDigit4;
    int intDigit5;
}


@property (nonatomic, retain) UIView *containerView;
@property (nonatomic, retain) IBOutlet MKMapView *map;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSSet *setTripSegments;


-(void) switchToBackgroundMode:(BOOL)background;
-(void) stopPressed:(id)sender;
-(void) endPressed:(id)sender;
-(void) resultsContinuePressed:(id)sender;
-(void) stopLocationManager;
-(void) startLocationManager;
- (IBAction)cancelTripPressed:(id)sender;

-(void) storeTripInfo:(NSString*)strCategory
		  andTripName:(NSString*)strName;
-(void) storeTripSegment:(NSString*)strType;

-(void) loadDealers;
-(void) loadChargeStation;

-(void) setMeter;

@end

