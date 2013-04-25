//
//  BMWE3ViewController.m
//  BMWE3
//
//  Created by Doug Strittmatter on 11/2/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import "BMWE3ViewController.h"
#import "BMWE3AppDelegate.h"
#import "SettingsViewController.h"
#import "DataManager.h"
#import "ChargeAnnotation.h"
#import "DealerAnnotation.h"
#import "ParkPlaceMark.h"

@implementation BMWE3ViewController

@synthesize containerView, map, locationManager, setTripSegments;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	crumbs = nil;
	dLastDist = 0.0;
	/*NSMutableArray *arrCoords = [[DataManager sharedManager] retrieveCoordItems];
	
	for (Coord *info in arrCoords) 
	{
		//NSLog(@"CrumbPath latitude: %@", info.latitude);
		//NSLog(@"CrumbPath longitude: %@", info.longitude);
		[self initMap:info];
	}*/
	
	DataManager *manager = [DataManager sharedManager];
	manager.isFinishedLoading = YES;
	//chargeProgressView.progress = 1;

    // Note: we are using Core Location directly to get the user location updates.
    // We could normally use MKMapView's user location update delegation but this does not work in
    // the background.  Plus we want "kCLLocationAccuracyBestForNavigation" which gives us a better accuracy.
    //
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.locationManager.delegate = self; // Tells the location manager to send updates to this object
    CLLocationCoordinate2D coord = {38.0f, -95.0f};
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 2000000, 2000000);
	[map setRegion:region animated:FALSE];

    
    // By default use the best accuracy setting (kCLLocationAccuracyBest)
	//
	// You mau instead want to use kCLLocationAccuracyBestForNavigation, which is the highest possible
	// accuracy and combine it with additional sensor data.  Note that level of accuracy is intended
	// for use in navigation applications that require precise position information at all times and
	// are intended to be used only while the device is plugged in.
    //

	[NSTimer scheduledTimerWithTimeInterval:3 
									 target:self 
								   selector:@selector(startTracking) 
								   userInfo:nil 
									repeats:NO];
	
	[self startIdleTimer];
	
	[self setDial];
    
    
}


-(void) initMap:(Coord *)coord
{
	if (!crumbs)
	{
		// This is the first time we're getting a location update, so create
		// the CrumbPath and add it to the map.
		//
		crumbs = [[CrumbPath alloc] initWithCenterCoordinate:coord.coordinate];
		[map addOverlay:crumbs];

	}
	else
	{
		// This is a subsequent location update.
		// If the crumbs MKOverlay model object determines that the current location has moved
		// far enough from the previous location, use the returned updateRect to redraw just
		// the changed area.
		//
		// note: iPhone 3G will locate you using the triangulation of the cell towers.
		// so you may experience spikes in location data (in small time intervals)
		// due to 3G tower triangulation.
		// 
		
		MKMapRect updateRect = [crumbs addCoordinate:coord.coordinate];
		
		
		
		if (!MKMapRectIsNull(updateRect))
		{
			// There is a non null update rect.
			// Compute the currently visible map zoom scale
			MKZoomScale currentZoomScale = map.bounds.size.width / map.visibleMapRect.size.width;
			// Find out the line width at this zoom scale and outset the updateRect by that amount
			CGFloat lineWidth = MKRoadWidthAtZoomScale(currentZoomScale);
			updateRect = MKMapRectInset(updateRect, -lineWidth, -lineWidth);
			// Ask the overlay view to update just the changed area.
			[crumbView setNeedsDisplayInMapRect:updateRect];

		}
	}
}


-(void) startTracking
{
	BOOL navigationAccuracy = [[DataManager sharedManager] isLocationAccuracyBestForNavigation];
	if (self.locationManager)
	{
		self.locationManager.desiredAccuracy = (navigationAccuracy ? kCLLocationAccuracyBestForNavigation : kCLLocationAccuracyBest);
		[self.locationManager startUpdatingLocation];
	}
}


# pragma mark - charge bar and meter methods

