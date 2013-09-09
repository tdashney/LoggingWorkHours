//
//  TDAppDelegate.m
//  ProductivityRecorder
//
//  Created by Thomas Dashney on 2013-09-08.
//  Copyright (c) 2013 Thomas Dashney. All rights reserved.
//

#import "TDAppDelegate.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

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
    
    NSLog(@"Date created: %@",[self stringFromDate:self.startDate]);
}

- (IBAction)stopWorking:(id)sender {
    // gather data and send it to the server
    
    NSDate *endTime = [NSDate date];
    
    NSTimeInterval interval = [endTime timeIntervalSinceDate:self.startDate];
    float hoursSpent = interval / 60 / 60;
    
    NSMutableString *workCompleted = [NSMutableString stringWithFormat:@""];
    for (NSString *logEntry in self.loggedWork) {
        [workCompleted appendFormat:@"%@\n",logEntry];
    }
    
    NSString *dateStarted = [self stringFromDate:self.startDate];
    NSString *hoursWorked = [NSString stringWithFormat:@"%.02f",hoursSpent];
    NSString *workLog = workCompleted;
    
    NSDictionary *postDict = @{@"date":dateStarted,@"hours":hoursWorked,@"workLog":self.loggedWork};
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://thomasdashney.com/selfProductivity"]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"http://thomasdashney.com/selfProductivity/publishWorkSession.php" parameters:postDict];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text
        NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
    
    // reset the menubar
    NSMenuItem *stopWorkingItem = [self.statusMenu itemWithTitle:@"Stop Working"];
    [stopWorkingItem setHidden:YES];
    NSMenuItem *startWorkingItem = [self.statusMenu itemWithTitle:@"Start Working"];
    [startWorkingItem setHidden:NO];
    NSMenuItem *logWorkItem = [self.statusMenu itemWithTitle:@"Log Work"];
    [[logWorkItem view] setHidden:YES];
}

- (IBAction)logWork:(id)sender {
    NSButton *logButton = (NSButton *)sender;
    NSTextField *textField = (NSTextField *) [[[logButton superview] subviews] objectAtIndex:0];
    NSString *logEntry = textField.stringValue;
    [self.loggedWork insertObject:logEntry atIndex:self.loggedWork.count];
}

/* Quick helper to get the string from the date */
- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeStyle:NSDateFormatterNoStyle];
    [df setDateStyle:NSDateFormatterFullStyle];
    
    NSLocale *canLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [df setLocale:canLocale];
    return [df stringFromDate:self.startDate];
}

@end
