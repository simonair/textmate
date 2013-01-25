#import "OFBActionsView.h"
#import <OakAppKit/OakAppKit.h>
#import <OakAppKit/NSImage Additions.h>

static NSButton* OakCreateImageButton (NSImage* image, NSSize imageSize = NSMakeSize(16, 16))
{
	NSButton* res = [NSButton new];

	// [[res cell] setBackgroundStyle:NSBackgroundStyleRaised];
	[res setButtonType:NSMomentaryChangeButton];
	[res setBezelStyle:NSSmallSquareBezelStyle];
	[res setBordered:NO];

	image = [image copy];
	[image setSize:imageSize];
	[res setImage:image];
	[res setImagePosition:NSImageOnly];

	[res setContentHuggingPriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationHorizontal];
	[res setContentHuggingPriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationVertical];

	return res;
}

static NSPopUpButton* OakCreatePopUpButton ()
{
	NSPopUpButton* res = [NSPopUpButton new];
	res.bordered  = NO;
	res.pullsDown = YES;
	return res;
}

@implementation OFBActionsView
- (id)initWithFrame:(NSRect)aRect
{
	if(self = [super initWithTopColor:[NSColor colorWithCalibratedWhite:0.915 alpha:1] bottomColor:[NSColor colorWithCalibratedWhite:0.760 alpha:1] inactiveTopColor:[NSColor colorWithCalibratedWhite:0.915 alpha:1] inactiveBottomColor:[NSColor colorWithCalibratedWhite:0.915 alpha:1]])
	{
		self.createButton       = OakCreateImageButton([NSImage imageNamed:NSImageNameAddTemplate]);
		self.actionsPopUpButton = OakCreatePopUpButton();
		self.reloadButton       = OakCreateImageButton([NSImage imageNamed:NSImageNameRefreshTemplate]);
		self.searchButton       = OakCreateImageButton([NSImage imageNamed:NSImageNameRevealFreestandingTemplate]);
		self.favoritesButton    = OakCreateImageButton([NSImage imageNamed:@"Favorites" inSameBundleAsClass:[self class]]);
		self.scmButton          = OakCreateImageButton([NSImage imageNamed:@"SmartFolder" inSameBundleAsClass:[self class]]);

		self.createButton.toolTip    = @"Create new file";
		self.reloadButton.toolTip    = @"Reload ";
		self.searchButton.toolTip    = @"";
		self.favoritesButton.toolTip = @"Show favorites";
		self.scmButton.toolTip       = @"Show source control management status";

		NSMenu* menu = [NSMenu new];
		NSMenuItem* item = [NSMenuItem new];
		item.title = @"";
		item.image = [NSImage imageNamed:NSImageNameActionTemplate];
		[menu addItem:item];
		[menu addItemWithTitle:@"Create Folder" action:@selector(nop:) keyEquivalent:@""];
		self.actionsPopUpButton.menu = menu;

		NSDictionary* views = @{
			@"create"    : self.createButton,
			@"actions"   : self.actionsPopUpButton,
			@"reload"    : self.reloadButton,
			@"search"    : self.searchButton,
			@"favorites" : self.favoritesButton,
			@"scm"       : self.scmButton,
			@"topBorder" : OakCreateHorizontalLine([NSColor colorWithCalibratedWhite:0.500 alpha:1], [NSColor colorWithCalibratedWhite:0.750 alpha:1]),
		};

		for(NSView* view in [views allValues])
		{
			[view setTranslatesAutoresizingMaskIntoConstraints:NO];
			[self addSubview:view];
		}

		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[topBorder]|"                                                                                  options:0 metrics:nil views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(24)-[create(==21)]-(2)-[actions]-(>=8)-[reload(==21,==search,==favorites,==scm)]-[search]-[favorites]-[scm]-(24)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topBorder(==1)]-(0)-[create(==21,==reload,==search,==favorites,==scm)]-(3)-|"                                                          options:0 metrics:nil views:views]];
	}
	return self;
}
@end
