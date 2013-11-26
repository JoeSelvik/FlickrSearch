//
//  XYZViewController.m
//  FlickrSearch
//
//  Created by Joe Selvik on 11/14/13.
//  Copyright (c) 2013 Joe Selvik. All rights reserved.
//

#import "XYZViewController.h"
#import "Flickr.h"
#import "FlickrPhoto.h"
#import "XYZFlickrPhotoCell.h"
#import "XYZFlickrPhotoHeaderView.h"
#import "XYZFlickrPhotoViewController.h"
#import <MessageUI/MessageUI.h>

@interface XYZViewController () <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MFMailComposeViewControllerDelegate>

// View properties
@property(nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property(nonatomic, weak) IBOutlet UIBarButtonItem *shareButton;
@property(nonatomic, weak) IBOutlet UITextField *textField;
- (IBAction)shareButtonTapped:(id)sender;

// Preping data structures for flickr
@property(nonatomic, strong) NSMutableDictionary *searchResults;
@property(nonatomic, strong) NSMutableArray *searches;
@property(nonatomic, strong) Flickr *flickr;

// Outlet for the UICollectionView
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;

// Controls what happens when a user taps the share button
// true when the user is making a multi-selection to share images
// normal setting will be false (which means tapping an image will bring up the modal detail view)
@property (nonatomic) BOOL sharing;

// For multiple photo selection mode
@property(nonatomic, strong) NSMutableArray *selectedPhotos;

@end

@implementation XYZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Make the background image of the View an image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cork.png"]];
    
    // Set the background of the navbar to an image
    UIImage *navBarImage = [[UIImage imageNamed:@"navbar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(27, 27, 27, 27)];
    [self.toolbar setBackgroundImage:navBarImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    // Set the background of the share button to an image
    UIImage *shareButtonImage = [[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [self.shareButton setBackgroundImage:shareButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    // Set the background of the search text field to an image
    UIImage *textFieldImage = [[UIImage imageNamed:@"search_field.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.textField setBackground:textFieldImage];
    
    // Initialize Flickr data structures
    self.searches = [@[] mutableCopy];
    self.searchResults = [@{} mutableCopy];
    self.flickr = [[Flickr alloc] init];
    
    // Tell the UICollectionView what class it’s supposed to use to create cells
    // Default UICollectionViewCell
    // [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"FlickrCell"];
    // Custom UICollectionViewCell
    
    // Initialize multiple photo selection array
    self.selectedPhotos = [@[] mutableCopy];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)shareButtonTapped:(id)sender {
    UIBarButtonItem *shareButton = (UIBarButtonItem *)sender;
    
    // 1 - If the user currently isn’t in sharing mode, this code sets the UICollectionView to
    // allow multiple selection and changes the Share button title to Done.
    if (!self.sharing) {
        self.sharing = YES;
        [shareButton setStyle:UIBarButtonItemStyleDone];
        [shareButton setTitle:@"Done"];
        [self.collectionView setAllowsMultipleSelection:YES];
    } else {
        // 2 - the user is already in sharing mode and has tapped on the Done button. Switch the button
        // title back to Share and disable UICollectionView multi-selection.
        self.sharing = NO;
        [shareButton setStyle:UIBarButtonItemStyleBordered];
        [shareButton setTitle:@"Share"];
        [self.collectionView setAllowsMultipleSelection:NO];
        
        // 3 - Check if the user has any selected photos, and if so, call showMailComposerAndSend.
        if ([self.selectedPhotos count] > 0) {
            [self showMailComposerAndSend];
        }
        
        // 4 - Deselect all of the selected cells and remove all photos from the selectedPhotos array.
        for(NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems) {
            [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
        }
        
        [self.selectedPhotos removeAllObjects];
    }
}


#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // 1
    [self.flickr searchFlickrForTerm:textField.text completionBlock:^(NSString *searchTerm, NSArray *results, NSError *error) {
        if(results && [results count] > 0) {
            
            // 2 - Checks to see if this was searched before
            if(![self.searches containsObject:searchTerm]) {
                // If not add to the front of the searches array
                NSLog(@"Found %d photos matching %@", [results count],searchTerm);
                [self.searches insertObject:searchTerm atIndex:0];
                self.searchResults[searchTerm] = results; }
            
            // 3 - New data found and need to refresh the UI
            dispatch_async(dispatch_get_main_queue(), ^{
                // Reload collectionview data
                [self.collectionView reloadData];
            });
        } else { // 4 - Log any errors
            NSLog(@"Error searching Flickr: %@", error.localizedDescription);
        } }];
    [textField resignFirstResponder];
    return YES; 
}

#pragma mark - UICollectionView Datasource
// 1 - Returns number of items in eachsection of searches
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    NSString *searchTerm = self.searches[section];
    return [self.searchResults[searchTerm] count];
}

// 2 - Returns the number of searches, or sections
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return [self.searches count];
}

// 3 - Return a Flickr cell with a loaded image
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XYZFlickrPhotoCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FlickrCell" forIndexPath:indexPath];
    NSString *searchTerm = self.searches[indexPath.section];
    cell.photo = self.searchResults[searchTerm]
    [indexPath.row];
    return cell;
}

// 4 - Returns either the headers or footers of searches
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    XYZFlickrPhotoHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FlickrPhotoHeaderView" forIndexPath:indexPath];
    NSString *searchTerm = self.searches[indexPath.section]; [headerView setSearchText:searchTerm];
    return headerView;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.sharing) {
        // Single-Selection
        NSString *searchTerm = self.searches[indexPath.section];
        FlickrPhoto *photo = self.searchResults[searchTerm][indexPath.row];
        [self performSegueWithIdentifier:@"ShowFlickrPhoto" sender:photo];
        [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    } else {
        // Multi-Selection
        NSString *searchTerm = self.searches[indexPath.section];
        FlickrPhoto *photo = self.searchResults[searchTerm][indexPath.row];
        [self.selectedPhotos addObject:photo];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Deselect item
    if (self.sharing) {
        NSString *searchTerm = self.searches[indexPath.section];
        FlickrPhoto *photo = self.searchResults[searchTerm][indexPath.row];
        [self.selectedPhotos removeObject:photo];
    }
}

#pragma mark – UICollectionViewDelegateFlowLayout
// These are delegate methods for UICVFL

// 1 - Tells the layout the size of a given cell
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *searchTerm = self.searches[indexPath.section];
    FlickrPhoto *photo = self.searchResults[searchTerm][indexPath.row];
    
    // 2 - Determine which size to return; if photo is not loaded asynch yet then give a default size
    CGSize retval = photo.thumbnail.size.width > 0 ? photo.thumbnail.size : CGSizeMake(100, 100);
    retval.height += 35; retval.width += 35; return retval;
}

// 3 - returns the spacing between the cells, headers, and footers.
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(50, 20, 50, 20);
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowFlickrPhoto"]) {
        XYZFlickrPhotoViewController *flickrPhotoViewController = segue.destinationViewController;
        flickrPhotoViewController.flickrPhoto = sender;
    }
}

-(void)showMailComposerAndSend {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@"Check out these Flickr Photos"];
        NSMutableString *emailBody = [NSMutableString string];
        for(FlickrPhoto *flickrPhoto in self.selectedPhotos)
        {
            NSString *url = [Flickr flickrPhotoURLForFlickrPhoto: flickrPhoto size:@"m"];
            [emailBody appendFormat:@"<div><img src='%@'></div><br>",url];
        }
        
        [mailer setMessageBody:emailBody isHTML:YES];
        [self presentViewController:mailer animated:YES completion:^{}];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mail Failure" message:@"Your device doesn't support in-app email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

@end
