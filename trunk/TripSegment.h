//
//  TripSegment.h
//  BMWE3
//
//  Created by Doug Strittmatter on 12/9/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Trip;

@interface TripSegment : NSManagedObject {

}

@property (nonatomic, retain) NSDate *dateStart;
@property (nonatomic, retain) NSDate *dateEnd;
@property (nonatomic, retain) NSNumber *numDistance;
@property (nonatomic, retain) NSString *strType;
@property (nonatomic, retain) Trip *trip;
@property (nonatomic, retain) NSNumber *numCharge;

@end
