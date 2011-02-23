//
//  HnPViewController.h
//  HnP
//
//  Created by Divyanshu Arora on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPViewController : UIViewController {
	UIScrollView* gameArea;
	UIView* palette;
}

@property (retain) UIScrollView* gameArea;
@property (retain) UIView* palette;

- (void)initializeViews;

@end

