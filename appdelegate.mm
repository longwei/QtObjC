#import "UIKit/UIKit.h"
#include <QtCore>

//@interface QIOSApplicationDelegate
//@end

@interface QIOSApplicationDelegate
@end

@interface QIOSApplicationDelegate(AppDelegate)
@end

@implementation QIOSApplicationDelegate (AppDelegate)

// It just demonstrate how to override QIOSApplicationDelegate to get
// launch options via didFinishLaunchingWithOptions.
// QuickIOS do not bundle this code since it may conflict with
// other framework whose need this piece of information

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    Q_UNUSED(application);

    NSLog(@"didFinishLaunchingWithOptions: %@", [launchOptions description]);
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];

    return YES;
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    Q_UNUSED(application);
    //Tell the system that you ar done.
    NSLog(@"dowloading....");
    completionHandler(UIBackgroundFetchResultNewData);
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    Q_UNUSED(application);
    Q_UNUSED(sourceApplication);
    Q_UNUSED(annotation);
    NSLog(@"deeplink: %@", url);
    return YES;
//    if([[url host] isEqualToString:@"page"]){
//        if([[url path] isEqualToString:@"/main"]){
//            NSLog(@"main");
//        }
//        else if([[url path] isEqualToString:@"/page1"]){
//            NSLog(@"page1");
//        }
//        return YES;
//    }
//    else{
//        return NO;
//    }
}

@end



