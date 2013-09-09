//
//  TDAppDelegate.m
//  ProductivityRecorder
//
//  Created by Thomas Dashney on 2013-09-08.
//  Copyright (c) 2013 Thomas Dashney. All rights reserved.
//

#import "TDAppDelegate.h"

@implementation TDAppDelegate


- (void) awakeFromNib {
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    self.statusBar.title = @"G";
    
    // you can also set an image
    //self.statusBar.image =
    
    self.statusBar.menu = self.statusMenu;
    self.statusBar.highlightMode = YES;
    
    NSMenuItem *stopWorkingItem = [self.statusMenu itemWithTitle:@"Stop Working"];
    [stopWorkingItem setHidden:YES];
    NSMenuItem *logWorkItem = [self.statusMenu itemWithTitle:@"Log Work"];
    [[logWorkItem view] setHidden:YES];
    
    _loggedWork = [[NSMutableArray alloc] init];
    
    //disable stop working
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
}

- (IBAction)startWorking:(id)sender {
    // set global date variable
    _startDate = [NSDate date];
    
    //hide start working and show stop working
    NSMenuItem *startWorkingItem = [self.statusMenu itemWithTitle:@"Start Working"];
    [startWorkingItem setHidden:YES];
    NSMenuItem *stopWorkingItem = [self.statusMenu itemWithTitle:@"Stop Working"];
    [stopWorkingItem setHidden:NO];
    
    
    NSMenuItem *logWorkItem = [self.statusMenu itemWithTitle:@"Log Work"];
    [[logWorkItem view] setHidden:NO];
}

- (IBAction)stopWorking:(id)sender {
    NSDate *endTime = [NSDate date];
    
    NSTimeInterval interval = [endTime timeIntervalSinceDate:self.startDate];
    
    float minutesSpent = interval / 60;
    
    NSLog(@"%.02f Minutes Spent",minutesSpent);
    
    NSMutableString *workCompleted = [NSMutableString stringWithFormat:@""];
    for (NSString *logEntry in self.loggedWork) {
        [workCompleted appendFormat:@"%@\n",logEntry];
    }
    
    // now post this data to the web server!
    /*
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://thomasdashney.com/selfProductivity/publishWorkSession.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
    NSString *xmlString = @"<data><item>Item 1</item><item>Item 2</item></data>";
    
    NSURLResponse *response;
    NSError *error;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    [request setValue:[NSString stringWithFormat:@"%ld", (unsigned long)[xmlString length]] forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",returnString);
*/
}

- (IBAction)logWork:(id)sender {
    NSButton *logButton = (NSButton *)sender;
    NSTextField *textField = (NSTextField *) [[[logButton superview] subviews] objectAtIndex:0];
    NSString *logEntry = textField.stringValue;
    [self.loggedWork insertObject:logEntry atIndex:self.loggedWork.count];
}

@end
