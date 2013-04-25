//
//  MapHistoryViewController.m
//  BMWE3
//
//  Created by Doug Strittmatter on 12/17/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import "MapHistoryViewController.h"
#import "BMWE3AppDelegate.h"
#import "SettingsViewController.h"
#import "DataManager.h"
#import "ParkPlaceMark.h"
#import "ChargeAnnotation.h"
#import "DealerAnnotation.h"


@implementation MapHistoryViewController

@synthesize map;

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
    
    CLLocationCoordinate2D coord = {38.0f, -95.0f};
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 2000000, 2000000);
	[map setRegion:region animated:FALSE];
	
	crumbs = nil;
	NSMutableArray *arrCoords = [[DataManager sharedManager] retrieveCoordHistory];
	//NSMutableArray *arrCoords = [[DataManager sharedManager] retrieveCoordItems];
	for (Coord *info in arrCoords) 
	{
		//NSLog(@"CrumbPath latitude: %@", info.latitude);
		//NSLog(@"CrumbPath longitude: %@", info.longitude);
		[self initMap:info];
	}
    
    [self loadChargeStations];
    //[self loadDealers];
}


-(void) initMap:(Coord *)coord
{
	//MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord.coordinate, 2000, 2000);
	MKCoordinateRegion region;
	region.center=coord.coordinate;
	//Set Zoom level using Span
	MKCoordinateSpan span;
	span.latitudeDelta = .1;
	span.longitudeDelta = .1;
	region.span=span;
	
	[map setRegion:region animated:YES];
	[map regionThatFits:region];
	
	ParkPlaceMark *placemark=[[ParkPlaceMark alloc] initWithCoordinate:coord.coordinate];
	[map addAnnotation:placemark];
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if (!crumbView)
    {
        crumbView = [[CrumbPathView alloc] initWithOverlay:overlay];
    }
    return crumbView;
}


-(void) backPressed:(id)sender
{
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	[applicationDelegate displayDiveView];
}


-(void) tipsPressed:(id)sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.BMWActivateTheFuture.com/"]];
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


- (void)dealloc 
{
	[crumbView release];
    [crumbs release];
    [map release];
	
    [super dealloc];
}


@end