-(void) setDial
{
	[self setMeter];
	
	//float dCharge = [[DataManager sharedManager] getCurrentCharge];
	NSString *strDist = [[NSString alloc] initWithFormat:@"%.1f", [crumbs fltDist]];
	
	for (int i=0; i<5; i++) {
		int intDigit = [strDist length]-1-i;
		if (intDigit >= 0) {
			NSRange range = {intDigit,1};
			NSString *strChar = [NSString stringWithFormat:@"%@",[strDist substringWithRange:range]];
			if (![strChar isEqualToString:@"."]) {
				switch (i) {
					case 5:
						[currentDigit1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"header_odometer_white_%@.png", strChar]]];
                        intDigit1 = [strChar intValue];
						break;
					case 4:
						[currentDigit2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"header_odometer_white_%@.png", strChar]]];
                        intDigit2 = [strChar intValue];
						break;
					case 3:
						[currentDigit3 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"header_odometer_white_%@.png", strChar]]];
                        intDigit3 = [strChar intValue];
						break;
					case 2:
						[currentDigit4 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"header_odometer_white_%@.png", strChar]]];
                        intDigit4 = [strChar intValue];
						break;
					case 0:
						[currentDigit5 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"header_odometer_black_%@.png", strChar]]];
                        intDigit5 = [strChar intValue];
						break;
					default:
						break;
				}
			}	
		}
	}
}


-(void) turnDialAndMeter
{
	[self setMeter];

	
	NSString *strDist = [NSString stringWithFormat:@"%.1f", [crumbs fltDist]];
	NSString *strLastDist = [NSString stringWithFormat:@"%.1f", dLastDist];
	// update dist
	if (![strDist isEqualToString:strLastDist])
	{
		// loop through the digits of the charge, process from last to first
		for (int i=0; i<6; i++) {
			int intDigit = [strDist length]-1-i;
			
			if (intDigit >= 0) {
				NSRange range = {intDigit,1};
				NSString *strChar = [NSString stringWithFormat:@"%@",[strDist substringWithRange:range]];
				
				if (![strChar isEqualToString:@"."]) 
				{
					switch (i) 
					{
						case 5:
                            if (intDigit1 != [strChar intValue]) {
                                [self currentDigitAnimation:i
                                        andCurrentImageView:currentDigit1 
                                            andNewImageView:newDigit1 
                                            andCurrentValue:strChar];
                                intDigit1 = [strChar intValue];
                            }
							break;
						case 4:
                            if (intDigit2 != [strChar intValue]) {
                                [self currentDigitAnimation:i
                                        andCurrentImageView:currentDigit2 
                                            andNewImageView:newDigit2 
                                            andCurrentValue:strChar];
                                intDigit2 = [strChar intValue];
                            }
							break;
						case 3:
                            if (intDigit3 != [strChar intValue]) {
                                [self currentDigitAnimation:i
                                        andCurrentImageView:currentDigit3 
                                            andNewImageView:newDigit3
                                            andCurrentValue:strChar];
                                intDigit3 = [strChar intValue];
                            }
							break;
						case 2:
                            if (intDigit4 != [strChar intValue]) {
                                [self currentDigitAnimation:i
                                        andCurrentImageView:currentDigit4 
                                            andNewImageView:newDigit4
                                            andCurrentValue:strChar];
                                intDigit4 = [strChar intValue];
                            }
							break;
						case 0:
                            if (intDigit5 != [strChar intValue]) {
                                [self currentDigitAnimation:i
                                        andCurrentImageView:currentDigit5
                                            andNewImageView:newDigit5 
                                            andCurrentValue:strChar];
                                intDigit5 = [strChar intValue];
                            }
							break;
						default:
							break;
					}
				}	
			}
		}
	}
}


