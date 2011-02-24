//
//  GamePig.m
//  HnP
//
//  Created by Divyanshu Arora on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GamePig.h"


@implementation GamePig

- (id)initWithFrame:(CGRect)f Angle:(CGFloat)a Number:(int)n {
	if (self = [super initWithFrame:f Angle:a Number:n]) {
		UIImage *bgImage = [UIImage imageNamed:@"pig.png"];
		self.view = [[[UIImageView alloc] initWithImage:bgImage] autorelease];
		[self addGestures];
		[self setViewProps];
	}
	else {
		self = nil;
	}
	return self;
}


@end
