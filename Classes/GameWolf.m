//
//  GameWolf.m
//  HnP
//
//  Created by Divyanshu Arora on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameWolf.h"


@implementation GameWolf

@synthesize lives;

- (id)initWithFrame:(CGRect)f Angle:(CGFloat)a Number:(int)n {
	if (self = [super initWithFrame:f Angle:a Number:n]) {
		lives = 3;
		UIImage *bgImage = [UIImage imageNamed:@"wolf-cropped.png"];
		self.view = [[[UIImageView alloc] initWithImage:bgImage] autorelease];
		[self addGestures];
		[self setViewProps];
	}
	else {
		self = nil;
	}
	return self;
}

- (void)addGestures {
	//Binds the 3 gestures recognizers (pinch, rotate, pan) to the views created
	//MODIFIES: self.view: Adds gesture recognizers
	
	[self.view setUserInteractionEnabled:YES];
	[self.view setMultipleTouchEnabled:YES];
	[self.view setContentMode:UIViewContentModeScaleAspectFit];
	
	GameObjectDelegate* deleg = [[GameObjectDelegate alloc] init];
	
	//Double Tap Gesture
	UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
	[doubleTapGestureRecognizer setDelegate:deleg];
	[doubleTapGestureRecognizer setNumberOfTapsRequired:2];
	[self.view addGestureRecognizer:doubleTapGestureRecognizer];
	[doubleTapGestureRecognizer release];
	
	//Pan Gesture
	UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(translate:)];
	[panGestureRecognizer setDelegate:deleg];
	[self.view addGestureRecognizer:panGestureRecognizer];
	[panGestureRecognizer release];
	
	//Rotate Gesture
	UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
	[rotationGestureRecognizer setDelegate:deleg];
	[self.view addGestureRecognizer:rotationGestureRecognizer];
	[rotationGestureRecognizer release];
	
	//Pinch Gesture
	UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoom:)];
	[pinchGestureRecognizer setDelegate:deleg];
	[self.view addGestureRecognizer:pinchGestureRecognizer];
	[pinchGestureRecognizer release];
	
	//Tap Gesture
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
	[tapGestureRecognizer setDelegate:deleg];
	[tapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
	[self.view addGestureRecognizer:tapGestureRecognizer];
	[tapGestureRecognizer release];
}

- (void)tap:(UIGestureRecognizer *)gesture {
	// MODIFIES: object's obstacle type
	// REQUIRES: game in designer mode
	// EFFECTS: Cycles through the available obstacle types
	UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *) gesture;
	if (tapGesture.state == UIGestureRecognizerStateEnded) {
		[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"wolfWasTapped" object:self]];
	}
}

@end
