#import "ChargeAnnotation.h"

@implementation ChargeAnnotation
@synthesize coordinate;

/*- (NSString *)subtitle{
	return @"Put some text here";
}*/
- (NSString *)title{
	return @"Charging Location";
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	//NSLog(@"%f,%f",c.latitude,c.longitude);
	return self;
}
@end
