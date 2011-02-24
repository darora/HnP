//
//  GameBlock.m
//  HnP
//
//  Created by Divyanshu Arora on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameBlock.h"


@implementation GameBlock

@synthesize category;

- (void)setCategory:(blockType)f {
	f = f%3;
	category = f;
}

- (CGSize)size {
	//Provide size based on current block type, rather than the view size
}

- (id)initWithFrame:(CGRect)f Angle:(CGFloat)a Number:(int)n {
	self.category = wood;	
	if (self = [super initWithFrame:f Angle:a Number:n]) {
		UIImage *bgImage = [self getUIImage];
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

- (UIImage*)getUIImage {
	//REQUIRES: category instance variable to be set to an obstacle type
	//RETURNS: A UIImage with the correct image for the set obstacle type
	UIImage* bgImage;
	switch (self.category) {
		case wood:
			bgImage = [UIImage imageNamed:@"wood.png"];
			break;
		case stone:
			bgImage = [UIImage imageNamed:@"stone.png"];
			break;
		case iron:
			bgImage = [UIImage imageNamed:@"iron.png"];
			break;
		case straw:
			bgImage = [UIImage imageNamed:@"straw.png"];
			break;
		default:
			bgImage = [UIImage imageNamed:@"straw.png"];
			break;
	}
	return bgImage;
}

- (void)changeBlockType {
	self.category = self.category + 1;
	UIImage *bg = [self getUIImage];
	UIView* sup = self.view.superview;
	[self.view removeFromSuperview];
	self.view = [[[UIImageView alloc] initWithImage:bg] autorelease];
	[self setViewProps];
	[sup addSubview:self.view];
}

- (void)tap:(UIGestureRecognizer *)gesture {
	// MODIFIES: object's obstacle type
	// REQUIRES: game in designer mode
	// EFFECTS: Cycles through the available obstacle types
	UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *) gesture;
	if (tapGesture.state == UIGestureRecognizerStateEnded) {
		[self changeBlockType];
	}
}

@end
