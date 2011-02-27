//
//  GameObject.h
//  HnP
//
//  Created by Divyanshu Arora on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "GameObjectDelegate.h"

#define d2r(x) (M_PI * x / 180.0)

/*
 * @file
 * This class is not meant to be instantiated directly since it cannot be rendered by the global controller.
 * Use one of its subclasses instead.
 */

//Default positions on the pallette.
#define pigDefault CGRectMake(300, 0, 60, 60)
#define wolfDefault CGRectMake(0, 0, 90, 60)
#define blockDefault CGRectMake(175, 0, 60, 60)

typedef enum { fresh, stale, gg} quality;
//These are used to mark objects in the innards physics engine. They can later be used in the main loop of the engine to modify the world state.

@interface GameObject : UIViewController <NSCoding> {
	CGSize size;
	CGFloat angle;
	CGFloat scale;
	CGPoint center;
	int number;
	GameObjectDelegate* deleg;
	quality state;
	//Quality is not saved into the archive-its a runtime thing only, while save only stores level design.
}

@property quality state;
@property CGPoint center;
@property CGSize size;
@property CGFloat angle;
@property CGFloat scale;
@property int number;
@property (assign) GameObjectDelegate* deleg;

- (id)initWithFrame:(CGRect)f Angle:(CGFloat)a Number:(int)n;
//REQUIRES: CGRect specifying the frame position & size, rotation angle in radians, tag number
//MODIFIES:
//RETURNS: New GameObject.

- (void)addGestures;
//REQUIRES: -
//MODIFIES: self.view, adding gesture recognizers
//RETURNS: -

- (void)setViewProps;
//REQUIRES: -
//MODIFIES: Sets view properties based on the model stored in this class, specifies the frame
//RETURNS: 

- (void)updateView;
//REQUIRES: 
//MODIFIES: Updates view properties based on model stored in this class; no longer uses frame, updates center instead
//RETURNS: 
- (void)restoreToPalette;
//REQUIRES: -
//MODIFIES: Emits restoreToPalette NSNotification, which is handled by the global controller so that it can modify the superviews accordingly
//RETURNS: 

- (void)rotate:(UIGestureRecognizer *)gesture;
//REQUIRES: UIGestureRecognizer Sent by a gesture recognizer bound to a view
//MODIFIES: self.angle, self.view.transform
//RETURNS: -

- (void)zoom:(UIGestureRecognizer *)gesture;
//REQUIRES: Same as last fn
//MODIFIES: self.scale, self.view.transform
//RETURNS: -

- (void)doubleTap:(UIGestureRecognizer *)gesture;
//REQUIRES: same as last gn
//MODIFIES: Emits objectDidGetDoubleTapped NSNotification. Handled by global controller, which removes the object, replacing it in the palette if necessary
//RETURNS: -

- (void)translate:(UIGestureRecognizer *)gesture;
//REQUIRES: Same as last fn
//MODIFIES: self.scale, self.view.transform
//RETURNS: -

+ (NSMutableArray*)splitImage:(CGImageRef)img xSplits:(int)x ySplits:(int)y;
//REQUIRES: A CGImageRef which contains a tiled image specifying an animation sequence, and 'x', 'y' number of tiles in the horizontal & vertical directions
//MODIFIES: -
//RETURNS: An NSArray of UIImages containing the individual slices of the tile


//Methods that implement the NSCoding protocol. Save the state of this class' model-center, size, angle, scale, number
- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;
@end