-(void) setMeter
{
	
	double dCharge = [[DataManager sharedManager] getCurrentCharge];
	
	// update charge meter
	if (dCharge > 0) {
		[imgProgressBar setFrame:CGRectMake(imgProgressBar.frame.origin.x, imgProgressBar.frame.origin.y, dCharge * .27, imgProgressBar.frame.size.height)];
		chargeLabel.text = [NSString stringWithFormat:@"%.1f MILES REMAINING",[[DataManager sharedManager] getCurrentCharge]];
	} else if (dCharge <= 0) {
		[[DataManager sharedManager] setHitZero:TRUE];
	}
}


-(void) currentDigitAnimation:(int)intDigitCount
		  andCurrentImageView:(UIImageView*)imgViewCurrent
			  andNewImageView:(UIImageView*)imgViewNew
			  andCurrentValue:(NSString*)strValue
{
	if (intDigitCount == 0) {
		[imgViewNew setImage:[UIImage imageNamed:[NSString stringWithFormat:@"header_odometer_black_%@.png", strValue]]];
	} else {
		[imgViewNew setImage:[UIImage imageNamed:[NSString stringWithFormat:@"header_odometer_white_%@.png", strValue]]];
	}
	
	NSArray *arrDigitAnimation = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:intDigitCount], imgViewCurrent, imgViewNew, strValue, nil];
	
	// animate image views
	[UIView beginAnimations:nil context:arrDigitAnimation];
	[UIView setAnimationDuration:1];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationRepeatCount:0];
	[UIView setAnimationDidStopSelector:@selector(digitAnimationFinished:finished:context:)];
	
	CGRect frame = imgViewCurrent.frame;	
	frame.origin.y = 96;
	imgViewCurrent.frame = frame;
	
	frame = imgViewNew.frame;	
	frame.origin.y = 71;
	imgViewNew.frame = frame;
	
	[UIView commitAnimations];
}


-(void) digitAnimationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context
{
	NSArray *arrDigitAnimation = [NSArray arrayWithArray:context];
	//NSLog(@"%i", [arrDigitAnimation count]);
	
	int intDigitCount = [[arrDigitAnimation objectAtIndex:0] intValue];
	UIImageView *imgViewCurrent = (UIImageView*)[arrDigitAnimation objectAtIndex:1];
	UIImageView *imgViewNew = (UIImageView*)[arrDigitAnimation objectAtIndex:2];
	NSString *strValue = (NSString*)[arrDigitAnimation objectAtIndex:3];
	
	if (intDigitCount == 0) {
		[imgViewCurrent setImage:[UIImage imageNamed:[NSString stringWithFormat:@"header_odometer_black_%@.png", strValue]]];
	} else {
		[imgViewCurrent setImage:[UIImage imageNamed:[NSString stringWithFormat:@"header_odometer_white_%@.png", strValue]]];
	}
    
    
	
	// return imgviews to original position
	CGRect frame = imgViewCurrent.frame;	
	frame.origin.y = 71;
	imgViewCurrent.frame = frame;
	
	frame = imgViewNew.frame;	
	frame.origin.y = 46;
	imgViewNew.frame = frame;
}


- (void)idlePrompt
{
	BMWE3AppDelegate *applicationDelegate = [[UIApplication sharedApplication] delegate];
	
	if (applicationDelegate.currentScreenType == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Paused" message:@"No longer driving? Please select your EV’s current state:"
													   delegate:self cancelButtonTitle:@"Resume Drive" otherButtonTitles:@"Stop", @"End Trip", nil];
		[alert show];
		[alert release];
	}
}


#pragma mark -
#pragma mark Actions

// called them the app is moved to the background (user presses the home button) or to the foreground 
//
- (void)switchToBackgroundMode:(BOOL)background
{
    [self setMeter];
    /*if (background)
    {

		[self.locationManager stopUpdatingLocation];
		self.locationManager.delegate = nil;
        
    }
    else
    {

		self.locationManager.delegate = self;
		[self.locationManager startUpdatingLocation];
        
    }*/
}


- (void)stopPressed:(id)sender
{
	[self stopIdleTimer];
	
	[self storeTripSegment:@"Driving"];
	
	[self stopLocationManager];
	
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	[applicationDelegate displayParkView];
}


