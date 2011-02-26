//
//  HPBridging.m
//  HnP
//
//  Created by Divyanshu Arora on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPBridging.h"


@implementation HPBridging

+(CGPoint*)getVerticesForN:(int)n view:(UIView*)v {
	if (n < 3)
		throw "Polygon must have more than 2 sides";
	
	int y = v.frame.size.height/2,
	x = v.frame.size.width/2;
	int r = MIN(x,y);
#ifdef TRY_DEBUG
	NSLog(@"Starting new figure\n");
#endif
	CGPoint *arr = (CGPoint*)malloc(n * sizeof(CGPoint));
	for (int i = 0; i < n; i++) {
		CGPoint tmp = CGPointMake(x + r * cos(2 * M_PI * i / n), y + r * sin(2 * M_PI * i / n));
#ifdef TRY_DEBUG
		NSLog(@"%lf, %lf", tmp.x, tmp.y);
#endif
		arr[i] = tmp;
	}
	return arr;
}

@end
