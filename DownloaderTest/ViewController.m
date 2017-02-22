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
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 1
    NSURLSessionConfiguration *backgroundConfigurationObject = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"myBackgroundSessionIdentifier"];
    backgroundConfigurationObject.sessionSendsLaunchEvents = YES;
    backgroundConfigurationObject.discretionary = YES;
    
    // 2
    self.backgroundSession = [NSURLSession sessionWithConfiguration:backgroundConfigurationObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//    self.backgroundSession = [NSURLSession sharedSession];
    
    // 3
    [self.progressView setProgress:0 animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showMeFile:(id)sender {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectoryPath = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *destinationURL = [NSURL fileURLWithPath:[documentDirectoryPath stringByAppendingPathComponent:@"tst.mp4"]];
    NSLog(@"***%@***",[destinationURL path]);
    
    if ([fileManager fileExistsAtPath:[destinationURL path]]){
        [self showFile:[destinationURL path]];
        
    }else{
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
    }

}

- (IBAction)downloadFile:(id)sender {
    NSLog(@"downloadFile");
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectoryPath = [paths objectAtIndex:0];
    NSLog(@"***downloadFile %@***",documentDirectoryPath);
    
    NSURL *URL = [NSURL URLWithString:@"http://localhost:8000/%E5%88%BA%E5%AE%A2%E4%BF%A1%E6%9D%A1.Assassins.Creed.2016.1080p.KORSUB.HDRip.x264.AAC2.0-%E4%B8%AD%E6%96%87%E5%AD%97%E5%B9%95-RARBT.mp4"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
//    NSURLSessionDownloadTask *downloadTask = [_backgroundSession downloadTaskWithRequest:request
//                                                            completionHandler:
//                                              ^(NSURL *location, NSURLResponse *response, NSError *error) {
//                                                  NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//                                                  NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:documentsPath];
//                                                  NSURL *documentURL = [documentsDirectoryURL URLByAppendingPathComponent:[response
//                                                                                                                           suggestedFilename]];
//                                                  [[NSFileManager defaultManager] moveItemAtURL:location
//                                                                                          toURL:documentURL
//                                                                                          error:nil];
//                                              }];
    
    NSURLSessionDownloadTask* downloadTask = [_backgroundSession downloadTaskWithURL:URL];
    [downloadTask resume];
    
    
    
//    if (download == nil){
//        NSURL *url = [NSURL URLWithString:@"http://localhost:8000/%E5%88%BA%E5%AE%A2%E4%BF%A1%E6%9D%A1.Assassins.Creed.2016.1080p.KORSUB.HDRip.x264.AAC2.0-%E4%B8%AD%E6%96%87%E5%AD%97%E5%B9%95-RARBT.mp4"];
//        download = [self.backgroundSession downloadTaskWithURL:url];
//        [download resume];
//    }
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
    NSLog(@"didCompleteWithError");
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
    NSLog(@"didFinishDownloadingToURL");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectoryPath = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *destinationURL = [NSURL fileURLWithPath:[documentDirectoryPath stringByAppendingPathComponent:@"tst.mp4"]];
    NSLog(@"***location***%@",[location path]);
    NSLog(@"***destinationURL***%@",[destinationURL path]);
    
    NSError *error = nil;
    
    if ([fileManager fileExistsAtPath:[destinationURL path]]){
        [fileManager replaceItemAtURL:destinationURL withItemAtURL:destinationURL backupItemName:nil options:NSFileManagerItemReplacementUsingNewMetadataOnly resultingItemURL:nil error:&error];
        [self showFile:[destinationURL path]];
        
    }else{
        
        if ([fileManager moveItemAtURL:location toURL:destinationURL error:&error]) {
            
            [self showFile:[destinationURL path]];
        }else{
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
        }
    }
}

// 2 provides the app with status informations about the progress of the download
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    NSLog(@"%g",(double)totalBytesWritten/(double)totalBytesExpectedToWrite);
    [self.progressView setProgress:(double)totalBytesWritten/(double)totalBytesExpectedToWrite
                          animated:YES];
}

// 3 called when its attempt to resume a previously failed download was successful
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
    NSLog(@"expectedTotalBytes");
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"PDFDownloader" message:@"Download is resumed successfully" preferredStyle:UIAlertControllerStyleActionSheet];
    [self presentViewController:alert animated:YES completion:nil];
}



- (void)showFile:(NSString*)path{
    
    // Check if the file exists
    BOOL isFound = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (isFound) {
        NSLog(@"got it");
        
//        UIDocumentInteractionController *viewer = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:path]];
//        viewer.delegate = self;
//        [viewer presentPreviewAnimated:YES];
    }
}

- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller{
    
    return self;
}

@end
