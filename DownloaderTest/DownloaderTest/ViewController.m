//
//  ViewController.m
//  DownloaderTest
//
//  Created by longwei su on 2/21/17.
//  Copyright © 2017 longwei su. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    NSURLSessionDownloadTask *download;
}
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic, strong)NSURLSession *backgroundSession;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 1
    NSURLSessionConfiguration *backgroundConfigurationObject = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"myBackgroundSessionIdentifier"];
    
    // 2
    self.backgroundSession = [NSURLSession sessionWithConfiguration:backgroundConfigurationObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // 3
    [self.progressView setProgress:0 animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)downloadFile:(id)sender {
    NSLog(@"downloadFile");
    if (download == nil){
        NSURL *url = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/13052904/Using%20MRAA%20to%20Abstract%20Platform%20I_O%20Capabilities.pdf"];
        download = [self.backgroundSession downloadTaskWithURL:url];
        [download resume];
    }
}
- (IBAction)pauseDownload:(id)sender {
    NSLog(@"pauseDownload");
    if (download != nil){
        [download suspend];
    }
}
- (IBAction)resumeDownload:(id)sender {
    NSLog(@"resumeDownload");
    if (download != nil){
        [download resume];
    }
}
- (IBAction)cancelDownload:(id)sender {
    NSLog(@"cancelDownload");
    if (download != nil){
        [download cancel];
    }
    
}

//called when downloaded task is completed
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
    download = nil;
    [self.progressView setProgress:0];
    
    if (true) {
        //    if (true) {
        //        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"didCompleteWithError" message:@"didCompleteWithError" preferredStyle:UIAlertControllerStyleActionSheet];
        //        [self presentViewController:alert animated:YES completion:nil];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Alert"
                                                                       message:@"This is an action sheet."
                                                                preferredStyle:UIAlertControllerStyleActionSheet]; // 1
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"one"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  NSLog(@"You pressed button one");
                                                              }]; // 2
        UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"two"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   NSLog(@"You pressed button two");
                                                               }];
        [alert addAction:firstAction]; // 4
        [alert addAction:secondAction]; // 5
        
        //        [self presentViewController:alert animated:YES completion:nil]; // 6
    }
}


//
// 1 (NSURL *)location contain the temporary file, my app need to move it to permanent location.
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectoryPath = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *destinationURL = [NSURL fileURLWithPath:[documentDirectoryPath stringByAppendingPathComponent:@"file.pdf"]];
    NSLog(@"%@",[destinationURL path]);
    
    NSError *error = nil;
    
    if ([fileManager fileExistsAtPath:[destinationURL path]]){
        [fileManager replaceItemAtURL:destinationURL withItemAtURL:destinationURL backupItemName:nil options:NSFileManagerItemReplacementUsingNewMetadataOnly resultingItemURL:nil error:&error];
        [self showFile:[destinationURL path]];
        
    }else{
        
        if ([fileManager moveItemAtURL:location toURL:destinationURL error:&error]) {
            
            [self showFile:[destinationURL path]];
        }else{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"PDFDownloader" message:@"An error has occurred when moving the file" preferredStyle:UIAlertControllerStyleActionSheet];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

// 2 provides the app with status informations about the progress of the download
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    [self.progressView setProgress:(double)totalBytesWritten/(double)totalBytesExpectedToWrite
                          animated:YES];
}

// 3 called when its attempt to resume a previously failed download was successful
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"PDFDownloader" message:@"Download is resumed successfully" preferredStyle:UIAlertControllerStyleActionSheet];
    [self presentViewController:alert animated:YES completion:nil];
}



- (void)showFile:(NSString*)path{
    
    // Check if the file exists
    BOOL isFound = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (isFound) {
        
        UIDocumentInteractionController *viewer = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:path]];
        viewer.delegate = self;
        [viewer presentPreviewAnimated:YES];
    }
}

- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller{
    
    return self;
}

@end
