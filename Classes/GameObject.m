//
//  GameObject.m
//  HnP
//
//  Created by Divyanshu Arora on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"


@implementation GameObject

@synthesize center;
@synthesize size;
@synthesize angle;
@synthesize scale;
@synthesize number;

//- (void)setCenter:(CGPoint)p {
//	self.view.center = p;
//}
//- (CGPoint)center {
//	return self.view.center;
//}

- (id)initWithFrame:(CGRect)f Angle:(CGFloat)a Number:(int)n {
	//Must be maintained for easy saving/loading
	if (self = [super init]) {
		self.angle = a;
		self.size = CGSizeMake(f.size.width, f.size.height);
		self.center = CGPointMake(f.origin.x + f.size.width/2, f.origin.y + f.size.height/2);
		self.number = n;
		self.scale = 1.0;
	}
	else
		self = nil;
	return self;
}

- (void)setViewProps {
	double ox = self.center.x - self.size.width/2;
	double oy = self.center.y - self.size.height/2;
	self.view.frame = CGRectMake(ox, oy, self.size.width, self.size.height);
	self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.scale, self.scale);
	self.view.transform = CGAffineTransformRotate(self.view.transform, self.angle);
}

- (void)updateView {
	self.view.center = self.center;
	self.view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, self.angle);
	self.view.transform = CGAffineTransformScale(self.view.transform, self.scale, self.scale);
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
	
}

- (void)rotate:(UIGestureRecognizer *)gesture {
	// MODIFIES: object model (rotation)
	// REQUIRES: game in designer mode, object in game area
	// EFFECTS: the object is rotated with a two-finger rotation gesture
	UIRotationGestureRecognizer *rotateGesture = (UIRotationGestureRecognizer *) gesture;
	
	if (rotateGesture.state == UIGestureRecognizerStateBegan || rotateGesture.state == UIGestureRecognizerStateChanged) {	//WHY is this necessary? Removable?
		//UIView *view = rotateGesture.view;
		self.angle += rotateGesture.rotation;
		self.view.transform = CGAffineTransformRotate(self.view.transform, rotateGesture.rotation);
		rotateGesture.rotation = 0;
		//[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"objectDidRotate" object:self]];
		
	}
}

- (void)zoom:(UIGestureRecognizer *)gesture {
	// MODIFIES: object model (size)
	// REQUIRES: game in designer mode, object in game area
	// EFFECTS: the object is scaled up/down with a pinch gesture
	UIPinchGestureRecognizer *pinchGesture = (UIPinchGestureRecognizer *) gesture;
	
	if (pinchGesture.state == UIGestureRecognizerStateBegan || pinchGesture.state == UIGestureRecognizerStateChanged) {
		
		//UIView *view = pinchGesture.view;
		self.scale *= pinchGesture.scale;
		self.view.transform = CGAffineTransformScale(self.view.transform, pinchGesture.scale, pinchGesture.scale);
		pinchGesture.scale = 1;
		//[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"objectDidScale" object:self]];
	}
}

- (void)doubleTap:(UIGestureRecognizer *)gesture {
	// MODIFIES: object's existance
	// REQUIRES: game in designer mode, object in game area
	// EFFECTS: the object is removed from gamearea.
	UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *) gesture;
	if (tapGesture.state == UIGestureRecognizerStateEnded) {
		[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"objectDidGetDoubleTapped" object:self]];
	}
}

- (void)translate:(UIGestureRecognizer *)gesture {
	// MODIFIES: object model (coordinates)
	// REQUIRES: game in designer mode
	// EFFECTS: the user drags around the object with one finger
	//          if the object is in the palette, it will be moved in the game area & scaled up
	UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *) gesture;
	if (panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStateChanged) {
		//UIView *view = panGesture.view;
		CGPoint translation = [panGesture translationInView:self.view.superview];
		[self setCenter:CGPointMake(self.center.x + translation.x, self.center.y + translation.y)];
		[self updateView];
		[panGesture setTranslation:CGPointZero inView:self.view.superview];
		
	}
	if (panGesture.state == UIGestureRecognizerStateEnded) {
		[panGesture setTranslation:CGPointZero inView:panGesture.view.superview];
		if ((self.view.frame.origin.y + self.view.frame.size.height) > 60)
		{
			[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"objectDidTranslate" object:self]];
			//if ([self.img isDescendantOfView:controller.pallette]) {
//				self.img.frame = [self.img.superview convertRect:self.img.frame toView:controller.gamearea];
//				self.img.frame = CGRectMake(self.img.frame.origin.x, self.img.frame.origin.y, 200, 250);
//				[controller addToView:controller.gamearea GameObject:self];
//			}
		}
		else {
			[self restoreToPalette];
		}
	}
}

- (void)restoreToPalette {
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"restoreToPalette" object:self]];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	//Specified by NSCoding protocol
	//MODIFIES: encoder:adds keyed entries for CGSize size, CGPoint center, doubles angle & scale, int number
	[encoder encodeCGSize:self.size forKey:@"size"];
	[encoder encodeCGPoint:self.center forKey:@"center"];
	[encoder encodeDouble:self.angle forKey:@"angle"];
	[encoder encodeDouble:self.scale forKey:@"scale"];
	[encoder encodeInt:self.number forKey:@"number"];
} 

- (id)initWithCoder:(NSCoder *)decoder 
	//Specified by NSCoding protocol
	//RETURNS: New GameObject with decoded info
{
	CGSize sz = [decoder decodeCGSizeForKey:@"size"];
	CGPoint cen = [decoder decodeCGPointForKey:@"center"];
	double ang = [decoder decodeDoubleForKey:@"angle"];
	double sca = [decoder decodeDoubleForKey:@"scale"];
	int num = [decoder decodeIntForKey:@"number"];
	CGRect tmp = CGRectMake(cen.x - sz.width/2, cen.y - sz.height/2, sz.width, sz.height);
	if ([self initWithFrame:tmp Angle:ang Number:num]) {
		self.scale = sca;
	}
	else self = nil;
	return self; 
}

+ (NSMutableArray*)splitImage:(CGImageRef)img xSplits:(int)x ySplits:(int)y
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


@end
