//
//  WILDMoviePlayerInfoViewController.m
//  Stacksmith
//
//  Created by Uli Kusterer on 31.07.11.
//  Copyright 2011 Uli Kusterer. All rights reserved.
//

#import "WILDMoviePlayerInfoViewController.h"
#import "WILDNotifications.h"
#import <QTKit/QTKit.h>
#import "UKHelperMacros.h"


@implementation WILDMoviePlayerInfoViewController

@synthesize moviePathField = mMoviePathField;

-(void)	dealloc
{
	DESTROY(mMoviePathField);
	
	[super dealloc];
}


-(void)	loadView
{
	[super loadView];
	
	[mMoviePathField setStringValue: [part mediaPath]];
}


-(IBAction)	doChooseMovieFile: (id)sender
{
	NSOpenPanel	*	thePanel = [NSOpenPanel openPanel];
	NSArray		*	types = [QTMovie movieFileTypes: QTIncludeCommonTypes];
	[thePanel setAllowedFileTypes: types];
	if( NSFileHandlingPanelOKButton == [thePanel runModal] )
	{
		[[self retain] autorelease];	// Make sure we're not released if the movie player property change recreates its view.

		NSString	*	thePath = [thePanel filename];
		NSDictionary*	infoDict = [NSDictionary dictionaryWithObjectsAndKeys:
										@"moviePath", WILDAffectedPropertyKey,
										nil];
		
		[[NSNotificationCenter defaultCenter] postNotificationName: WILDPartWillChangeNotification object: part userInfo: infoDict];

		[part setMediaPath: thePath];
		
		[[NSNotificationCenter defaultCenter] postNotificationName: WILDPartDidChangeNotification object: part userInfo: infoDict];
		[part updateChangeCount: NSChangeDone];
	}
}

@end
