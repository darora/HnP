//
//  GameObjectDelegate.m
//  HnP
//
//  Created by Divyanshu Arora on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameObjectDelegate.h"


@implementation GameObjectDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
	return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
	if (([gestureRecognizer class] == [UITapGestureRecognizer class]) && ([otherGestureRecognizer class] != [UITapGestureRecognizer class]))
		return NO;
	if (([gestureRecognizer class] != [UITapGestureRecognizer class]) && ([otherGestureRecognizer class] == [UITapGestureRecognizer class]))
		return NO;
	if ([gestureRecognizer.view isEqual:otherGestureRecognizer.view])
		return YES;
	return NO;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
	if ([gestureRecognizer.view isEqual:touch.view])
		return YES;
	return NO;
}

@end
