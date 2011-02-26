//
//  GameWolf.h
//  HnP
//
//  Created by Divyanshu Arora on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameObject.h>

@interface GameWolf : GameObject {
	int lives;
}

@property int lives;

- (id)initWithFrame:(CGRect)f Angle:(CGFloat)a Number:(int)n;
@end
