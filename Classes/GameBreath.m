//
//  GameBreath.m
//  HnP
//
//  Created by Divyanshu Arora on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameBreath.h"


@implementation GameBreath

@synthesize trajAngle;
@synthesize velocity;

- (id)initWithFrame:(CGRect)f Angle:(CGFloat)a Number:(int)n Velocity:(CGFloat)v trajectoryAngle:(CGFloat)ta {
	
	if (self = [super initWithFrame:f Angle:a Number:n]) {
		self.velocity = v;
		self.trajAngle = ta;
		NSArray* imgs = [GameObject splitImage:[[UIImage imageNamed:@"windblow1.png"] CGImage] xSplits:4 ySplits:1];
		self.view = [[UIImageView alloc] initWithFrame:f];
		[self.view setAnimationImages:imgs];
		[self.view setAnimationDuration:1.5];
		[self.view setAnimationRepeatCount:5];
		[self.view startAnimating];
	}
	else {
		self = nil;
	}
	return self;
}


@end
