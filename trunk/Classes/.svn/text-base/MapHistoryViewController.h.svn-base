//
//  MapHistoryViewController.h
//  BMWE3
//
//  Created by Doug Strittmatter on 12/17/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <AVFoundation/AVFoundation.h>

#import "CrumbPath.h"
#import "CrumbPathView.h"
#import "GDataXMLNode.h"

@interface MapHistoryViewController : UIViewController <MKMapViewDelegate, MKReverseGeocoderDelegate> {

	MKMapView *map;
	MKPlacemark *mPlacemark;
    
    CrumbPath *crumbs;
    CrumbPathView *crumbView;
	
	NSSet *setTripSegments;
}

@property (nonatomic, retain) IBOutlet MKMapView *map;

-(void) backPressed:(id)sender;
-(void) tipsPressed:(id)sender;

@end