- (void)endPressed:(id)sender
{
	[self stopIdleTimer];
	
	[self storeTripSegment:@"Driving"];

	[self stopLocationManager];
	
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	[applicationDelegate displayFinishTripView];
	
	/*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"End Trip" message:@"By clicking END TRIP, you are simulating the end of your driving day or the start of a different trip type."
												   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"End Trip", nil];
	[alert show];
	[alert release];*/
}


- (IBAction)cancelTripPressed:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cancel Trip" 
                                                    message:@"Pressing this will cancel your current trip."
												   delegate:self 
                                          cancelButtonTitle:@"Continue" 
                                          otherButtonTitles:@"Cancel Trip", nil];
	[alert show];
	[alert release];
}


-(void) resultsContinuePressed:(id)sender
{
	resultsView.hidden = YES;
	
	BMWE3AppDelegate *applicationDelegate = [[UIApplication sharedApplication] delegate];
	[applicationDelegate displayStartTripView];
	applicationDelegate.bmwe3ViewController = nil;
}
	 
	 
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex 
{
	if ((alertView.title == @"Paused") && (buttonIndex == 2))
	{
		//[self.locationManager stopUpdatingLocation];
		//self.locationManager.delegate = nil;
		
		[self storeTripSegment:@"Driving"];
	} 
	else if ((alertView.title == @"Paused") && (buttonIndex == 1))
	{
		//[self.locationManager stopUpdatingLocation];
		//self.locationManager.delegate = nil;
		
		[self storeTripSegment:@"Driving"];
		
		id applicationDelegate = [[UIApplication sharedApplication] delegate];
		[applicationDelegate displayParkView];
	}
	else if ((alertView.title == @"Paused") && (buttonIndex == 0))
	{
		[self startIdleTimer];
	}
    else if ((alertView.title == @"Cancel Trip") && (buttonIndex == 1))
	{
		[self stopIdleTimer];
        [self stopLocationManager];
        [[DataManager sharedManager] cancelTrip];
        
        id applicationDelegate = [[UIApplication sharedApplication] delegate];
        [applicationDelegate displayStartTripView];
        [applicationDelegate resetDrivingScreen];
	}
}


-(void) storeTripInfo:(NSString*)strCategory
		  andTripName:(NSString*)strName
{
	[[DataManager sharedManager] addTrip:strCategory
							 andTripName:strName];
	
	//resultsView.hidden = NO;
	id *applicationDelegate = [[UIApplication sharedApplication] delegate];
	[applicationDelegate displayTripResultsView];
}


-(void) storeTripSegment:(NSString*)strType
{

	NSDate *dateToday = [[NSDate alloc] init];
	NSDate *dateStart = [[NSDate alloc] init];
	dateStart = [[DataManager sharedManager] getStartDate];
	
	[[DataManager sharedManager] addTripSegment:strType
								   andStartDate:dateStart 
									 andEndDate:dateToday 
									andDistance:[NSNumber numberWithFloat:[crumbs fltSegDist]]];

	[[DataManager sharedManager] setStartDate:[NSDate date]];
    [crumbs resetSegDist];
}


-(void) startIdleTimer
{
	/*if (!timerIdle)
		timerIdle = [NSTimer scheduledTimerWithTimeInterval:300 
													 target:self 
												   selector:@selector(idlePrompt) 
												   userInfo:nil 
													repeats:NO];*/
}


-(void) stopIdleTimer
{
	if (timerIdle) {
		[timerIdle invalidate];
		timerIdle = nil;
	}
}


