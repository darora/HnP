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
@synthesize objCounter;
@synthesize objects;
@synthesize pObjects;
@synthesize wObjects;
@synthesize phy;
@synthesize save;
@synthesize load;
@synthesize nameField;

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



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
	
	objCounter = 0;
	self.objects = [NSMutableArray arrayWithCapacity:5];
	self.pObjects = [NSMutableArray arrayWithCapacity:3];
	self.wObjects = [NSMutableArray arrayWithCapacity:4];
	
	[self initializeViews];
	[self initializePalette];
	[self initializeListeners];
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
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

- (void)addToGameArea:(GameObject*)o {
	BOOL present = NO;
	int x = [o number];
	for (int i=0; i<[self.objects count]; i++)
		if (x == [[self.objects objectAtIndex:i] number])
			present = YES;
	if (!present)
	{
		[self.objects addObject:o];
	}
	[gameArea addSubview:o.view];
}

- (void)removeFromGameArea:(GameObject*)o {
	for (int i=0; i<[self.objects count]; i++) {
		GameObject* tmp = [self.objects objectAtIndex:i];
		if (o.number == [tmp number]) {
			[tmp.view removeFromSuperview];
			[self.objects removeObjectAtIndex:i];
			[tmp release];
			return;
		}
	}
}

- (void)initializeViews {
	//TODO: Disable iOS toolbar
	CGRect tmp = CGRectMake(0, 0, 1024, PALETTE_HEIGHT);
	
	//This provides a translucent background for the palette
	UIView* tmp_view = [[UIView alloc] initWithFrame:tmp];
	tmp_view.backgroundColor = [UIColor grayColor];
	tmp_view.alpha = 0.6;
	[self.view addSubview:tmp_view];
	[tmp_view release];
	
	
	gameArea = [[UIScrollView alloc] initWithFrame:CGRectMake(0, PALETTE_HEIGHT, 1024, 768 - PALETTE_HEIGHT)];
	
	UIImage* bg = [UIImage imageNamed:@"background.png"];
	UIImage* grnd = [UIImage imageNamed:@"ground.png"];
	
	UIImageView* bgView = [[UIImageView alloc] initWithImage:bg];
	bgView.frame = CGRectMake(0, 0, SCROLL_WIDTH, 768 - PALETTE_HEIGHT - GROUND_HEIGHT);
	
	UIImageView* grndView = [[UIImageView alloc] initWithImage:grnd];
	grndView.frame = CGRectMake(0, 768 - PALETTE_HEIGHT - GROUND_HEIGHT, SCROLL_WIDTH, GROUND_HEIGHT);
	
	[gameArea addSubview:bgView];
	[gameArea addSubview:grndView];
	[gameArea setContentSize:CGSizeMake(SCROLL_WIDTH, 768-PALETTE_HEIGHT)];
	[self.view addSubview:gameArea];
	[gameArea release];
	
	palette = [[UIView alloc] initWithFrame:tmp];
	palette.backgroundColor = [UIColor clearColor];
	[self.view addSubview:palette];
	[palette release];
	
	
	[bgView release];
	[grndView release];
	
	
	//Buttons
	UIToolbar* tb = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 728, 1024, 40)];
	[self.view addSubview:tb];
	[tb release];
	self.save = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	save.frame = CGRectMake(50, 5, 80, 30);
	[save setTitle:@"Save" forState:UIControlStateNormal];
	[save addTarget:self action:@selector(saveButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[tb addSubview:save];
	//[save release];
	
	self.load = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	load.frame = CGRectMake(150, 5, 80, 30);
	[load setTitle:@"Load" forState:UIControlStateNormal];
	[load addTarget:self action:@selector(loadButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[tb addSubview:load];
	//[load release];
	
	UIButton* reset = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	reset.frame = CGRectMake(894, 5, 80, 30);
	[reset setTitle:@"Reset" forState:UIControlStateNormal];
	[reset addTarget:self action:@selector(resetButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[tb addSubview:reset];
	//[reset release];
	
	UIButton* start = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	start.frame = CGRectMake(470, 5, 80, 30);
	[start setTitle:@"Start" forState:UIControlStateNormal];
	[start addTarget:self action:@selector(startButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[tb addSubview:start];
	//[start release];
	
}

- (void)initializePalette {
	GamePig* pig = [[GamePig alloc] initWithFrame:pigDefault Angle:d2r(0) Number:objCounter++];
	GameBlock* block = [[GameBlock alloc] initWithFrame:blockDefault Angle:d2r(0) Number:objCounter++];
	GameWolf* wolf = [[GameWolf alloc] initWithFrame:wolfDefault Angle:d2r(0) Number:objCounter++];
	[pObjects addObject:pig];
	[pObjects addObject:block];
	[pObjects addObject:wolf];
	[palette addSubview:pig.view];
	[palette addSubview:wolf.view];
	[palette addSubview:block.view];
}

- (void)initializeListeners {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTranslation:) name:@"objectDidTranslate" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSingleTap:) name:@"wolfWasTapped" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDoubleTap:) name:@"objectDidGetDoubleTapped" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePaletteReturn:) name:@"restoreToPalette" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadFileSelected:) name:@"fileNameChosen" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePigCollision:) name:@"pigCollided" object:nil];
}

