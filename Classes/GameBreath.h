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
	double velocity;
	double trajAngle;
	NSTimer* time;
}

@property double velocity;
@property double trajAngle;
@property (retain) NSTimer* time;

- (id)initWithFrame:(CGRect)f Angle:(CGFloat)a Number:(int)n Velocity:(double)v trajectoryAngle:(double)ta;
- (void)removeSelf;

@end
