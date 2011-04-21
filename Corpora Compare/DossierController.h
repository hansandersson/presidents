//
//  DossierController.h
//  E Pluribus Unum
//
//  Created by Hans Andersson on 11/04/21.
//  Copyright 2011 Ultramentem. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class President;

@interface DossierController : NSWindowController {
@private
    President *representedObject;
	
	IBOutlet NSTableView *speechesTableView;
}

@property (readwrite, assign) President *representedObject;

- (void)beginDossierModalForWindow:(NSWindow *)host;
- (void)didEndSheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
- (IBAction)closeDossier:(id)sender;

@end