- (void)handleTranslation:(NSNotification*)n {
	GameObject* o = [n object];
	if ([o.view isDescendantOfView:self.palette]) {
		//TODO:add to game area & replace in palette if required
		int i = [self.pObjects indexOfObject:o];
		o.center = CGPointMake(o.center.x , o.center.y - PALETTE_HEIGHT);
		o.scale = 2.0;
		[o updateView];
		[self addToGameArea:o];
		if ([o class] == [GameBlock class]) {
			GameBlock* blk = [[GameBlock alloc] initWithFrame:blockDefault Angle:d2r(0) Number:objCounter++];
			[palette addSubview:blk.view];
			[pObjects replaceObjectAtIndex:i withObject:blk];
		}
	}	
}

- (void)handleDoubleTap:(NSNotification*)n {
	GameObject* o = [n object];
	if ([o.view isDescendantOfView:palette])
		return;	//Maybe a UIAlert??
	if ([o class] == [GameBlock class]) {
		//Just remove from UI models
		[self removeFromGameArea:o];
	}
	else {
		//Its a pig or wolf. Return to palette
		[o restoreToPalette];
	}

	
}

- (void)handleSingleTap:(NSNotification*)n {
	GameBlock* o = [n object];
	//Breath for wolf
	if ([o class] == [GameWolf class]) {
		GameWolf* wolf = (GameWolf*)o;
		
		if ([wObjects count] > 0) {
			while ([wObjects count] > 0) {
				[[wObjects objectAtIndex:0] removeFromSuperview];
				[wObjects removeObjectAtIndex:0];
			}
			return;
		}
		UIImage* dir = [UIImage imageNamed:@"direction-degree.png"];
		UIImageView* prj = [[UIImageView alloc] initWithImage:dir];
		CGPoint cen = wolf.view.center;//Don't care about scaling
		prj.frame = CGRectMake((cen.x+wolf.view.frame.size.width/3), (cen.y-wolf.view.frame.size.height/2-272/2), 155, 272);
		//prj.layer.anchorPoint = CGPointMake(0, 0.5);
		prj.transform = CGAffineTransformRotate(CGAffineTransformIdentity, wolf.angle);
		[gameArea addSubview:prj];
		[wObjects addObject:prj];
		
		//Arrow
		dir = [UIImage imageNamed:@"direction-arrow.png"];
		UIImageView* arr = [[UIImageView alloc] initWithImage:dir];
		cen = wolf.view.center;//Don't care about scaling
		arr.frame = CGRectMake(prj.center.x-74, prj.center.y-430/2, 74, 430);
		//arr.layer.anchorPoint = CGPointMake(0.5, 1);
		arr.transform = CGAffineTransformRotate(CGAffineTransformIdentity, d2r(90));
		[gameArea addSubview:arr];
		[wObjects addObject:arr];
		arr.userInteractionEnabled = YES;
		UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(translateAim:)];
		[arr addGestureRecognizer:panGestureRecognizer];
		[panGestureRecognizer release];
	}	
}


