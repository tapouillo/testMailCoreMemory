//
//  AppDelegate.h
//  testMailCoreMemory
//
//  Created by Stéphane QUERAUD on 16/07/2014.
//  Copyright (c) 2014 Stéphane QUERAUD. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSButton *button;

-(IBAction) pressButton:(id)sender;
@end
