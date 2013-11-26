//
//  XYZFlickrPhotoViewController.m
//  FlickrSearch
//
//  Created by Joe Selvik on 11/18/13.
//  Copyright (c) 2013 Joe Selvik. All rights reserved.
//

#import "XYZFlickrPhotoViewController.h"
#import "Flickr.h"
#import "FlickrPhoto.h"

@interface XYZFlickrPhotoViewController ()

@property(weak) IBOutlet UIImageView *imageView;
-(IBAction)done:(id)sender;

@end

@implementation XYZFlickrPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}


-(void)viewDidAppear:(BOOL)animated {
    // 1 - If the large photo has already been fetched, simply set imageView to display that image.
    if(self.flickrPhoto.largeImage) {
        self.imageView.image = self.flickrPhoto.largeImage;
    } else {
        // 2 - If the large photo has not been fetched, display a stretched version of the thumbnail
        self.imageView.image = self.flickrPhoto.thumbnail;
        
        // 3 - Tell Flickr to load the larger size for that photo.
        [Flickr loadImageForPhoto:self.flickrPhoto thumbnail:NO completionBlock:^(UIImage *photoImage, NSError *error) {
            if(!error) {
                // 4 - If there wasn’t an error, update the image view image in the main thread, since the photo now has a valid large photo.
                dispatch_async(dispatch_get_main_queue(), ^{ self.imageView.image = self.flickrPhoto.largeImage;
                });
            }
        }];
    }
}

@end
