#import "ParseStarterProjectViewController.h"
#import <Parse/Parse.h>
#import "ParseCCTableViewController.h"

@implementation ParseStarterProjectViewController


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UIViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.outTxtParseAppID.text = @"enter app id";
    self.outTxtClientKey.text  = @"enter client Key";
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)axnContinuePressed:(id)sender {
    
    //--initialize Parse Setup
    [Parse setApplicationId:self.outTxtParseAppID.text
                  clientKey:self.outTxtClientKey.text];
    
    

    ParseCCTableViewController *page = [[ParseCCTableViewController alloc] initWithNibName:@"ParseCCTableViewController" bundle:nil];
    
    [self.navigationController pushViewController:page animated:YES];
}



@end
