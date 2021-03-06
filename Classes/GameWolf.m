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

- (void)setLives:(int)n {
	lives = n;
	if (lives <= 0)
		[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"wolfDidExpire" object:self]];
}

- (id)initWithFrame:(CGRect)f Angle:(CGFloat)a Number:(int)n {
	if (self = [super initWithFrame:f Angle:a Number:n]) {
		lives = 3;
		UIImage *bgImage = [UIImage imageNamed:@"wolf-cropped.png"];
		self.view = [[[UIImageView alloc] initWithImage:bgImage] autorelease];
		//[self animate];
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
	
	self.deleg = [[GameObjectDelegate alloc] init];
	
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

- (void)animate {
	[[[self view] layer] removeAllAnimations];		
	[[[self view] layer] removeAnimationForKey:@"contents"];
	NSArray* imgs = [GameObject splitImage:[[UIImage imageNamed:@"wolfs.png"] CGImage] xSplits:5 ySplits:3];
	UIImageView* tmp = (UIImageView*)self.view;
	[tmp setAnimationImages:imgs];
	[tmp setAnimationDuration:1.5];
	[tmp setAnimationRepeatCount:1];
	[tmp startAnimating];
}

- (void)die {
	[[[self view] layer] removeAllAnimations];		
	[[[self view] layer] removeAnimationForKey:@"contents"];
	NSArray* imgs = [GameObject splitImage:[[UIImage imageNamed:@"wolfdie.png"] CGImage] xSplits:4 ySplits:4];
	UIImageView* tmp = (UIImageView*)self.view;
	[tmp setAnimationImages:imgs];
	[tmp setAnimationDuration:3];
	[tmp setAnimationRepeatCount:1];
	[tmp startAnimating];
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

- (void)encodeWithCoder:(NSCoder *)encoder {
	//Specified by NSCoding protocol
	//MODIFIES: encoder:adds keyed entry for enum blockType
	[super encodeWithCoder:encoder];
	[encoder encodeInt:self.lives forKey:@"lives"];
} 

- (id)initWithCoder:(NSCoder *)decoder 
//Specified by NSCoding protocol
//RETURNS: New GameObject with decoded info
{
	if (self = [super initWithCoder:decoder])
		self.lives = [decoder decodeIntForKey:@"lives"];
	else self = nil;
	return self;
}

@end
