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
    // TODO
}

@end
