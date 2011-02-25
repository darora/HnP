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

- (void)animate {
	[[[self view] layer] removeAllAnimations];		
	[[[self view] layer] removeAnimationForKey:@"contents"];
	NSArray* imgs = [self splitImage:[[UIImage imageNamed:@"wolfs.png"] CGImage]];
	//[self.view setAnimationImages:imgs];
	//		[self.view setAnimationDuration:5.0];
	//		[self.view startAnimating];
	//		[imgs retain];
	//NSMutableArray* times = [NSMutableArray arrayWithCapacity:25];
//	for (int i=0; i < 25; i++) {
//		[times addObject:[NSNumber numberWithFloat:1/25*i]];
//	}
	CALayer* image = [[CALayer layer] retain];
	image.frame = wolfDefault;
	image.contents = (id)[[UIImage imageNamed:@"wolf-cropped.png"] CGImage];
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
	//		animation.calculationMode = kCAAnimationDiscrete;
	animation.duration = 100/25;
	animation.values = imgs;
	//		animation.keyTimes = times;
	[image addAnimation:animation forKey:@"contents"];
	self.view = [[UIImageView alloc] initWithFrame:wolfDefault];
	[self.view.layer addSublayer:image];
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

- (NSMutableArray*)splitImage:(CGImageRef)img
{	
    CGSize imageSize = CGSizeMake(CGImageGetWidth(img), CGImageGetHeight(img));
	
	NSMutableArray *layers = [NSMutableArray arrayWithCapacity:25];
	
	for(int x = 0;x < 5;x++) {
		for(int y = 0;y < 3;y++) {
			CGRect frame = CGRectMake((imageSize.width / 5) * x,
									  (imageSize.height / 3) * y,
									  (imageSize.width / 5),
									  (imageSize.height / 3));
			
			CALayer *layer = [CALayer layer];
			layer.frame = frame;
			CGImageRef subimage = CGImageCreateWithImageInRect(img, frame);
			//layer.contents = (id)subimage;
			//CFRelease(subimage);
			//UIImage* tmp = [UIImage imageWithCGImage:subimage];
			[layers addObject:(id)subimage];
		}
    }
    return layers; 
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
