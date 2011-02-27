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
	CGPoint velocity;
	CGFloat trajAngle;
	NSTimer* time;
}

@property CGPoint velocity;
@property CGFloat trajAngle;
@property (retain) NSTimer* time;

- (id)initWithFrame:(CGRect)f Angle:(CGFloat)a Number:(int)n Velocity:(CGPoint)v trajectoryAngle:(CGFloat)ta;
- (void)removeSelf;

@end
