//
//  UKPropagandaPictureView.m
//  Propaganda
//
//  Created by Uli Kusterer on 21.03.10.
//  Copyright 2010 The Void Software. All rights reserved.
//

#import "UKPropagandaPictureView.h"


@implementation UKPropagandaPictureView

-(id)	initWithFrame: (NSRect)frame
{
    if(( self = [super initWithFrame: frame] ))
	{
        // Initialization code here.
    }
    return self;
}


-(void)	dealloc
{
	[image release];
	image = nil;
	
	[super dealloc];
}


-(void)	drawRect: (NSRect)dirtyRect
{
    [image drawAtPoint: NSZeroPoint fromRect: NSZeroRect operation: NSCompositeSourceOver fraction: 1.0];
}


-(NSImage*)	image
{
	return image;
}


-(void)		setImage: (NSImage*)theImage
{
	if( image != theImage )
	{
		[image release];
		image = [theImage retain];
		[self setNeedsDisplay: YES];
	}
}


-(id)	hitTest: (NSPoint)aPoint
{
	return nil;
}

@end