- (void)translateAim:(UIGestureRecognizer *)gesture {
	// MODIFIES: object model (coordinates)
	// REQUIRES: game in designer mode
	// EFFECTS: the user drags around the object with one finger
	//          if the object is in the palette, it will be moved in the game area & scaled up
	UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *) gesture;
	if (panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStateChanged) {
		//UIView *view = panGesture.view;
		CGPoint translation = [panGesture translationInView:panGesture.view];
		double angle = atan2(translation.y, translation.x);
		NSLog(@"%lf", angle);
		panGesture.view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, angle+d2r(90));
		[panGesture setTranslation:CGPointZero inView:panGesture.view];
		
	}
	if (panGesture.state == UIGestureRecognizerStateEnded) {
		[panGesture setTranslation:CGPointZero inView:panGesture.view];
	}
}


- (void)handlePaletteReturn:(NSNotification*)n {
	GameObject* o = [n object];
	
	if ([o.view isDescendantOfView:gameArea]) {
		[o retain];
		[self removeFromGameArea:o];
		[self.pObjects addObject:o];
		[palette addSubview:o.view];
	}
	
	CGPoint tmp;
	if ([o class] == [GamePig class])
		tmp = CGPointMake(pigDefault.origin.x + pigDefault.size.width/2, pigDefault.origin.y + pigDefault.size.height/2);
	else if ([o class] == [GameWolf class])
		tmp = CGPointMake(wolfDefault.origin.x + wolfDefault.size.width/2, wolfDefault.origin.y + wolfDefault.size.height/2);
	o.center = tmp;
	o.angle = d2r(0);
	o.scale = 1;
	[o updateView];
}

- (void)resetScreen {
	while ([objects count] > 0) {
		[self removeFromGameArea:[objects objectAtIndex:0]];
	}
	while ([pObjects count] > 0) {
		GameObject* o = [pObjects objectAtIndex:0];
		[o.view removeFromSuperview];
		[pObjects removeObjectAtIndex:0];
	}
	while ([wObjects count] > 0) {
		if ([[wObjects objectAtIndex:0] isKindOfClass:[UIView class]])
			[[wObjects objectAtIndex:0] removeFromSuperview];
		else {
			GameObject* o = [wObjects objectAtIndex:0];
			[o.view removeFromSuperview];
		}
		[wObjects removeObjectAtIndex:0];
	}//TODO FIX reset crash
	//for (UIView* e in gameArea.subviews) {
//		if (e != gameArea)
//			[e removeFromSuperview];
//	}
	
	[self initializePalette];
}

- (void)saveButtonPressed {
	//UIViewController* tmp = [[UIViewController alloc] init
//	if (_colorPicker == nil) {
//        self.colorPicker = [[[ColorPickerController alloc] 
//							 initWithStyle:UITableViewStylePlain] autorelease];
//        _colorPicker.delegate = self;
//        self.colorPickerPopover = [[[UIPopoverController alloc]
//									initWithContentViewController:_colorPicker] autorelease];
//    }
//    [self.colorPickerPopover presentPopoverFromBarButtonItem:sender
//									permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	UIAlertView* dialog = [[UIAlertView alloc] init];
	[dialog setDelegate:self];
	[dialog setTitle:@"Enter File Name"];
	[dialog setMessage:@" "];
	[dialog addButtonWithTitle:@"Cancel"];
	[dialog addButtonWithTitle:@"OK"];
	
	nameField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 30.0, 245.0, 25.0)];
	[nameField setBackgroundColor:[UIColor whiteColor]];
	[dialog addSubview:nameField];
	//[dialog setTransform: moveUp];
	[dialog show];
	[dialog release];
	[nameField release];
}

- (void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString* inputText = [nameField text];
	NSLog(@"%@ %d", inputText, buttonIndex);
	if (buttonIndex == 1) {
		NSMutableData *data = [[NSMutableData alloc] init];
		NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
		[archiver encodeRootObject:self.objects];
		[archiver finishEncoding];
		NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *plistPath = [rootPath stringByAppendingPathComponent:inputText];
		[data writeToFile:plistPath atomically:YES];
		[archiver release];
		[data release];
	}
	else
		return;//Cancel
}

