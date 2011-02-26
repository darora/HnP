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
	CGFloat velocity;
	CGFloat trajAngle;
}

@property CGFloat velocity;
@property CGFloat trajAngle;

- (id)initWithFrame:(CGRect)f Angle:(CGFloat)a Number:(int)n Velocity:(CGFloat)v trajectoryAngle:(CGFloat)ta;

@end
