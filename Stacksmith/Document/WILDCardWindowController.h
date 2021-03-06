//
//  WILDCardWindowController.h
//  Stacksmith
//
//  Created by Uli Kusterer on 18.04.10.
//  Copyright 2010 The Void Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class WILDCardViewController;
@class WILDWindowBodyView;
@class WILDStack;
@class WILDCard;


@interface WILDCardWindowController : NSWindowController
{
	WILDStack						*	mStack;
	IBOutlet WILDWindowBodyView		*	mView;
	IBOutlet WILDCardViewController	*	mCardViewController;
}

-(WILDStack*)	stack;

-(void)			goToCard: (WILDCard*)inCard;

-(WILDCard*)	currentCard;

-(void)			setTransitionType: (NSString*)inType subtype: (NSString*)inSubtype;

@end
