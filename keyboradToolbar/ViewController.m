//
//  ViewController.m
//  keyboradToolbar
//
//  Created by Martin Michelini on 3/18/16.
//  Copyright © 2016 Martin Michelini. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *state;
@property (weak, nonatomic) IBOutlet UITextField *zipCode;
@property (weak, nonatomic) IBOutlet UITextField *dob;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (strong, nonatomic) MMKeyboardControls *keyboardControls;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Resize navigation bar, change bar and buttons color
    self.navBar.frame = CGRectMake(self.navBar.frame.origin.x, self.navBar.frame.origin.y, self.navBar.frame.size.width, 64);
    [self.navBar setTitleTextAttributes: @{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navBar.tintColor = [UIColor whiteColor];
    self.navBar.barTintColor = [UIColor blueColor];
    
    //create array with textfields
    NSArray *fields = @[self.firstName,
                        self.lastName,
                        self.address,
                        self.city,
                        self.state,
                        self.zipCode,
                        self.dob,
                        self.email,
                        self.phone];
    
    //add delegate to fields
    for (UITextField *field in fields)
    {
        field.delegate = self;
    }
    
    //create the toolbar
    [self setKeyboardControls:[[MMKeyboardControls alloc] initWithFields:fields]];
    
    //register for keyboard notifications
    [self registerForKeyboardNotifications];
    
    // Make the scroller size dynamically
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.scroller.subviews)
    {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
//    contentRect.size.height += 20.0f;
    self.scroller.contentSize = contentRect.size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Create Notifications

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Textfield Behavior

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.keyboardControls setActiveField:textField];
    if (textField.tag == 0)
    {
        [self.scroller setContentOffset:CGPointZero animated:YES];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Scroller Movements

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scroller.contentInset = contentInsets;
    self.scroller.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.keyboardControls.activeField.frame.origin) )
    {
        [self.scroller scrollRectToVisible:self.keyboardControls.activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scroller.contentInset = contentInsets;
    self.scroller.scrollIndicatorInsets = contentInsets;
    [self.scroller setContentOffset:CGPointZero animated:YES];
}

@end
