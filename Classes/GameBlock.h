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
//See GameWolf's initializer's comments

- (UIImage*)getUIImage;
//REQUIRES: the instance variable category to be set
//MODIFIES: -
//RETURNS: The currect UIImage for the category set

- (void)changeBlockType;
//REQUIRES: -
//MODIFIES: Sets the category to the next one. If it ran through the sequence, it loops around again
//RETURNS: -

- (void)updateCategory;
//REQUIRES: -
//MODIFIES: Update's the UIImageView used in self.view as necessitated by self.category
//RETURNS: -


@end
