//
//  TDAppDelegate.h
//  ProductivityRecorder
//
//  Created by Thomas Dashney on 2013-09-08.
//  Copyright (c) 2013 Thomas Dashney. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TDAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSMenu *statusMenu;
@property (strong, nonatomic) NSStatusItem *statusBar;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSMutableArray *loggedWork; // array of strings

- (IBAction)startWorking:(id)sender;
- (IBAction)stopWorking:(id)sender;
- (IBAction)logWork:(id)sender;

@end
