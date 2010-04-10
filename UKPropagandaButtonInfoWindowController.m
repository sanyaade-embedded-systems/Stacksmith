//
//  UKPropagandaButtonInfoWindowController.m
//  Stacksmith
//
//  Created by Uli Kusterer on 03.04.10.
//  Copyright 2010 The Void Software. All rights reserved.
//

#import "UKPropagandaButtonInfoWindowController.h"
#import "UKPropagandaPart.h"
#import "UKPropagandaPartContents.h"
#import "UKPropagandaCard.h"
#import "UKPropagandaStack.h"
#import "UKPropagandaWindowBodyView.h"
#import "UKPropagandaIconListDataSource.h"
#import "UKPropagandaScriptEditorWindowController.h"


static 	NSArray*	sStylesInMenuOrder = nil;
	



@implementation UKPropagandaButtonInfoWindowController

-(id)	initWithPart: (UKPropagandaPart*)inPart ofCardView: (UKPropagandaWindowBodyView*)owningView
{
	if( !sStylesInMenuOrder )
		sStylesInMenuOrder = [[NSArray alloc] initWithObjects:
													@"transparent",
													@"opaque",
													@"rectangle",
													@"roundrect",
													@"shadow",
													@"checkbox",
													@"radiobutton",
													@"standard",
													@"default",
													@"oval",
													@"popup",
													nil];
	
	if(( self = [super initWithWindowNibName: NSStringFromClass([self class])] ))
	{
		mPart = inPart;
		mCardView = owningView;
		
		[self setShouldCascadeWindows: NO];
	}
	
	return self;
}


-(void)	dealloc
{
	mIconListController = nil;
	
	[super dealloc];
}


-(void)	windowDidLoad
{
	[super windowDidLoad];
	
	[mNameField setStringValue: [mPart name]];
	
	NSString*	layerName = [[mPart partLayer] capitalizedString];
	[mButtonNumberLabel setStringValue: [NSString stringWithFormat: @"%@ Button Number:", layerName]];
	[mButtonNumberField setIntegerValue: [mPart partNumberAmongPartsOfType: @"button"] +1];
	[mPartNumberLabel setStringValue: [NSString stringWithFormat: @"%@ Part Number:", layerName]];
	[mPartNumberField setIntegerValue: [mPart partNumber] +1];
	[mIDLabel setStringValue: [NSString stringWithFormat: @"%@ Button ID:", layerName]];
	[mIDField setIntegerValue: [mPart partID]];
	
	[mShowNameSwitch setState: [mPart showName]];
	[mAutoHighlightSwitch setState: [mPart autoHighlight]];
	[mHighlightedSwitch setState: [mPart highlighted]];
	[mEnabledSwitch setState: [mPart isEnabled]];
	[mVisibleSwitch setState: [mPart visible]];
	
	[mStylePopUp selectItemAtIndex: [sStylesInMenuOrder indexOfObject: [mPart style]]];
	[mFamilyPopUp selectItemAtIndex: [mPart family]];
	
	UKPropagandaPartContents*	theContents = nil;
	if( [mPart sharedText] )
		theContents = [[[mCardView card] owningBackground] contentsForPart: mPart];
	else
		theContents = [[mCardView card] contentsForPart: mPart];
	NSString*					contentsStr = [theContents text];
	[mContentsTextField setString: contentsStr ? contentsStr : @""];
	
	[mIconListController setStack: [mPart stack]];
	[mIconListController setSelectedIconID: [mPart iconID]];
}


-(NSString *)	windowTitleForDocumentDisplayName: (NSString *)displayName
{
	return [NSString stringWithFormat: @"%@ Info", [mPart displayName]];
}


-(IBAction)	showWindow: (id)sender
{
	NSWindow*	theWindow = [self window];
	NSRect		buttonRect = [mPart rectangle];
	buttonRect = [mCardView convertRectToBase: buttonRect];
	buttonRect.origin = [[mCardView window] convertBaseToScreen: buttonRect.origin];
	NSRect		desiredFrame = [theWindow contentRectForFrameRect: [theWindow frame]];
	[theWindow setFrame: buttonRect display: NO];
	[theWindow makeKeyAndOrderFront: self];
	desiredFrame = [theWindow frameRectForContentRect: desiredFrame];
	[theWindow setFrame: desiredFrame display: YES animate: YES];
}


-(IBAction)	doOKButton: (id)sender
{
	[mPart setName: [mNameField stringValue]];
	
	[mPart setShowName: [mShowNameSwitch state] == NSOnState];
	[mPart setAutoHighlight: [mAutoHighlightSwitch state] == NSOnState];
	[mPart setHighlighted: [mHighlightedSwitch state] == NSOnState];
	[mPart setEnabled: [mEnabledSwitch state] == NSOnState];
	[mPart setVisible: [mVisibleSwitch state] == NSOnState];
	
	[mPart setStyle: [sStylesInMenuOrder objectAtIndex: [mStylePopUp indexOfSelectedItem]]];
	[mPart setFamily: [mFamilyPopUp indexOfSelectedItem]];
	
	UKPropagandaPartContents*	theContents = nil;
	if( [mPart sharedText] )
		theContents = [[[mCardView card] owningBackground] contentsForPart: mPart];
	else
		theContents = [[mCardView card] contentsForPart: mPart];
	[theContents setText: [mContentsTextField string]];

	NSInteger	theIconID = [mIconListController selectedIconID];
	[mPart setIconID: theIconID];
	
	[[[[self window] windowController] document] updateChangeCount: NSChangeDone];
	
	[self close];
}


-(IBAction)	doCancelButton: (id)sender
{
	[self close];
}


-(IBAction)	doEditScriptButton: (id)sender
{
	UKPropagandaScriptEditorWindowController*	se = [[[UKPropagandaScriptEditorWindowController alloc] initWithScriptContainer: mPart] autorelease];
	[[[[self window] windowController] document] addWindowController: se];
	[se showWindow: self];
}

@end