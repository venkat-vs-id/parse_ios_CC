@class ParseStarterProjectViewController;

@interface ParseStarterProjectAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet ParseStarterProjectViewController *viewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
