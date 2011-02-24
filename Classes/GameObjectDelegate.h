//
//  GameObjectDelegate.h
//  HnP
//
//  Created by Divyanshu Arora on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameObjectDelegate : NSObject <UIGestureRecognizerDelegate> {
	
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
//RETURNS: YES. Here to fulfill the UIGestureRecognizerDelegate Protocol, no other function

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
//RETURNS: YES only if both gestures pertain to the same view, and neither one is a TapGestureRecognizer.

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
//RETURNS: YES only if both gestures pertain to the same view


@end
