//
//  GameBlock.h
//  HnP
//
//  Created by Divyanshu Arora on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameObject.h>

typedef enum { wood, stone, iron, straw } blockType;

@interface GameBlock : GameObject {
	blockType category;
}

@property blockType category;

- (id)initWithFrame:(CGRect)f Angle:(CGFloat)a Number:(int)n;


- (UIImage*)getUIImage;
- (void)changeBlockType;
@end
