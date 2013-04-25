//
//  BMWE3AppDelegate.h
//  BMWE3
//
//  Created by Doug Strittmatter on 11/2/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>


@interface Coord : NSManagedObject <MKAnnotation>
{
    NSNumber *latitude;
    NSNumber *longitude;
    
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end