-(void) loadChargeStations
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"chargeLocations" ofType:@"xml"];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData 
                                                           options:0 error:&error];
    if (doc) { 
        //Party *party = [[[Party alloc] init] autorelease];
        NSArray *arrChargeStations = [doc.rootElement elementsForName:@"fuel-station"];
        for (GDataXMLElement *chargeStation in arrChargeStations) 
        {        
            float flLat;
            float flLong;
            
            // Latitude
            NSArray *arrLat = [chargeStation elementsForName:@"latitude"];
            if (arrLat.count > 0) {
                GDataXMLElement *GDataLat = (GDataXMLElement *) [arrLat objectAtIndex:0];
                flLat = GDataLat.stringValue.floatValue;
            } else continue;
            
            // Longitude
            NSArray *arrLong = [chargeStation elementsForName:@"longitude"];
            if (arrLong.count > 0) {
                GDataXMLElement *GDataLong = (GDataXMLElement *) [arrLong objectAtIndex:0];
                flLong = GDataLong.stringValue.floatValue;
            } else continue;
            
            //Coord *coorgetCurrentCharge;
            CLLocationCoordinate2D coorgetCurrentCharge = {flLat, flLong};
            
            ChargeAnnotation *chargeAnnotation = [[ChargeAnnotation alloc] initWithCoordinate:coorgetCurrentCharge];
            [map addAnnotation:chargeAnnotation];
        }
        
        [doc release];
    }
    
    [xmlData release];
}


-(void) loadDealers
{
    NSString *finalPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Dealer.plist"];
    NSArray *arrDealers = [NSArray arrayWithContentsOfFile:finalPath];
    
    for (NSDictionary *dictDealer in arrDealers) 
    {
        float flLat = [[dictDealer objectForKey:@"Latitude"] floatValue];
        float flLong = [[dictDealer objectForKey:@"Longitude"] floatValue];
        
        CLLocationCoordinate2D coordDealer = {flLat, flLong};
        
        DealerAnnotation *dealerAnnotation = [[DealerAnnotation alloc] initWithCoordinate:coordDealer];
        [map addAnnotation:dealerAnnotation];
    }
}


