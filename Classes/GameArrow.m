//
//  GameArrow.m
//  HnP
//
//  Created by Divyanshu Arora on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameArrow.h"


@implementation GameArrow

@synthesize dir;
@synthesize arr;
@synthesize sca;
@synthesize ang;

- (id)initWithFrame:(CGRect)f Angle:(CGFloat)a Number:(int)n Wolf:(GameObject*)wolf {
	if (self = [super initWithFrame:f Angle:a Number:n]) {
		
		UIImage* d = [UIImage imageNamed:@"direction-degree.png"];
		self.dir = [[UIImageView alloc] initWithImage:d];
		CGPoint cen = wolf.view.center;//Don't care about scaling
		dir.frame = CGRectMake(0, 0, 155, 272);
		//prj.layer.anchorPoint = CGPointMake(0, 0.5);
		dir.transform = CGAffineTransformRotate(CGAffineTransformIdentity, wolf.angle);
		//[gameArea addSubview:prj];
//		[wObjects addObject:prj];
		
		//Arrow
		d = [UIImage imageNamed:@"direction-arrow.png"];
		self.arr = [[UIImageView alloc] initWithImage:d];
		cen = wolf.view.center;//Don't care about scaling
		arr.frame = CGRectMake(0, 0, 74, 430);
		dir.center = CGPointMake(cen.x + wolf.view.frame.size.width/2, cen.y - wolf.view.frame.size.height/3);
		arr.center = CGPointMake(cen.x + wolf.view.frame.size.width/2, cen.y - wolf.view.frame.size.height/3);
		//arr.layer.anchorPoint = CGPointMake(0.5, 1);
		arr.transform = CGAffineTransformRotate(CGAffineTransformIdentity, d2r(90));
//		[gameArea addSubview:arr];
//		[wObjects addObject:arr];
		arr.userInteractionEnabled = YES;
		
		self.ang = 0;
		self.sca = 430;
		//TODO: A LOT
		
		
		
		[self addGestures];
		[self setViewProps];
	}
	else {
		self = nil;
	}
	return self;
}


- (void)addGestures {
	self.deleg = [[GameObjectDelegate alloc] init];
	UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(translateAim:)];
	[panGestureRecognizer setDelegate:deleg];
	[arr addGestureRecognizer:panGestureRecognizer];
	[panGestureRecognizer release];
}

- (void)translateAim:(UIGestureRecognizer *)gesture {
	// MODIFIES: object model (coordinates)
	// REQUIRES: game in designer mode
	// EFFECTS: the user drags around the object with one finger
	//          if the object is in the palette, it will be moved in the game area & scaled up
	
	
	UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *) gesture;
	if (panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStateChanged) {
		CGPoint translation = [panGesture translationInView:panGesture.view.superview];
		double tangle = translation.y/200;
		double tscale = (430-translation.x);
		panGesture.view.transform = CGAffineTransformRotate(panGesture.view.transform, tangle - ang);
		panGesture.view.transform = CGAffineTransformScale(panGesture.view.transform, sca/tscale, sca/tscale);
		ang = tangle;
		sca = tscale;
		//[panGesture setTranslation:CGPointZero inView:panGesture.view];
		
	}
	if (panGesture.state == UIGestureRecognizerStateEnded) {
		//[panGesture setTranslation:CGPointZero inView:panGesture.view];
	}
}


- (void)dealloc {
	[arr removeFromSuperview];
	[dir removeFromSuperview];
	[super dealloc];
}
@end
