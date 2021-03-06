//
//  ForgeGlobalPropertiesStacksmith.m
//  Stacksmith
//
//  Created by Uli Kusterer on 16.04.11.
//  Copyright 2011 Uli Kusterer. All rights reserved.
//

#include "LEOGlobalProperties.h"
#include "StacksmithVersion.h"


#define TOSTRING2(x)	#x
#define TOSTRING(x)		TOSTRING2(x)


void	LEOSetCursorInstruction( LEOContext* inContext )
{
	char		propValueStr[1024] = { 0 };
	LEOGetValueAsString( inContext->stackEndPtr -1, propValueStr, sizeof(propValueStr), inContext );
	LEOCleanUpStackToPtr( inContext, inContext->stackEndPtr -1 );
	
	// TODO: Set the cursor with propValueStr here.
	
	inContext->currentInstruction++;
}


void	LEOPushCursorInstruction( LEOContext* inContext )
{
	LEOPushIntegerOnStack( inContext, 128 );	// TODO: Actually retrieve actual cursor ID here.
	
	inContext->currentInstruction++;
}


void	LEOSetVersionInstruction( LEOContext* inContext )
{
//	char		propValueStr[1024] = { 0 };
//	LEOGetValueAsString( inContext->stackEndPtr -1, propValueStr, sizeof(propValueStr), inContext );
	LEOCleanUpStackToPtr( inContext, inContext->stackEndPtr -1 );
	
	// Should we print an error here? Setting the version is kinda pointless.
	
	inContext->currentInstruction++;
}


void	LEOPushVersionInstruction( LEOContext* inContext )
{
	const char*		theVersion = TOSTRING(STACKSMITH_VERSION);
	
	LEOPushStringValueOnStack( inContext, theVersion, strlen(theVersion) );
	
	inContext->currentInstruction++;
}


LEOInstructionFuncPtr	gGlobalPropertyInstructions[LEO_NUMBER_OF_GLOBAL_PROPERTY_INSTRUCTIONS] =
{
	LEOSetCursorInstruction,
	LEOPushCursorInstruction,
	LEOSetVersionInstruction,
	LEOPushVersionInstruction
};


const char*		gGlobalPropertyInstructionNames[LEO_NUMBER_OF_GLOBAL_PROPERTY_INSTRUCTIONS] =
{
	"SetCursor",
	"PushCursor",
	"SetVersion",
	"PushVersion"
};


extern struct TGlobalPropertyEntry	gHostGlobalProperties[(LEO_NUMBER_OF_GLOBAL_PROPERTY_INSTRUCTIONS / 2) +1] =
{
	{ ECursorIdentifier, SET_CURSOR_INSTR, PUSH_CURSOR_INSTR },
	{ EVersionIdentifier, SET_VERSION_INSTR, PUSH_VERSION_INSTR },
	{ ELastIdentifier_Sentinel, INVALID_INSTR, INVALID_INSTR }
};
