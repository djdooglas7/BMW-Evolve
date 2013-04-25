//
//  Coord.h
//  BMWE3
//
//  Created by Doug Strittmatter on 11/2/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import "Coord.h"

@implementation Coord 

@dynamic longitude, latitude;

- (CLLocationCoordinate2D)coordinate
{
    coordinate.latitude = [self.latitude doubleValue];
    coordinate.longitude = [self.longitude doubleValue];
    return coordinate;
}

@end
