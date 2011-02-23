//
//  HnPViewController.m
//  HnP
//
//  Created by Divyanshu Arora on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPViewController.h"

#define PALETTE_HEIGHT 60.0
#define SCROLL_WIDTH 1600.0
#define GROUND_HEIGHT 100.0

@implementation HPViewController

@synthesize gameArea;
@synthesize palette;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}




/*
 Custom Methods start here
 */

- (void)initializeViews {
	//TODO: Disable iOS toolbar
	CGRect tmp = CGRectMake(0, 0, 1024, PALETTE_HEIGHT);
	
	//This provides a translucent background for the palette
	UIView* tmp_view = [[UIView alloc] initWithFrame:tmp];
	tmp_view.backgroundColor = [UIColor grayColor];
	tmp_view.alpha = 0.7;
	[self.view addSubview:tmp_view];
	[tmp_view release];
	
	palette = [[UIView alloc] initWithFrame:tmp];
	palette.backgroundColor = [UIColor clearColor];
	[self.view addSubview:palette];
	
	gameArea = [[UIScrollView alloc] initWithFrame:CGRectMake(0, PALETTE_HEIGHT, 1024, 768 - PALETTE_HEIGHT)];
	
	UIImage* bg = [UIImage imageNamed:@"background.png"];
	UIImage* grnd = [UIImage imageNamed:@"ground.png"];
	
	UIImageView* bgView = [[UIView alloc] initWithImage:bg];
	bgView.frame = CGRectMake(0, 0, SCROLL_WIDTH, 768 - PALETTE_HEIGHT - GROUND_HEIGHT);
	
	UIImageView* grndView = [[UIView alloc] initWithImage:grnd];
	grndView.frame = CGRectMake(0, 768 - PALETTE_HEIGHT - GROUND_HEIGHT, SCROLL_WIDTH, GROUND_HEIGHT);
	
	[gameArea addSubview:bgView];
	[gameArea addSubview:grndView];
	[gameArea setContentSize:CGSizeMake(SCROLL_WIDTH, 768-PALETTE_HEIGHT)];
	
	[bgView release];
	[grndView release];	
}

@end
