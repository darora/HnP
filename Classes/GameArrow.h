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
- (void)translateAim:(UIGestureRecognizer *)gesture;
@end
