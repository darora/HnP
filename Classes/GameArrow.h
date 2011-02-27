//
//  GameArrow.h
//  HnP
//
//  Created by Divyanshu Arora on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameObject.h>

@interface GameArrow : GameObject {
	UIImageView* dir;
	UIImageView* arr;
	double sca;
	double ang;
}

@property (assign) UIImageView* dir;
@property (assign) UIImageView* arr;
@property double sca;
@property double ang;

- (id)initWithFrame:(CGRect)f Angle:(CGFloat)a Number:(int)n Wolf:(GameObject*)wolf;
//Self-explanatory. The wolf acts as the source of positioning info. The Frame & angle in this case is only for heirarchy purposes-you can feed it junk if you'd like.
//NOTICE: Breaking with standard, this class uses self.dir & self.arr UIImageViews, rather than the self.view UIView. Makes it easier to handle the arrow's gestures.

- (void)translateAim:(UIGestureRecognizer *)gesture;
//REQUIRES: To be called from a gesture recognizer-a pan gesture recognizer to be specific
//MODIFIES: arr.transform, based on the x & y translation.
//RETURNS: -

@end
