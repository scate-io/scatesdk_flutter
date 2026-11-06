#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ScateAdjustInitStatus) {
    ScateAdjustInitStatusUnavailable = 0,
    ScateAdjustInitStatusConfigUnavailable = 1,
    ScateAdjustInitStatusConfigCreationFailed = 2,
    ScateAdjustInitStatusInitialized = 3,
};

@interface ScateAdjustBridge : NSObject

+ (BOOL)isAvailable;
+ (ScateAdjustInitStatus)initializeWithAppToken:(NSString *)appToken
                                            noATT:(BOOL)noATT
                        attConsentWaitingInterval:(NSUInteger)attConsentWaitingInterval;
+ (BOOL)requestAdidWithCompletion:(void (^)(NSString * _Nullable adid))completion;
+ (BOOL)requestAppTrackingAuthorizationWithCompletion:(void (^)(NSUInteger status))completion;
+ (BOOL)addGlobalPartnerParameter:(NSString *)value forKey:(NSString *)key;
+ (BOOL)isGoogleOdmFrameworkLinked;

@end

NS_ASSUME_NONNULL_END
