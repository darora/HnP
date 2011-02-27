//
//  GameBreath.h
//  HnP
//
//  Created by Divyanshu Arora on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameObject.h>


@interface GameBreath : GameObject {
	double velocity;	//Used for both x & y velocities, with a scaling factor in the global controller
	double trajAngle;	//Used for y velocity
	NSTimer* time;	//Used to expire the breath in 7.5 seconds
}

@property double velocity;
@property double trajAngle;
@property (retain) NSTimer* time;

- (id)initWithFrame:(CGRect)f Angle:(CGFloat)a Number:(int)n Velocity:(double)v trajectoryAngle:(double)ta;
// Quite self-explanatory. Velocity is the magnitude only.


- (void)removeSelf;
//REQUIRES: -
//MODIFIES: Fires teh removeBreath notification, which is handled by the global controller
//RETURNS: -


@end
