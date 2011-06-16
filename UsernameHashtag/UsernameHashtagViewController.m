//
//  UsernameHashtagViewController.m
//  UsernameHashtag
//
//  Created by Jamie Pinkham on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UsernameHashtagViewController.h"
#import "MXMatchLabel.h"
#import "MXMatchDescriptor.h"

@implementation UsernameHashtagViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *pretendTweet = @"Hello @jamiepinkham #hastag jamiepinkham@me.com some#words. This is @jamiepinkham(yay!). This is @jamiepinkham.";
    NSError *error = nil;
    NSRegularExpression *usernameRegex = [NSRegularExpression regularExpressionWithPattern:@"(?:\\B)@\\w+" options:NSRegularExpressionCaseInsensitive error:&error];
    MXMatchDescriptor *usernameDescriptor = [[MXMatchDescriptor alloc] initWithRegularExpression:usernameRegex matchTag:@"username"];
    usernameDescriptor.matchColor = [UIColor orangeColor];
    usernameDescriptor.matchHighlightColor = [UIColor purpleColor];
    usernameDescriptor.matchFont = [UIFont italicSystemFontOfSize:21.0];
    NSRegularExpression *hashtagRegex = [NSRegularExpression regularExpressionWithPattern:@"\\B#\\w*[a-zA-Z]+\\w*" options:NSRegularExpressionCaseInsensitive error:&error];
    MXMatchDescriptor *hashtagDescriptor = [[MXMatchDescriptor alloc] initWithRegularExpression:hashtagRegex matchTag:@"hashtag"];
    MXMatchLabel *label = [[MXMatchLabel alloc] initWithFrame:self.view.bounds];
    label.text = pretendTweet;
    label.textFont = [UIFont systemFontOfSize:17.0f];
    label.textColor = [UIColor redColor];
    [label addMatchDescriptors:[NSArray arrayWithObjects:usernameDescriptor, hashtagDescriptor, nil]];
    label.delegate = self;
    [self.view addSubview:label];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)matchingLabel:(MXMatchLabel *)matchingLabel didTouchMatch:(MXMatchDescriptor *)descriptor text:(NSString *)text{
    NSLog(@"touched descriptor with tag = %@", [descriptor matchTag]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You touched a match" message:[NSString stringWithFormat:@"%@ = %@", [descriptor matchTag], text] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

@end
