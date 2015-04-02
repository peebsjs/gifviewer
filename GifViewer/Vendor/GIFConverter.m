#import "GIFConverter.h"
#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>

@implementation GIFConverter

#pragma mark - Life cycle

- (id)init {
    if (!(self = [super init])) {
        return nil;
    }
    return self;
}

#pragma mark - Public

- (void)exportUrl:(NSURL *)url size:(CGSize)size suiteName:(NSString *)suiteName filename:(NSString *)filename completion:(void (^)(NSInteger framesCount))completion {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *containerURL = [fileManager containerURLForSecurityApplicationGroupIdentifier:suiteName];
    NSURL *sharedUrl = [containerURL URLByAppendingPathComponent:@"Frames" isDirectory:YES];
    NSString *sharedPath = sharedUrl.path;
    
    NSError *error = nil;
    
    BOOL isDirectory;
    
    // Remove cache
    if ([fileManager fileExistsAtPath:sharedPath isDirectory:&isDirectory]) {
        if (![fileManager removeItemAtPath:sharedPath error:&error]) {
            NSLog(@"Error removing directory: \"%@\". Error: %@", sharedPath, error);
        }
    }
    
    // Create directory
    if(![fileManager createDirectoryAtPath:sharedPath withIntermediateDirectories:YES attributes:nil error:&error]) {
        NSLog(@"Error creating directory: \"%@\". Error: %@", sharedPath, error);
    }
    
    // Save files
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSArray *frames = [self framesFromData:data size:size];
    for (int i = 0; i < frames.count; i++) {
        NSURL *writeUrl = [sharedUrl URLByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@.png", filename, @(i)]];
        NSData *data = UIImagePNGRepresentation(frames[i]);
        if (![data writeToURL:writeUrl options:0 error:&error]) {
            NSLog(@"Error writing file: \"%@\". Error: %@", url, error);
        }
    }
    
    if (completion) {
        completion(frames.count);
    }
}

#pragma mark - Private

- (NSArray *)framesFromData:(NSData *)data size:(CGSize)size {
    NSMutableArray *frames = nil;
    CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    CGFloat animationTime = 0.f;
    if(src) {
        size_t l = CGImageSourceGetCount(src);
        frames = [NSMutableArray arrayWithCapacity:l];
        for(size_t i = 0; i < l; i++) {
            CGImageRef img = CGImageSourceCreateImageAtIndex(src, i, NULL);
            NSDictionary *properties = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(src, i, NULL);
            NSDictionary *frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            animationTime += [delayTime floatValue];
            if(img) {
                if(size.width != 0.0 && size.height != 0.0) {
                    UIGraphicsBeginImageContext(size);
                    CGFloat width = CGImageGetWidth(img);
                    CGFloat height = CGImageGetHeight(img);
                    int x = 0, y = 0;
                    if(height > width) {
                        CGFloat padding = size.height / height; height = height * padding; width = width * padding; x = (size.width/2) - (width/2); y = 0;
                    } else if(width > height) {
                        CGFloat padding = size.width / width; height = height * padding; width = width * padding; x = 0; y = (size.height/2) - (height/2);
                    } else {
                        width = size.width; height = size.height;
                    }
                    
                    [[UIImage imageWithCGImage:img] drawInRect:CGRectMake(x, y, width, height) blendMode:kCGBlendModeNormal alpha:1.0];
                    [frames addObject:UIGraphicsGetImageFromCurrentImageContext()];
                    UIGraphicsEndImageContext();
                    CGImageRelease(img);

                } else {
                    [frames addObject:[UIImage imageWithCGImage:img]];
                    CGImageRelease(img);
                }
            }
        }
        CFRelease(src);
    }
    
    return frames;
}

@end
