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
//REQUIRES: See GameObject
//MODIFIES: self.view with the image of the wolf
//RETURNS: self

- (void)animate;
//REQUIRES: -
//MODIFIES: Plays the animation sequence of the wolf blowing
//RETURNS: -

- (void)die;
//REQUIRES: -
//MODIFIES: Plays the animation sequence of the wolf dying
//RETURNS: -

@end