#pragma mark -
#pragma mark MapKit

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    if (newLocation)
    {

		
		// make sure the old and new coordinates are different
        if ((oldLocation.coordinate.latitude != newLocation.coordinate.latitude) &&
            (oldLocation.coordinate.longitude != newLocation.coordinate.longitude))
        {    
			BOOL navigationAccuracy = [[DataManager sharedManager] isLocationAccuracyBestForNavigation];
			self.locationManager.desiredAccuracy = (navigationAccuracy ? kCLLocationAccuracyBestForNavigation : kCLLocationAccuracyBest);
			
            if (!crumbs)
            {
				
				
                // This is the first time we're getting a location update, so create
                // the CrumbPath and add it to the map.
                //
                crumbs = [[CrumbPath alloc] initWithCenterCoordinate:newLocation.coordinate];
                [map addOverlay:crumbs];
                
                // On the first location update only, zoom map to user location
                MKCoordinateRegion region = 
				MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 2000, 2000);
                [map setRegion:region animated:YES];
                
                //[self loadDealers];
                [self loadChargeStations];
                
            }
            else
            {
                // This is a subsequent location update.
                // If the crumbs MKOverlay model object determines that the current location has moved
                // far enough from the previous location, use the returned updateRect to redraw just
                // the changed area.
                //
                // note: iPhone 3G will locate you using the triangulation of the cell towers.
                // so you may experience spikes in location data (in small time intervals)
                // due to 3G tower triangulation.
                // 
				
				dLastDist = [crumbs fltDist];
				
                MKMapRect updateRect = [crumbs addCoordinate:newLocation.coordinate];
                
                double getCurrentCharge = [[DataManager sharedManager] getCurrentCharge];
                double dNewCharge = getCurrentCharge - ((double)[crumbs fltDist] - dLastDist);
                
                if (dNewCharge < 0) {
                    dNewCharge = 0;
                }
                
                // add to current charge
                [[DataManager sharedManager] setCurrentCharge:dNewCharge];

				[self turnDialAndMeter];
                
                if (!MKMapRectIsNull(updateRect))
                {
                    // There is a non null update rect.
                    // Compute the currently visible map zoom scale
                    MKZoomScale currentZoomScale = map.bounds.size.width / map.visibleMapRect.size.width;
                    // Find out the line width at this zoom scale and outset the updateRect by that amount
                    CGFloat lineWidth = MKRoadWidthAtZoomScale(currentZoomScale);
                    updateRect = MKMapRectInset(updateRect, -lineWidth, -lineWidth);
                    // Ask the overlay view to update just the changed area.
                    [crumbView setNeedsDisplayInMapRect:updateRect];
					
					MKCoordinateRegion region = 
					MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 2000, 2000);
					[map setRegion:region animated:YES];

                }
				
				//[map setCenterCoordinate:map.userLocation.location.coordinate animated:YES];
				
				[self stopIdleTimer];
				[self startIdleTimer];
            }
        }
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // handle our two custom annotations
    //
    if ([annotation isKindOfClass:[ParkPlaceMark class]]) 
    {
        // try to dequeue an existing pin view first
        static NSString* TripAnnotationIdentifier = @"tripAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        [map dequeueReusableAnnotationViewWithIdentifier:TripAnnotationIdentifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[[MKPinAnnotationView alloc]
                                                   initWithAnnotation:annotation reuseIdentifier:TripAnnotationIdentifier] autorelease];
            //customPinView.pinColor = MKPinAnnotationColorPurple;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = NO;
            
            // add a detail disclosure button to the callout which will open a new view controller page
            //
            // note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
            //  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
            //
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self
                            action:@selector(showDetails:)
                  forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = rightButton;
            
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    } else if ([annotation isKindOfClass:[ChargeAnnotation class]]) 
    {
        // try to dequeue an existing pin view first
        static NSString* ChargeAnnotationIdentifier = @"chargeAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        [map dequeueReusableAnnotationViewWithIdentifier:ChargeAnnotationIdentifier];
        if (!pinView)
        {
            
            MKAnnotationView *annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                             reuseIdentifier:ChargeAnnotationIdentifier] autorelease];
            annotationView.canShowCallout = YES;
            
            UIImage *chargeImage = [UIImage imageNamed:@"chargeAnnotation.png"];
            
            CGRect resizeRect;
            
            resizeRect.size = chargeImage.size;
            
            resizeRect.origin = (CGPoint){0.0f, 0.0f};
            UIGraphicsBeginImageContext(resizeRect.size);
            [chargeImage drawInRect:resizeRect];
            UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            annotationView.image = resizedImage;
            annotationView.opaque = NO;
            
            return annotationView;
            
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    } else if ([annotation isKindOfClass:[DealerAnnotation class]]) 
    {
        // try to dequeue an existing pin view first
        static NSString* DealerAnnotationIdentifier = @"dealerAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        [map dequeueReusableAnnotationViewWithIdentifier:DealerAnnotationIdentifier];
        if (!pinView)
        {
            
            MKAnnotationView *annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                             reuseIdentifier:DealerAnnotationIdentifier] autorelease];
            annotationView.canShowCallout = YES;
            
            UIImage *dealerImage = [UIImage imageNamed:@"dealerAnnotation.png"];
            
            CGRect resizeRect;
            
            resizeRect.size = dealerImage.size;
            
            resizeRect.origin = (CGPoint){0.0f, 0.0f};
            UIGraphicsBeginImageContext(resizeRect.size);
            [dealerImage drawInRect:resizeRect];
            UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            annotationView.image = resizedImage;
            annotationView.opaque = NO;
            
            return annotationView;
            
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    
    return nil;
}



- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if (!crumbView)
    {
        crumbView = [[CrumbPathView alloc] initWithOverlay:overlay];
    }
    return crumbView;
}


-(void) startLocationManager
{
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    [self setMeter];
}


-(void) stopLocationManager
{
	if (self.locationManager)
	{
		[self.locationManager stopUpdatingLocation];
		self.locationManager.delegate = nil;
	}
}


- (void)viewDidUnload
{
	self.map = nil;
    
    self.containerView = nil;
	
    [super viewDidUnload];
}


- (void)dealloc
{
    [crumbView release];
    [crumbs release];
    
    [containerView release];
    [map release];
    
	
	[resultsView release];
	
    [super dealloc];
}

@end
