//
//  CreateCircleViewController.m
//  Shyft
//
//  Created by Rick Strom on 2/8/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import "CreateCircleViewController.h"

@interface CreateCircleViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *circleImageButton;
@property (weak, nonatomic) IBOutlet UITextView *circleDescriptionTextView;
@property (weak, nonatomic) IBOutlet UITextField *circleTitleTextField;

@property (weak, nonatomic) IBOutlet UILabel *circleTimeLabel;
@property (weak, nonatomic) IBOutlet UITextField *circleURLTextField;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UIView *categoryContainerView;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

- (IBAction)setTimeMinusButtonHit:(id)sender;
- (IBAction)setTimePlusButtonHit:(id)sender;


- (IBAction)circleImageButtonHit:(id)sender;
- (IBAction)createButtonHit:(id)sender;
@end

@implementation CreateCircleViewController
/*
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Configure the navigation bar
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"caremob_navbar_logo"]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:12.0/255.0 green:105.0/255.0 blue:148.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];

    // Configure the back button
    UIBarButtonItem *MyBackButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    //UIBarButtonItem *MyBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navBarBackButton"] landscapeImagePhone:[UIImage imageNamed:@"navBarBackButton"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    MyBackButton.title = @"";
    
    NSDictionary *myBackButtonTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                [UIFont fontWithName:@"NettoOT" size:16.0f], NSFontAttributeName,
                                                nil];
    [MyBackButton setTitleTextAttributes:myBackButtonTextAttributes forState:UIControlStateNormal];
    [MyBackButton setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.backBarButtonItem = MyBackButton;

    
    // Set up a gesture recognizer to dismiss the keyboard when a user taps outside of a textfield or textview
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tapCategory = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCategoryDrilldown)];
    [self.categoryContainerView addGestureRecognizer:tapCategory];
    
    [self resetAllFields];
}

-(void)back {
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

-(void)resetAllFields {
    // Reset all fields
    self.circleCategory = @"";
    self.categoryLabel.text = @"<Tap to select category>";
    
    [self.circleImageButton setBackgroundImage:[UIImage imageNamed:@"caremob_create_tap_to_add_photo"] forState:UIControlStateNormal];
    [self.circleImageButton setTitle:@"<Select image>" forState:UIControlStateNormal];
    self.circleDescriptionTextView.text = @"<Enter circle description - max 140 char>";
    self.circleTime = 10;
    self.circleTimeLabel.text = @"10s";
    self.circleURLTextField.text = @"";
    self.circleTitleTextField.text = @"";
    
}

-(void)selectCategory:(NSString*)category {
    self.circleCategory = [NSString stringWithString:category];
    self.categoryLabel.text = [NSString stringWithFormat:@"Circle of %@", self.circleCategory];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    if ([segue.identifier isEqualToString:@"showCircleInfoViewController"]) {
        CircleInfoViewController *destination = (CircleInfoViewController*)[segue destinationViewController];
        destination.circle = self.circle;
        [self resetAllFields];
        self.circle = nil;
    } else if ([segue.identifier isEqualToString:@"showCreateCircle_CategoryDrilldownViewController"]) {
        CreateCircle_CategoryDrilldownViewController *destination = (CreateCircle_CategoryDrilldownViewController*)[segue destinationViewController];
        destination.delegate = self;
    }
}

-(void)showCategoryDrilldown {
    [self performSegueWithIdentifier:@"showCreateCircle_CategoryDrilldownViewController" sender:self];
}

-(void)dismissKeyboard {
    if (self.activeTextField != nil)
        [self.activeTextField resignFirstResponder];
    else if (self.activeTextView != nil)
        [self.activeTextView resignFirstResponder];
}

#pragma Picker View Data Source methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //Return the number of components
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //Return the number of rows in the component
    return 10;
}

#pragma mark -
#pragma Picker View Delegate methods

//Set the dimensions of the picker view.

//The methods in this group are marked @optional. However, to use a picker view, you must implement either the pickerView:titleForRow:forComponent: or the pickerView:viewForRow:forComponent:reusingView: method to provide the content of component rows.
//If both pickerView:titleForRow:forComponent: and pickerView:attributedTitleForRow:forComponent: are implemented, attributed title is favored.

// Return a string representing the title for the given row.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //return [dataSource objectAtIndex:row];
    return @"Something";
}


//Return a view to use for the given row:.
//reusingView is A view object that was previously used for this row, but is now hidden and cached by the picker view.
//If the previously used view is good enough, return that.
//The picker view centers the returned view in the rect for the given row.

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //Do something when the row is selected.
}

#pragma mark - Text Field Delegate Methods
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeTextField = nil;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Text View Delegate Methods
-(void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"<Enter circle description - max 140 char>"]) textView.text = @"";
    
    self.activeTextView = textView;
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    self.activeTextView = nil;
}

- (void)keyboardWillHide:(NSNotification *)n {
    float kTabBarHeight = 49.0;
    
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    // resize the scrollview
    CGRect viewFrame = self.scrollView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height += (keyboardSize.height - kTabBarHeight);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.scrollView setFrame:viewFrame];
    [UIView commitAnimations];
    
    self.keyboardIsShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)n {
    float kTabBarHeight = 49.0;
    
    // This is an ivar I'm using to ensure that we do not do the frame size adjustment on the `UIScrollView` if the keyboard is already shown.  This can happen if the user, after fixing editing a `UITextField`, scrolls the resized `UIScrollView` to another `UITextField` and attempts to edit the next `UITextField`.  If we were to resize the `UIScrollView` again, it would be disastrous.  NOTE: The keyboard notification will fire even when the keyboard is already shown.
    if (self.keyboardIsShown) {
        return;
    }
    
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // resize the noteView
    CGRect viewFrame = self.scrollView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height -= (keyboardSize.height - kTabBarHeight);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.scrollView setFrame:viewFrame];
    [UIView commitAnimations];
    self.keyboardIsShown = YES;
}



- (IBAction)setTimeMinusButtonHit:(id)sender {
    self.circleTime -= 1;
    if (self.circleTime < kMinimumCircleTime) self.circleTime = kMinimumCircleTime;
    
    self.circleTimeLabel.text = [NSString stringWithFormat:@"%ds", self.circleTime];
}

- (IBAction)setTimePlusButtonHit:(id)sender {
    self.circleTime += 1;
    if (self.circleTime > kMaximumCircleTime) self.circleTime = kMaximumCircleTime;
    
    self.circleTimeLabel.text = [NSString stringWithFormat:@"%ds", self.circleTime];
}

- (IBAction)circleImageButtonHit:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Source?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Camera" otherButtonTitles:@"Library", nil];
    [actionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];

}

- (IBAction)createButtonHit:(id)sender {
    // Do validation checks
    if ([self.circleTitleTextField.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"No title entered!" message:@"Please enter a title for your new circle!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        
        return;
    }

    if ([self.circleCategory isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"No category entered!" message:@"Please enter a category for your new circle!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        
        return;
    }

    if (self.circle == nil) self.circle = [PFObject objectWithClassName:kCircleClassKey];
    [self.circle setObject:@"Unity" forKey:kCircleFieldCategoryKey];
    [self.circle setObject:self.circleDescriptionTextView.text forKey:kCircleFieldShortTextKey];
    [self.circle setObject:self.circleTitleTextField.text forKey:kCircleFieldTitleKey];
    [self.circle setObject:[PFUser currentUser] forKey:kCircleFieldCreatedByKey];
    [self.circle setObject:self.circleCategory forKey:kCircleFieldCategoryKey];
    [self.circle setObject:self.circleURLTextField.text forKey:kCircleFieldUrlKey];
    [self.circle setObject:[NSNumber numberWithInt:self.circleTime] forKey:kCircleFieldTimeToJoinKey];
    
    [self.circle saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            
        } else {
 
            
            [self performSegueWithIdentifier:@"showCircleInfoViewController" sender:self];
        }
    }];
    
}

#pragma mark - Image Picker Delegate Methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    PFUser *user = [PFUser currentUser];
    if (user == nil) return;
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    //UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Size and save these files
    
    // Full size
    UIGraphicsBeginImageContext(CGSizeMake(600,600));
    [image drawInRect:CGRectMake(0,0,600,600)];
    UIImage *sizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(sizedImage, 0.05f);
    
    PFFile *imageFile = [PFFile fileWithName:@"UserImage.jpg" data:imageData];
    
    // Save both files in background
    [imageFile saveInBackground];
    
    if (self.circle == nil) self.circle = [PFObject objectWithClassName:kCircleClassKey];
    
    [self.circle setObject:imageFile forKey:kCircleFieldImageKey];

    [self.circleImageButton setBackgroundImage:sizedImage forState:UIControlStateNormal];
    [self.circleImageButton setTitle:@"" forState:UIControlStateNormal];
}

#pragma mark - Action Sheet Delegate Methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        
        [self presentViewController:imagePicker animated:YES completion:NULL];
    } else if (buttonIndex == 1) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = YES;
        
        [self presentViewController:imagePicker animated:YES completion:NULL];
        
    }
}
*/
@end
