//
//  AFUser.h
//  Ola Mundo
//
//  Created by Sankar Dheksit on 8/13/13.
//  Copyright (c) 2013 olamundo. All rights reserved.
//

#import "User.h"

@interface AFUser : User

+ (void) registerDevise;
+ (void) verifyPhoneNumberWithCompletionBlock:(void (^)(NSError *error))completionBlock;
+ (void) resendVerificationCodeWithCompletionBlock:(void (^)(NSError *error))completionBlock;
+ (void) requestCallWithCompletionBlock:(void (^)(NSError *error))completionBlock;
+ (void) verifyUserWithCompletionBlock:(void (^)(NSError *error))completionBlock;
+ (void) sendProfileInfoWithCompletionBlock:(void (^)(NSError *error))completionBlock;
+ (void) requestForCall:(void (^)(NSError *error))completionBlock;
+ (void) sendMessageWithCompletionBlock:(void (^)(NSError *error))completionBlock withMessage:(NSDictionary*)message;
+ (void) pullMessageWithCompletionBlock:(void (^)(NSError *error))completionBlock;
+ (void) fetchutuContacts;
+ (NSArray*)addressBookLoader;
+ (void) fetchMessageWithCompletionBlock:(void (^)(NSError *error))completionBlock user:(NSString *)userId contact:(NSString *)contactId;
+ (void) checkUnreadMessage;
+ (void) readMessages;
+ (void) addContact:(NSString *)contactId;

+ (void) rewardRedeme:(NSString *)points withType:(NSString *)type quantitiy:(NSString *)quantitiy name:(NSString *)name;
+ (void) pointsHistoryWithCompletionBlock:(void (^)(NSError *error))completionBlock;
+ (void) redeemHistoryWithCompletionBlock:(void (^)(NSError *error))completionBlock;

+ (void) redeemOptionsWithCompletionBlock:(void (^)(NSError *error))completionBlock;
+ (void) charitiesWithCompletionBlock:(void (^)(NSError *error))completionBlock;

+ (void) addcharityPoints:(NSString *)charityId withPoints:(NSString *)points;

+ (void) getChannels;
+ (void) getShows:(NSString *)channelId;

+ (void) addShowToFav:(NSString *)showId;
+ (void) removeShowFromFav:(NSString *)showId;

+ (void) searchShowsWithCompletionBlock:(void (^)(NSError *error))completionBlock text:(NSString *)searchText;

+ (void) userFavShowsWithCompletionBlock:(void (^)(NSError *error))completionBlock;

+ (void) userRequests:(NSString *)contact_number;

+ (void) getContactProfileWithCompletionBlock:(void (^)(NSError *error))completionBlock;

@end
