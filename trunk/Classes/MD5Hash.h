//
//  MD5Hash.h
//  BMWE3
//
//  Created by Doug Strittmatter on 2/25/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface MD5Hash : NSObject {
	
}

//generates md5 hash from a string
+ (NSString *) returnMD5Hash:(NSString*)concat;

@end
