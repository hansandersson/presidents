//
//  DossierController.m
//  E Pluribus Unum
//
//  Created by Hans Andersson on 11/04/21.
//  Copyright 2011 Ultramentem. All rights reserved.
//

#import "DossierController.h"


@implementation DossierController

@synthesize representedObject;

- (void)beginDossierModalForWindow:(NSWindow *)host
{
	[NSApp beginSheet:[self window] modalForWindow:host modalDelegate:self didEndSelector:@selector(didEndSheet:returnCode:contextInfo:) contextInfo:NULL];
}

- (void)didEndSheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
	(void)sheet;
	(void)returnCode;
	(void)contextInfo;
	[[self window] orderOut:self];
}

- (IBAction)closeDossier:(id)sender
{
	(void)sender;
	[NSApp endSheet:[self window]];
}

@end
