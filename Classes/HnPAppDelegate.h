//
//  HnPAppDelegate.h
//  HnP
//
//  Created by Divyanshu Arora on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HnPViewController;

@interface HnPAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    HnPViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet HnPViewController *viewController;

@end

