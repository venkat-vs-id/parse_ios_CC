@interface ParseStarterProjectViewController : UIViewController

@property (unsafe_unretained, nonatomic) IBOutlet UITextField *outTxtParseAppID;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *outTxtClientKey;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *outBtnContinue;
- (IBAction)axnContinuePressed:(id)sender;
@end