- (void)loadButtonPressed {
	table = [[HPSavedGames alloc] 
							 initWithStyle:UITableViewStylePlain];
	pop = [[UIPopoverController alloc] 
									initWithContentViewController:table];
	[pop presentPopoverFromRect:load.frame inView:load.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)loadFileSelected:(NSNotification*)n {
	NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:[n object]];
	NSData *data = [NSData dataWithContentsOfFile:plistPath];
	NSKeyedUnarchiver *ua = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	if (data != NULL) {
		[self resetScreen];
		while ([pObjects count] > 0) {
			GameObject* o = [pObjects objectAtIndex:0];
			[o.view removeFromSuperview];
			[pObjects removeObjectAtIndex:0];
		}
		BOOL bwolf = YES, bpig = YES;
		self.objects = [ua decodeObject];
		for (int i=0; i < [self.objects count]; i++) {
			GameObject* tmp = [self.objects objectAtIndex:i];
			[self addToGameArea:tmp];
			[tmp updateView];
			if ([tmp class] == [GameWolf class])
				bwolf = NO;
			else if ([tmp class] == [GamePig class])
				bpig = NO;
		}
		GameBlock* block = [[GameBlock alloc] initWithFrame:blockDefault Angle:d2r(0) Number:objCounter++];
		[palette addSubview:block.view];
		[pObjects addObject:block];
		
		if (bpig) {
			GamePig* pig = [[GamePig alloc] initWithFrame:pigDefault Angle:d2r(0) Number:objCounter++];
			[pObjects addObject:pig];
			[palette addSubview:pig.view];
		}
		if (bwolf) {
			GameWolf* wolf = [[GameWolf alloc] initWithFrame:wolfDefault Angle:d2r(0) Number:objCounter++];
			[pObjects addObject:wolf];
			[palette addSubview:wolf.view];
		}
	}
	[data release];
    [pop dismissPopoverAnimated:YES];
	[table release];
	[pop release];
}

- (void)resetButtonPressed {
	if (self.phy) {
		[self.phy.tickTimer invalidate];
		[self.phy release];
	}
	[self resetScreen];
}

- (void)startButtonPressed {
	GameWolf* wolf;
	for (int i=0; i < [objects count]; i++) {
		GameObject* o = [objects objectAtIndex:i];
		[[o view] setUserInteractionEnabled:NO];
		if ([o class] == [GameWolf class])
			wolf = (GameWolf*)o;
	}
	for (int i=0; i < [pObjects count]; i++) {
		[[[pObjects objectAtIndex:i] view] setUserInteractionEnabled:NO];
	}
	//Add gameBreath
	
	GameBreath* b = [[GameBreath alloc] initWithFrame:CGRectMake((wolf.center.x+wolf.view.frame.size.width/2), (wolf.center.y-wolf.view.frame.size.height/2), 112, 104) 
												Angle:0 Number:objCounter++ Velocity:50 trajectoryAngle:d2r(50)];
	[self addToGameArea:b];
	[wolf animate];
	phy = [[PhysicsWorldController alloc] initWithObjectsArray:self.objects];
}

- (void)handlePigCollision:(NSNotification*)n {
	//Hurray
	//	b2Body* tmp = (b2Body*);
	GamePig* pig = [n object];//(GamePig*)tmp->GetUserData();
	[self removeFromGameArea:pig];
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 800, 500)];
	label.text = @"The little piggy is dead! :D\n Wolf wins";
	label.textColor = [UIColor redColor];
	label.shadowColor = [UIColor yellowColor];
	label.backgroundColor = [UIColor clearColor];
	label.shadowOffset = CGSizeMake(1,1);
	label.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size: 36.0];
	label.textAlignment = UITextAlignmentCenter;
	[gameArea addSubview:label];
	[wObjects addObject:label];
	//Reset & load next level
}




@end
