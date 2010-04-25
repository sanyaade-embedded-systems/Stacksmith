//
//  UKPropagandaFieldInfoWindowController.m
//  Stacksmith
//
//  Created by Uli Kusterer on 03.04.10.
//  Copyright 2010 The Void Software. All rights reserved.
//

#import "UKPropagandaFieldInfoWindowController.h"
#import "UKPropagandaPart.h"
#import "UKPropagandaPartContents.h"
#import "UKPropagandaCard.h"
#import "UKPropagandaStack.h"
#import "UKPropagandaWindowBodyView.h"
#import "UKPropagandaScriptEditorWindowController.h"


static 	NSArray*	sStylesInMenuOrder = nil;
	



@implementation UKPropagandaFieldInfoWindowController

-(id)	initWithPart: (UKPropagandaPart*)inPart ofCardView: (UKPropagandaWindowBodyView*)owningView
{
	if( !sStylesInMenuOrder )
		sStylesInMenuOrder = [[NSArray alloc] initWithObjects:
													@"transparent",
													@"opaque",
													@"rectangle",
													@"roundrect",
													@"shadow",
													@"scrolling",
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
	[super dealloc];
}


-(void)	windowDidLoad
{
	[super windowDidLoad];
	
	[mNameField setStringValue: [mPart name]];
	
	NSString*	layerName = [[mPart partLayer] capitalizedString];
	[mButtonNumberLabel setStringValue: [NSString stringWithFormat: @"%@ Field Number:", layerName]];
	[mButtonNumberField setIntegerValue: [mPart partNumberAmongPartsOfType: @"field"] +1];
	[mPartNumberLabel setStringValue: [NSString stringWithFormat: @"%@ Part Number:", layerName]];
	[mPartNumberField setIntegerValue: [mPart partNumber] +1];
	[mIDLabel setStringValue: [NSString stringWithFormat: @"%@ Field ID:", layerName]];
	[mIDField setIntegerValue: [mPart partID]];
	
	[mLockTextSwitch setState: [mPart textLocked]];
	[mDontWrapSwitch setState: [mPart dontWrap]];
	[mAutoSelectSwitch setState: [mPart autoSelect]];
	[mMultipleLinesSwitch setState: [mPart canSelectMultipleLines]];
	[mWideMarginsSwitch setState: [mPart wideMargins]];
	[mFixedLineHeightSwitch setState: [mPart fixedLineHeight]];
	[mShowLinesSwitch setState: [mPart showLines]];
	[mAutoTabSwitch setState: [mPart autoTab]];
	[mDontSearchSwitch setState: [mPart dontSearch]];
	[mSharedTextSwitch setState: [mPart sharedText]];
	[mEnabledSwitch setState: [mPart isEnabled]];
	[mVisibleSwitch setState: [mPart visible]];
	
	[mStylePopUp selectItemAtIndex: [sStylesInMenuOrder indexOfObject: [mPart style]]];
	
	UKPropagandaPartContents*	theContents = nil;
	if( [mPart sharedText] )
		theContents = [[[mCardView card] owningBackground] contentsForPart: mPart];
	else
		theContents = [[mCardView card] contentsForPart: mPart];
	NSString*					contentsStr = [theContents text];
	[mContentsTextField setString: contentsStr ? contentsStr : @""];
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
	
	[mPart setLockText: [mLockTextSwitch state] == NSOnState];
	[mPart setDontWrap: [mDontWrapSwitch state] == NSOnState];
	[mPart setAutoSelect: [mAutoSelectSwitch state] == NSOnState];
	[mPart setCanSelectMultipleLines: [mMultipleLinesSwitch state] == NSOnState];
	[mPart setWideMargins: [mWideMarginsSwitch state] == NSOnState];
	[mPart setFixedLineHeight: [mFixedLineHeightSwitch state] == NSOnState];
	[mPart setShowLines: [mShowLinesSwitch state] == NSOnState];
	[mPart setAutoTab: [mAutoTabSwitch state] == NSOnState];
	[mPart setDontSearch: [mDontSearchSwitch state] == NSOnState];
	[mPart setSharedText: [mSharedTextSwitch state] == NSOnState];
	[mPart setEnabled: [mEnabledSwitch state] == NSOnState];
	[mPart setVisible: [mVisibleSwitch state] == NSOnState];
	
	[mPart setStyle: [sStylesInMenuOrder objectAtIndex: [mStylePopUp indexOfSelectedItem]]];
	
	UKPropagandaPartContents*	theContents = nil;
	if( [mPart sharedText] )
		theContents = [[[mCardView card] owningBackground] contentsForPart: mPart];
	else
		theContents = [[mCardView card] contentsForPart: mPart];
	[theContents setText: [mContentsTextField string]];
	
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