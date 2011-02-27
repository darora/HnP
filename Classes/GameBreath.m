//
//  GameBreath.m
//  HnP
//
//  Created by Divyanshu Arora on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameBreath.h"


@implementation GameBreath

@synthesize time;
@synthesize trajAngle;
@synthesize velocity;

- (id)initWithFrame:(CGRect)f Angle:(CGFloat)a Number:(int)n Velocity:(double)v trajectoryAngle:(double)ta {
	
	if (self = [super initWithFrame:f Angle:a Number:n]) {
		self.velocity = v;
		self.trajAngle = ta;
		NSArray* imgs = [GameObject splitImage:[[UIImage imageNamed:@"windblow1.png"] CGImage] xSplits:4 ySplits:1];
		self.view = [[UIImageView alloc] initWithFrame:f];
		UIImageView* tmp = (UIImageView*)self.view;
		[tmp setAnimationImages:imgs];
		[tmp setAnimationDuration:1.5];
		[tmp setAnimationRepeatCount:5];
		[tmp startAnimating];
		self.time = [NSTimer scheduledTimerWithTimeInterval:7.5 target:self selector:@selector(removeSelf) userInfo:nil repeats:NO];
	}
	else {
		self = nil;
	}
	return self;
}

- (void)removeSelf {
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"removeBreath" object:self]];
}

- (void)dealloc {
	[self.time invalidate];
	[self.time release];
	[super dealloc];
}

@end
