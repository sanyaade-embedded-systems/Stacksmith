//
//  UKPropagandaWindowBodyView.m
//  Propaganda
//
//  Created by Uli Kusterer on 21.03.10.
//  Copyright 2010 The Void Software. All rights reserved.
//

#import "UKPropagandaWindowBodyView.h"
#import "UKPropagandaStack.h"
#import "UKPropagandaCard.h"
#import "UKPropagandaNotifications.h"
#import "UKPropagandaScriptEditorWindowController.h"
#import "UKPropagandaSelectionView.h"


@implementation UKPropagandaWindowBodyView

-(id)	initWithFrame: (NSRect)frameRect
{
	if(( self = [super initWithFrame: frameRect] ))
	{
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(peekingStateChanged:)
												name: UKPropagandaPeekingStateChangedNotification
												object: nil];
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(backgroundEditModeChanged:)
												name: UKPropagandaBackgroundEditModeChangedNotification
												object: nil];
	}
	
	return self;
}


-(id)	initWithCoder: (NSCoder *)aDecoder
{
	if(( self = [super initWithCoder: aDecoder] ))
	{
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(peekingStateChanged:)
												name: UKPropagandaPeekingStateChangedNotification
												object: nil];
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(backgroundEditModeChanged:)
												name: UKPropagandaBackgroundEditModeChangedNotification
												object: nil];
	}
	
	return self;
}


-(void)	dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver: self
											name: UKPropagandaPeekingStateChangedNotification
											object: nil];
	[[NSNotificationCenter defaultCenter] removeObserver: self
											name: UKPropagandaBackgroundEditModeChangedNotification
											object: nil];
	[super dealloc];
}


-(void)	setCard: (UKPropagandaCard*)inCard
{
	mCard = inCard;
}


-(void)	resetCursorRects
{
	if( mPeeking )
		[self addCursorRect: [self visibleRect] cursor: [NSCursor arrowCursor]];
	else
		[self addCursorRect: [self visibleRect] cursor: [[mCard stack] cursorWithID: 128]];
}


-(void)	mouseDown: (NSEvent*)event
{
	if( mPeeking )
	{
		UKPropagandaScriptEditorWindowController*	sewc = [[[UKPropagandaScriptEditorWindowController alloc] initWithScriptContainer: mBackgroundEditMode ? [mCard owningBackground] : mCard] autorelease];
		[[[[self window] windowController] document] addWindowController: sewc];
		[sewc showWindow: nil];
	}
	else if( [[UKPropagandaTools propagandaTools] currentTool] == UKPropagandaButtonTool
				|| [[UKPropagandaTools propagandaTools] currentTool] == UKPropagandaFieldTool )
	{
		[[UKPropagandaTools propagandaTools] deselectAllClients];
	}
	else
		[super mouseDown: event];
}


-(void)	peekingStateChanged: (NSNotification*)notification
{
	[[self window] invalidateCursorRectsForView: self];
	mPeeking = [[[notification userInfo] objectForKey: UKPropagandaPeekingStateKey] boolValue];
}

-(void)	backgroundEditModeChanged: (NSNotification*)notification
{
	mBackgroundEditMode = [[[notification userInfo] objectForKey: UKPropagandaBackgroundEditModeKey] boolValue];
}


@end
