#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <dispatch/dispatch.h>

@interface GIFConverter: NSObject

@property (strong, nonatomic) AVAssetWriter *videoWriter;

- (void)exportUrl:(NSURL *)url size:(CGSize)size suiteName:(NSString *)suiteName filename:(NSString *)filename completion:(void (^)(NSInteger framesCount))completion;

@end
