//
//  MD5Hash.m
//  BMWE3
//
//  Created by Doug Strittmatter on 2/25/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import "MD5Hash.h"


@implementation MD5Hash

//generate md5 hash from string
+ (NSString *) returnMD5Hash:(NSString*)concat {
    const char *concat_str = [concat UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concat_str, strlen(concat_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
	
}


@end
