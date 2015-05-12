//
//  AFUser.m
//  Ola Mundo
//
//  Created by Sankar Dheksit on 8/13/13.
//  Copyright (c) 2013 olamundo. All rights reserved.
//

#import "AFUser.h"
//#import "SBJson.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "OMHTTPClient.h"
#import <AddressBookUI/AddressBookUI.h>

@implementation AFUser

-(id)init
{
    
    self = [super init];
    if (self) {
    }
    return self;
}

+ (void) verifyPhoneNumberWithCompletionBlock:(void (^)(NSError *error))completionBlock{
    OMHTTPClient *client = [OMHTTPClient sharedClient];
    
    NSString *phoneNumber = [[AppDelegate user] phoneNumer];
//    NSString *email = @"adin@utu.com";
    NSString *deviceToken;
    if ([[AppDelegate appDelegate] device_token]) {
        deviceToken = [[AppDelegate appDelegate] device_token];
    }else{
        deviceToken = @"";
    }
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:phoneNumber, @"username", @"password", @"password",@"client_login",@"login_type",@"ios",@"device_type",deviceToken,@"device_token", @"password",@"password_confirmation",nil];
    
    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys:parameters, @"user", nil];
    
    NSString *path = [NSString stringWithFormat:@"users.json"];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:path parameters:params];
    [request setTimeoutInterval:20.0];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray *error = [JSON objectForKey:@"errors"];
        if (error) {
            [[AppDelegate user] setErrorInfo:@"phone number invalid"];
        } else {
            NSLog(@"Login is successfull");
            [[AppDelegate user] setErrorInfo:Nil];
            NSLog(@"json values %@", JSON);
            [[AppDelegate user] setId:[NSString stringWithFormat:@"%d",[[JSON objectForKey:@"id"] intValue]]];
        }
        if (completionBlock) {
            completionBlock(Nil);
        }
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error = %@", error);
        [[AppDelegate user] setErrorInfo:@"phone number has already been taken"];
        if (completionBlock) {
            completionBlock(error);
        }
    }];
    [operation start];
}

+ (void) verifyUserWithCompletionBlock:(void (^)(NSError *error))completionBlock{
    OMHTTPClient *client = [OMHTTPClient sharedClient];
    
    NSString *verificationCode = [[AppDelegate user] verificationCode];
    NSString *userId = [[AppDelegate user] id];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:verificationCode, @"activation_code", userId, @"user_id",nil];
    
    NSString *path = [NSString stringWithFormat:@"verify_account.json"];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:parameters];
    [request setTimeoutInterval:20.0];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSString *error = [JSON objectForKey:@"errors"];
        if (error) {
            [[AppDelegate user] setErrorInfo:@"phone number invalid"];
        } else {
            NSLog(@"Login is successfull");
            [[AppDelegate user] setErrorInfo:Nil];
            NSLog(@"json values %@", JSON);
        }
        if (completionBlock) {
            completionBlock(Nil);
        }
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error = %@", error);
        if (completionBlock) {
            completionBlock(error);
        }
    }];
    [operation start];
}

+ (void) sendProfileInfoWithCompletionBlock:(void (^)(NSError *error))completionBlock{
    OMHTTPClient *client = [OMHTTPClient sharedClient];
    
    NSString *username = [[AppDelegate user] username];
    NSString *status = [[AppDelegate user] status];
    NSString *email = [[AppDelegate user] email];
    NSString *birthdate = [[AppDelegate user] birthdate];
    NSString *aboutme = [[AppDelegate user] aboutme];
    NSString *address = [[AppDelegate user] address];
    NSString *city = [[AppDelegate user] city];
    NSString *state = [[AppDelegate user] state];
    NSString *zip = [[AppDelegate user] zip];
    
    NSString *userInfo = [NSString stringWithFormat:@"{\"profile\":{\"username\":\"%@\", \"address\":\"%@\",\"user_id\":\"%@\", \"email\":\"%@\", \"date_of_birth\":\"%@\", \"about_me\":\"%@\", \"status\":\"%@\", \"city\":\"%@\", \"state\":\"%@\", \"pin_code\":\"%@\"}}", username,address,[[AppDelegate user] id],email,birthdate,aboutme,status,city,state,zip];
    
    NSDictionary *userInfoDict = [NSJSONSerialization JSONObjectWithData: [userInfo dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error: nil];
    
    NSData *tempImageData = UIImageJPEGRepresentation( [[AppDelegate user] profilePicture] , 1.0);
    
    NSString *path = [NSString stringWithFormat:@"profiles.json"];
    NSDate *timeNow = [NSDate date];
    int date = [timeNow timeIntervalSince1970];
    NSString *nameOfTheFile = [NSString stringWithFormat:@"%@%d.png",username,date];
    
    NSURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:path parameters:userInfoDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:tempImageData
                                    name:@"profile[avatar]"
                                fileName:nameOfTheFile
                                mimeType:@"application/octet-stream"];
    }];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"Json value %@",JSON);
        [[AppDelegate user] setUsername:[JSON objectForKey:@"username"]];
        if (completionBlock) {
            completionBlock(Nil);
        }
        
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error = %@", error);
        [[AppDelegate user] setErrorInfo:@"username has already been taken"];
        if (completionBlock) {
            completionBlock(error);
        }
    }];
    
    [operation start];
}

+ (void) requestForCall:(void (^)(NSError *error))completionBlock{
    
    OMHTTPClient *client = [OMHTTPClient sharedClient];
    
    NSString *username = [[AppDelegate user] phoneNumer];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:username, @"username",nil];
    
    NSString *path = [NSString stringWithFormat:@"request_for_call.json"];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:parameters];
    [request setTimeoutInterval:20.0];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //        NSString *error = [JSON objectForKey:@"errors"];
        //        if (error) {
        //            [[AppDelegate user] setErrorInfo:@"phone number invalid"];
        //        } else {
        //            NSLog(@"Login is successfull");
        //            [[AppDelegate user] setErrorInfo:Nil];
        //            NSLog(@"json values %@", JSON);
        //        }
        if (completionBlock) {
            completionBlock(Nil);
        }
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error = %@", error);
        if (completionBlock) {
            completionBlock(error);
        }
    }];
    [operation start];
}

+ (void) sendMessageWithCompletionBlock:(void (^)(NSError *error))completionBlock withMessage:(NSDictionary *)message{
    OMHTTPClient *client = [OMHTTPClient sharedClient];
    
    NSString *deviceToken;
    if ([[AppDelegate appDelegate] device_token]) {
        deviceToken = [[AppDelegate appDelegate] device_token];
    }else{
        deviceToken = @"";
    }
    
    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys:message, @"message", nil];
    
    NSString *path = [NSString stringWithFormat:@"messages.json"];
    
   
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:path parameters:params];
    [request setTimeoutInterval:20.0];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray *error = [JSON objectForKey:@"errors"];
        if (error) {
            [[AppDelegate user] setErrorInfo:@"phone number invalid"];
        } else {
            NSLog(@"Login is successfull");
            [[AppDelegate user] setErrorInfo:Nil];
//            NSLog(@"json values %@", JSON);
//            [[AppDelegate user] setId:[NSString stringWithFormat:@"%d",[[JSON objectForKey:@"id"] intValue]]];
        }
        if (completionBlock) {
            completionBlock(Nil);
        }
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error = %@", error);
        [[AppDelegate user] setErrorInfo:@"phone number has already been taken"];
        if (completionBlock) {
            completionBlock(error);
        }
    }];
    [operation start];

}

+ (void) fetchutuContacts{
    NSLog(@"fetch contacts");
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        CFErrorRef *error = NULL;
        
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL,error);
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                if (granted) {
                    // First time access has been granted, add the contact
                } else {
                    // User denied access
                    // Display an alert telling user the contact could not be added
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alert = [[UIAlertView alloc]
                                              initWithTitle: @"Oops!!"
                                              message: @"Change your contacts privacy settings for utu app access your local conatcts."
                                              delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                        [alert show];
                    });
                }
            });
        }
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            // The user has previously given access, add the contact
        }
        else {
            // The user has previously denied access
            // Send an alert telling user to change privacy setting in settings app
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //                UIAlertView *alert = [[UIAlertView alloc]
            //                                      initWithTitle: @"Privacy request"
            //                                      message: @"change privacy setting in settings app."
            //                                      delegate:nil
            //                                      cancelButtonTitle:@"OK"
            //                                      otherButtonTitles:nil];
            //                [alert show];
            //            });
        }
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
            CFArrayRef sortedPeople =(CFArrayRef)ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName);
            
            //RETRIEVING THE FIRST NAME AND PHONE NUMBER FROM THE ADDRESS BOOK
            
            CFIndex number = CFArrayGetCount(sortedPeople);
            
            NSString *firstName;
            NSString *phoneNumber ;
            
            if (![AppDelegate user].phoneContacts) {
                [AppDelegate user].phoneContacts = [[NSMutableDictionary alloc] init];
            }
            
            if (![AppDelegate user].utuContacts) {
                [AppDelegate user].utuContacts = [[NSMutableDictionary alloc] init];
            }
            
            if (![AppDelegate user].localContacts) {
                [AppDelegate user].localContacts = [[NSMutableDictionary alloc] init];
            }
            
            if (![AppDelegate user].localContactsKeys) {
                [AppDelegate user].localContactsKeys = [[NSMutableArray alloc] init];
            }
            
            NSMutableDictionary *tempLocalContacts = [[NSMutableDictionary alloc] init];
            NSMutableArray *tempLocalContactskeys = [[NSMutableArray alloc] init];
            
            NSString *numberstring = @"";
            
            for( int i=1;i<=number;i++)
            {
                ABRecordRef person = CFArrayGetValueAtIndex(sortedPeople, i - 1);
                firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
                ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
                
                for(CFIndex j = 0; j < ABMultiValueGetCount(phones); j++) {
                    phoneNumber = (__bridge NSString *) ABMultiValueCopyValueAtIndex(phones, j);
//                    NSLog(@"number %@", phoneNumber);
                    
                    phoneNumber = (__bridge NSString *) ABMultiValueCopyValueAtIndex(phones, j);
                    
                    if(phoneNumber != NULL && phoneNumber.length > 7)
                    {
                        //            NSString *number = phoneNumber;
                        //            number = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
                        //            number = [number stringByReplacingOccurrencesOfString:@"(" withString:@""];
                        //            number = [number stringByReplacingOccurrencesOfString:@")" withString:@""];
                        //            number = [number stringByReplacingOccurrencesOfString:@"-" withString:@""];
                        
                        NSString *tempnumber = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
                        
                        NSString *trimmedString = [tempnumber substringFromIndex:MAX((int)[tempnumber length]-8, 0)];
                        
                        if (j > 0) {
                            if (firstName) {
                                firstName = [NSString stringWithFormat:@"%@%ld",firstName,j];
                            }else{
                                firstName = [NSString stringWithFormat:@"No Name%ld",j];
                            }
                        }
                        NSMutableDictionary *localContact = [[NSMutableDictionary alloc] init];
                        if (firstName) {
                            [localContact setObject:firstName forKey:@"name"];
                        }else{
                            [localContact setObject:@"No Name" forKey:@"name"];
                        }
                        if (trimmedString) {
                            [localContact setObject:trimmedString forKey:@"number"];
                        }
                        if (phoneNumber) {
                            [localContact setObject:phoneNumber forKey:@"original_number"];
                        }
                        
//                        NSMutableDictionary *localContact = [[NSMutableDictionary alloc] init];
//                        [localContact setObject:firstName forKey:@"name"];
//                        [localContact setObject:trimmedString forKey:@"number"];
//                        [localContact setObject:phoneNumber forKey:@"original_number"];
                        
                        //                [[[AppDelegate user] localContacts] removeObjectForKey:trimmedString];
                        
                        [tempLocalContacts setObject:localContact forKey:trimmedString];
                        [tempLocalContactskeys addObject:trimmedString];
                        
                        numberstring = [numberstring stringByAppendingString:[NSString stringWithFormat:@"%@,",trimmedString]];
                    }
                    
                    if (i == 100) {
                        [[[AppDelegate user] phoneContacts] setObject:numberstring forKey:[NSString stringWithFormat:@"%d",i]];
                        numberstring = @"";
                    }
                    
                    if (i == 200) {
                        [[[AppDelegate user] phoneContacts] setObject:numberstring forKey:[NSString stringWithFormat:@"%d",i]];
                        numberstring = @"";
                    }
                    
                    if (i == 300) {
                        [[[AppDelegate user] phoneContacts] setObject:numberstring forKey:[NSString stringWithFormat:@"%d",i]];
                        numberstring = @"";
                    }
                    
                    if (i == 400) {
                        [[[AppDelegate user] phoneContacts] setObject:numberstring forKey:[NSString stringWithFormat:@"%d",i]];
                        numberstring = @"";
                    }
                    
                    if (i == 500) {
                        [[[AppDelegate user] phoneContacts] setObject:numberstring forKey:[NSString stringWithFormat:@"%d",i]];
                        numberstring = @"";
                    }
                    
                    if (i == 600) {
                        [[[AppDelegate user] phoneContacts] setObject:numberstring forKey:[NSString stringWithFormat:@"%d",i]];
                        numberstring = @"";
                    }
                    
                    if (i == 700) {
                        [[[AppDelegate user] phoneContacts] setObject:numberstring forKey:[NSString stringWithFormat:@"%d",i]];
                        numberstring = @"";
                    }
                    
                    if (i == 800) {
                        [[[AppDelegate user] phoneContacts] setObject:numberstring forKey:[NSString stringWithFormat:@"%d",i]];
                        numberstring = @"";
                    }
                    
                    if (i == 900) {
                        [[[AppDelegate user] phoneContacts] setObject:numberstring forKey:[NSString stringWithFormat:@"%d",i]];
                        numberstring = @"";
                    }
                    
                    if (i == 1000) {
                        [[[AppDelegate user] phoneContacts] setObject:numberstring forKey:[NSString stringWithFormat:@"%d",i]];
                        numberstring = @"";
                    }
                    
                    if (number == i) {
                        [[[AppDelegate user] phoneContacts] setObject:numberstring forKey:[NSString stringWithFormat:@"%d",i]];
                    }
                }
                
            }
            
            [AppDelegate user].localContacts = tempLocalContacts;
            [AppDelegate user].localContactsKeys = tempLocalContactskeys;
            
//            NSLog(@"contact %@",[[AppDelegate user] phoneContacts]);
//            
//            NSLog(@"contact %@",[[AppDelegate user] localContacts]);
        
            for (NSString *key in [[AppDelegate user] phoneContacts]) {
//                NSLog(@"contacts%@",[[[AppDelegate user] phoneContacts] objectForKey:key]);
                NSString *urlString = [NSString stringWithFormat:@"http://54.255.206.204:3000/get_all_contacts.json?contacts=%@",[[[AppDelegate user] phoneContacts] objectForKey:key]];
                NSURL *url = [NSURL URLWithString:urlString];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                
                NSDictionary *_headers = [NSDictionary dictionaryWithObjectsAndKeys:@"application/json", @"accept", nil];
                
                [request setAllHTTPHeaderFields:_headers];
                
                NSURLResponse * response = nil;
                NSError * error = nil;
                
                NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                
                if (error == nil) {
                    NSError *_errorJson = nil;
                    NSMutableArray *serializesJSONDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
                    //                    [AppDelegate user].utuContacts = [[NSMutableArray alloc] init];
                    if (serializesJSONDict.count > 0) {
                        for (int i=0; i< serializesJSONDict.count; i++) {
                            NSDictionary *tempContact = [serializesJSONDict objectAtIndex:i];
                            NSMutableDictionary *contact = [[NSMutableDictionary alloc] init];
                            NSString *idString = [NSString stringWithFormat:@"%d",[[[tempContact objectForKey:@"user"] objectForKey:@"id"] intValue]];
                            
                            if ([[[AppDelegate user] utuContacts] objectForKey:idString]) {
                                contact = [[[AppDelegate user] utuContacts] objectForKey:idString];
                            }
                            
                            if ([tempContact objectForKey:@"profile"] != [NSNull null]) {
                                [contact setValue:[[tempContact objectForKey:@"profile"] objectForKey:@"username"] forKey:@"name"];
                                [contact setValue:[[tempContact objectForKey:@"profile"] objectForKey:@"status"] forKey:@"status"];
                                [contact setValue:[[tempContact objectForKey:@"profile"] objectForKey:@"image_url"] forKey:@"image_url"];
                            }else{
                                [contact setValue:@"No Name" forKey:@"name"];
                                [contact setValue:@"https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQIt0gn1GXEfnSlJtRUWh0r1aVXJYL9X8X1DAcUp1XAUTBSH0yFFA" forKey:@"image_url"];
                            }
                            
                            NSString *tempNumber = [NSString stringWithFormat:@"+%@",[[tempContact objectForKey:@"user"] objectForKey:@"username"]];
                            
                            tempNumber = [tempNumber substringFromIndex:MAX((int)[tempNumber length]-8, 0)];
                            
                            if ([[[AppDelegate user] localContacts] objectForKey:tempNumber]) {
                                NSMutableDictionary *localContact = [[[AppDelegate user] localContacts] objectForKey:tempNumber];
                                [contact setValue:[localContact objectForKey:@"name"] forKey:@"name"];
                                [localContact setObject:idString forKey:@"id"];
                                
                                [[[AppDelegate user] localContacts] removeObjectForKey:tempNumber];
                                [[[AppDelegate user] localContacts] setObject:localContact forKey:tempNumber];
                            }
                            
                            [contact setValue:idString forKey:@"id"];
                            [contact setValue:[NSString stringWithFormat:@"+%@",[[tempContact objectForKey:@"user"] objectForKey:@"username"]] forKey:@"number"];
                            
                            //                        if (![[AppDelegate user] utuContacts]) {
                            //                            [AppDelegate user].utuContacts = [[NSMutableDictionary alloc] init];
                            //                        }
                            //                        if (![[[AppDelegate user] utuContacts] objectForKey:idString]) {
                            [[[AppDelegate user] utuContacts] setObject:contact forKey:idString];
                            if ([[[AppDelegate user] temputuContacts] objectForKey:idString]) {
                                [[[AppDelegate user] temputuContacts] setObject:contact forKey:idString];
                            }
                            //                        }
                        }
                        
//                        NSLog(@"contact %@",[[AppDelegate user] localContacts]);
                        
                        [[AppDelegate user] saveStateInUserDefaults];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadContactsView" object:Nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadFriendsView" object:Nil];
                        NSLog(@"utu contacts%@",[[AppDelegate user] utuContacts]);
                        //                    NSMutableDictionary *contact = [[NSMutableDictionary alloc] init];
                        //                    NSString *idString = [NSString stringWithFormat:@"%d",[[[serializesJSONDict objectForKey:@"user"] objectForKey:@"id"] intValue]];
                        //                    [contact setValue:idString forKey:@"id"];
                        //                    [contact setValue:firstName forKey:@"name"];
                        //                    [contact setValue:phoneNumber forKey:@"number"];
                        //                    //                        [contact setValue:phoneNumber forKey:@"picture"];
                        //
                        //                    [[[AppDelegate user] utuContacts] setObject:contact forKey:idString];
                        //                    [[AppDelegate user] saveStateInUserDefaults];
                    }
                    if (_errorJson != nil) {
                        NSLog(@"Load Error %@", [_errorJson localizedDescription]);
                    } else {
                        NSLog(@"success ");
                        
                    }
                } else {
                    NSLog(@"Error while getting data");
                }
                
            }
        }
    });
}

 + (NSArray*)addressBookLoader
{
    CFErrorRef *error = NULL;
    
    NSMutableArray *arrayofAddressClassObjects =[[NSMutableArray alloc]init];
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL,error);
    
    ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
    CFArrayRef sortedPeople =ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName);
    
    //RETRIEVING THE FIRST NAME AND PHONE NUMBER FROM THE ADDRESS BOOK
    
    CFIndex number = CFArrayGetCount(sortedPeople);
    
    NSString *firstName;
    NSString *phoneNumber ;
    
    for( int i=0;i<number;i++)
    {
        
        ABRecordRef person = CFArrayGetValueAtIndex(sortedPeople, i);
        firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        phoneNumber = (__bridge NSString *) ABMultiValueCopyValueAtIndex(phones, 0);
        
        if(phoneNumber != NULL)
        {
            
        }
        
        
    }
    
    NSLog(@"x=%@",arrayofAddressClassObjects);
    
    return arrayofAddressClassObjects;
    
}

+ (void) pullMessageWithCompletionBlock:(void (^)(NSError *error))completionBlock{
    OMHTTPClient *client = [OMHTTPClient sharedClient];
    
    NSString *userId = [[AppDelegate user] id];
    NSString *contactId = [[AppDelegate user] contactId];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"user_id",contactId, @"contact_id",nil];
    
    NSString *path = [NSString stringWithFormat:@"messages.json"];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:parameters];
    [request setTimeoutInterval:20.0];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSLog(@"Login is successfull");
        NSArray * messagesJson = JSON;
        NSMutableArray *messages = [[NSMutableArray alloc] init];
        messages = [NSMutableArray arrayWithArray:messagesJson];
        [[AppDelegate user] setContactMessages:messages];
        [[NSUserDefaults standardUserDefaults] setObject:[[AppDelegate user] contactMessages]  forKey:contactId];
        if (completionBlock) {
            completionBlock(Nil);
        }
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error = %@", error);
        if (completionBlock) {
            completionBlock(error);
        }
    }];
    [operation start];
}

+ (void) fetchMessageWithCompletionBlock:(void (^)(NSError *error))completionBlock user:(NSString *)userId contact:(NSString *)contactId{
    OMHTTPClient *client = [OMHTTPClient sharedClient];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"user_id",contactId, @"contact_id",nil];
    
    NSString *path = [NSString stringWithFormat:@"messages.json"];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:parameters];
    [request setTimeoutInterval:20.0];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"Login is successfull");
        NSArray * messagesJson = JSON;
        NSMutableArray *messages = [[NSMutableArray alloc] init];
        messages = [NSMutableArray arrayWithArray:messagesJson];
        [[AppDelegate user] setContactMessages:messages];
        [[NSUserDefaults standardUserDefaults] setObject:[[AppDelegate user] contactMessages]  forKey:contactId];
        if (completionBlock) {
            completionBlock(Nil);
        }
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error = %@", error);
        if (completionBlock) {
            completionBlock(error);
        }
    }];
    [operation start];
}

+ (void) checkUnreadMessage{
    
    NSArray *keys = [[[AppDelegate user] utuContacts] allKeys];
    
    for (int i=0; i<keys.count; i++) {
        NSMutableDictionary *contact = [[[AppDelegate user] utuContacts] objectForKey:[keys objectAtIndex:i]];
        
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSString *urlString = [NSString stringWithFormat:@"http://54.255.206.204:3000/check_unread_message.json?user_id=%@&contact_id=%@",[[AppDelegate user] id],[keys objectAtIndex:i]];
            NSURL *url = [NSURL URLWithString:urlString];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            
            NSDictionary *_headers = [NSDictionary dictionaryWithObjectsAndKeys:@"application/json", @"accept", nil];
            
            [request setAllHTTPHeaderFields:_headers];
            
            NSURLResponse * response = nil;
            NSError * error = nil;
            
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            if (error == nil) {
                NSError *_errorJson = nil;
                NSMutableDictionary *serializesJSONDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
                //                    [AppDelegate user].utuContacts = [[NSMutableArray alloc] init];
                if (![serializesJSONDict objectForKey:@"errors"]) {
                    NSString *count = [NSString stringWithFormat:@"%d",[[serializesJSONDict objectForKey:@"unread_count"] intValue]];
                    [contact setValue:count  forKey:@"count"];
                    
                    [[[AppDelegate user] utuContacts] removeObjectForKey:[keys objectAtIndex:i]];
                    [[[AppDelegate user] utuContacts] setObject:contact forKey:[keys objectAtIndex:i]];
                    [[AppDelegate user] saveStateInUserDefaults];
                }
                if (_errorJson != nil) {
                    NSLog(@"Load Error %@", [_errorJson localizedDescription]);
                } else {
                    NSLog(@"success ");
                    
                }
            } else {
                NSLog(@"Error while getting data");
            }
            
        });
    }
}

+ (void) readMessages{
    
    NSMutableDictionary *contact = [[[AppDelegate user] utuContacts] objectForKey:[[AppDelegate user] contactId]];
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSString *urlString = [NSString stringWithFormat:@"http://54.255.206.204:3000/read_all_message.json?user_id=%@&contact_id=%@",[[AppDelegate user] id],[[AppDelegate user] contactId]];
            NSURL *url = [NSURL URLWithString:urlString];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            
            NSDictionary *_headers = [NSDictionary dictionaryWithObjectsAndKeys:@"application/json", @"accept", nil];
            
            [request setAllHTTPHeaderFields:_headers];
            
            NSURLResponse * response = nil;
            NSError * error = nil;
            
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            if (error == nil) {
                NSError *_errorJson = nil;
                NSMutableDictionary *serializesJSONDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
                //                    [AppDelegate user].utuContacts = [[NSMutableArray alloc] init];
                if (![serializesJSONDict objectForKey:@"errors"]) {
                    NSString *count = @"0";
                    [contact setValue:count  forKey:@"count"];
                    
                    [[[AppDelegate user] utuContacts] removeObjectForKey:[[AppDelegate user] contactId]];
                    [[[AppDelegate user] utuContacts] setObject:contact forKey:[[AppDelegate user] contactId]];
                    [[AppDelegate user] saveStateInUserDefaults];
                }
                if (_errorJson != nil) {
                    NSLog(@"Load Error %@", [_errorJson localizedDescription]);
                } else {
                    NSLog(@"success ");
                    
                }
            } else {
                NSLog(@"Error while getting data");
            }
            
        });
}

+ (void) addContact:(NSString *)contactId{
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString *urlString = [NSString stringWithFormat:@"http://54.255.206.204:3000/get_contact.json?contact_id=%@",contactId];
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        NSDictionary *_headers = [NSDictionary dictionaryWithObjectsAndKeys:@"application/json", @"accept", nil];
        
        [request setAllHTTPHeaderFields:_headers];
        
        NSURLResponse * response = nil;
        NSError * error = nil;
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if (error == nil) {
            NSError *_errorJson = nil;
            NSMutableDictionary *serializesJSONDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
            //                    [AppDelegate user].utuContacts = [[NSMutableArray alloc] init];
            if (![serializesJSONDict objectForKey:@"errors"]) {
                NSDictionary *contact = [[NSMutableDictionary alloc] init];
                NSString *idString = [NSString stringWithFormat:@"%d",[[[serializesJSONDict objectForKey:@"user"] objectForKey:@"id"] intValue]];
                
                if ([serializesJSONDict objectForKey:@"profile"] != [NSNull null] && [serializesJSONDict objectForKey:@"profile"]) {
                    [contact setValue:[[serializesJSONDict objectForKey:@"profile"] objectForKey:@"username"] forKey:@"name"];
                    [contact setValue:[[serializesJSONDict objectForKey:@"profile"] objectForKey:@"image_url"] forKey:@"image_url"];
                }else{
                    [contact setValue:@"No Name" forKey:@"name"];
                    [contact setValue:@"https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQIt0gn1GXEfnSlJtRUWh0r1aVXJYL9X8X1DAcUp1XAUTBSH0yFFA" forKey:@"image_url"];
                }
                [contact setValue:idString forKey:@"id"];
                [contact setValue:[[serializesJSONDict objectForKey:@"user"] objectForKey:@"username"] forKey:@"number"];
                //                        [contact setValue:phoneNumber forKey:@"picture"];
                
                if (![[AppDelegate user] utuContacts]) {
                    [AppDelegate user].utuContacts = [[NSMutableDictionary alloc] init];
                }
                if (![[AppDelegate user] temputuContacts]) {
                    [AppDelegate user].temputuContacts = [[NSMutableDictionary alloc] init];
                }
                if (![[[AppDelegate user] utuContacts] objectForKey:idString]) {
                    [[[AppDelegate user] utuContacts] setObject:contact forKey:idString];
                    [[[AppDelegate user] temputuContacts] setObject:contact forKey:idString];
                    [[AppDelegate user] saveStateInUserDefaults];
                }
                
                //            }else{
                //                UIAlertView *alert = [[UIAlertView alloc]
                //                                      initWithTitle: @"Ooops!"
                //                                      message: @"User not found!"
                //                                      delegate:nil
                //                                      cancelButtonTitle:@"OK"
                //                                      otherButtonTitles:nil];
                //                [alert show];
            }
            if (_errorJson != nil) {
                //                NSLog(@"Load Error %@", [_errorJson localizedDescription]);
                //                UIAlertView *alert = [[UIAlertView alloc]
                //                                      initWithTitle: @"Validation error"
                //                                      message: @"some thing went wrong"
                //                                      delegate:nil
                //                                      cancelButtonTitle:@"OK"
                //                                      otherButtonTitles:nil];
                //                [alert show];
            } else {
                NSLog(@"success ");
                
            }
        } else {
            NSLog(@"Error while getting data");
            //            UIAlertView *alert = [[UIAlertView alloc]
            //                                  initWithTitle: @"some thing went wrong"
            //                                  message: [[AppDelegate user] errorInfo]
            //                                  delegate:nil
            //                                  cancelButtonTitle:@"OK"
            //                                  otherButtonTitles:nil];
            //            [alert show];
        }
    });
}

+ (void) rewardRedeme:(NSString *)points withType:(NSString *)type quantitiy:(NSString *)quantitiy name:(NSString *)name{
    OMHTTPClient *client = [OMHTTPClient sharedClient];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[[AppDelegate user] id], @"user_id", type, @"reward_type", points, @"reward_points", quantitiy, @"quantity", name, @"redeemed_type",nil];
    
    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys:parameters, @"reward_history", nil];
    
    NSString *path = [NSString stringWithFormat:@"reward_histories.json"];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:path parameters:params];
    [request setTimeoutInterval:20.0];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        NSArray *error = [JSON objectForKey:@"errors"];
//        if (error) {
//            [[AppDelegate user] setErrorInfo:@"phone number invalid"];
//        } else {
//            NSLog(@"Login is successfull");
//            [[AppDelegate user] setErrorInfo:Nil];
//            NSLog(@"json values %@", JSON);
//            [[AppDelegate user] setId:[NSString stringWithFormat:@"%d",[[JSON objectForKey:@"id"] intValue]]];
//        }
//        if (completionBlock) {
//            completionBlock(Nil);
//        }
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error = %@", error);
//        [[AppDelegate user] setErrorInfo:@"phone number has already been taken"];
//        if (completionBlock) {
//            completionBlock(error);
//        }
    }];
    [operation start];
}

+ (void) pointsHistoryWithCompletionBlock:(void (^)(NSError *error))completionBlock{

    OMHTTPClient *client = [OMHTTPClient sharedClient];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[[AppDelegate user] id], @"user_id",nil];
    
    NSString *path = [NSString stringWithFormat:@"profiles/points_history.json"];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:parameters];
    [request setTimeoutInterval:20.0];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        NSLog(@"Login is successfull");
//        NSArray * messagesJson = JSON;
//        NSMutableArray *messages = [[NSMutableArray alloc] init];
//        messages = [NSMutableArray arrayWithArray:messagesJson];
//        [[AppDelegate user] setContactMessages:messages];
//        [[NSUserDefaults standardUserDefaults] setObject:[[AppDelegate user] contactMessages]  forKey:contactId];
        [AppDelegate user].pointsHistory = [[NSMutableDictionary alloc] init];
        [[AppDelegate user] setPointsHistory:JSON];
        if (completionBlock) {
            completionBlock(Nil);
        }
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error = %@", error);
        if (completionBlock) {
            completionBlock(error);
        }
    }];
    [operation start];
}

+ (void) redeemHistoryWithCompletionBlock:(void (^)(NSError *error))completionBlock{
    
    OMHTTPClient *client = [OMHTTPClient sharedClient];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[[AppDelegate user] id], @"user_id",nil];
    
    NSString *path = [NSString stringWithFormat:@"reward_histories.json"];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:parameters];
    [request setTimeoutInterval:20.0];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [AppDelegate user].redeemHistory = [[NSMutableArray alloc] init];
        [[AppDelegate user] setRedeemHistory:JSON];
        if (completionBlock) {
            completionBlock(Nil);
        }
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error = %@", error);
        if (completionBlock) {
            completionBlock(error);
        }
    }];
    [operation start];
}

+ (void) redeemOptionsWithCompletionBlock:(void (^)(NSError *error))completionBlock{
    OMHTTPClient *client = [OMHTTPClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"redeem_options.json"];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:Nil];
    [request setTimeoutInterval:20.0];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [AppDelegate user].redeemOptions = [[NSMutableArray alloc] init];
        [[AppDelegate user] setRedeemOptions:JSON];
        [[AppDelegate user] saveStateInUserDefaults];
        if (completionBlock) {
            completionBlock(Nil);
        }
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error = %@", error);
        if (completionBlock) {
            completionBlock(error);
        }
    }];
    [operation start];
}

+ (void) charitiesWithCompletionBlock:(void (^)(NSError *error))completionBlock{
    OMHTTPClient *client = [OMHTTPClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"charities.json"];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:Nil];
    [request setTimeoutInterval:20.0];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [AppDelegate user].charities = [[NSMutableArray alloc] init];
        [[AppDelegate user] setCharities:JSON];
        [[AppDelegate user] saveStateInUserDefaults];
        if (completionBlock) {
            completionBlock(Nil);
        }
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error = %@", error);
        if (completionBlock) {
            completionBlock(error);
        }
    }];
    [operation start];
}

+ (void) addcharityPoints:(NSString *)charityId withPoints:(NSString *)points
{
    OMHTTPClient *client = [OMHTTPClient sharedClient];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[[AppDelegate user] id], @"user_id", charityId, @"charity_id", points, @"points",nil];
    
    NSString *path = [NSString stringWithFormat:@"add_charity_points.json"];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:parameters];
    [request setTimeoutInterval:20.0];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error = %@", error);
    }];
    [operation start];
}

+ (void) getChannels{
    OMHTTPClient *client = [OMHTTPClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"channels.json"];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:Nil];
    [request setTimeoutInterval:20.0];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [AppDelegate user].channels = [[NSMutableArray alloc] init];
        [[AppDelegate user] setChannels:JSON];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadchannels" object:Nil];
        if ([[[AppDelegate user] channels] count] > 0 ) {
            NSDictionary *channelinfo = [[[AppDelegate user] channels] objectAtIndex:0];
            [[AppDelegate user] setSelectedChannel:[channelinfo objectForKey:@"name"]];
            [AFUser getShows:[NSString stringWithFormat:@"%d", [[channelinfo objectForKey:@"id"] integerValue]]];
            [[AppDelegate user] saveStateInUserDefaults];
        }
//        if (completionBlock) {
//            completionBlock(Nil);
//        }
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error = %@", error);
//        if (completionBlock) {
//            completionBlock(error);
//        }
    }];
    [operation start];
}

+ (void) getShows:(NSString *)channelId{
    OMHTTPClient *client = [OMHTTPClient sharedClient];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:channelId, @"channel_id",nil];
    
    NSString *path = [NSString stringWithFormat:@"channel_shows.json"];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:parameters];
    [request setTimeoutInterval:20.0];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [AppDelegate user].selectedShows = [[NSMutableArray alloc] init];
        [[AppDelegate user] setSelectedShows:JSON];
        [[AppDelegate user] saveStateInUserDefaults];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadprograms" object:Nil];
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error = %@", error);
    }];
    [operation start];
}


+ (void) addShowToFav:(NSString *)showId{
    OMHTTPClient *client = [OMHTTPClient sharedClient];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[[AppDelegate user] id],@"user_id",showId, @"show_id",nil];
    
    NSString *path = [NSString stringWithFormat:@"add_to_faviorites.json"];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:parameters];
    [request setTimeoutInterval:20.0];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        UIAlertView *newAlert = [[UIAlertView alloc]
                                 initWithTitle: @"Success"
                                 message: @"This show is added to your favorites."
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [newAlert show];
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error = %@", error);
    }];
    [operation start];
}

+ (void) removeShowFromFav:(NSString *)showId{
    OMHTTPClient *client = [OMHTTPClient sharedClient];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[[AppDelegate user] id],@"user_id",showId, @"show_id",nil];
    
    NSString *path = [NSString stringWithFormat:@"remove_from_faviorites.json"];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:parameters];
    [request setTimeoutInterval:20.0];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request     success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error = %@", error);
    }];
    [operation start];
}

+ (void) searchShowsWithCompletionBlock:(void (^)(NSError *error))completionBlock text:(NSString *)searchText;{
    OMHTTPClient *client = [OMHTTPClient sharedClient];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:searchText, @"searchText",nil];
    
    NSString *path = [NSString stringWithFormat:@"shows.json"];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:parameters];
    [request setTimeoutInterval:20.0];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [AppDelegate user].searchResults = [[NSMutableArray alloc] init];
        [[AppDelegate user] setSearchResults:JSON];
        if (completionBlock) {
            completionBlock(Nil);
        }
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error = %@", error);
        if (completionBlock) {
            completionBlock(error);
        }
    }];
    [operation start];
}


+ (void) userFavShowsWithCompletionBlock:(void (^)(NSError *error))completionBlock;{
    OMHTTPClient *client = [OMHTTPClient sharedClient];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[[AppDelegate user] id], @"user_id",nil];
    
    NSString *path = [NSString stringWithFormat:@"user_faviorites.json"];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:parameters];
    [request setTimeoutInterval:20.0];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [AppDelegate user].favShows = [[NSMutableArray alloc] init];
        [[AppDelegate user] setFavShows:JSON];
        if (completionBlock) {
            completionBlock(Nil);
        }
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error = %@", error);
        if (completionBlock) {
            completionBlock(error);
        }
    }];
    [operation start];
}

+ (void) userRequests:(NSString *)contact_number{
    OMHTTPClient *client = [OMHTTPClient sharedClient];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[[AppDelegate user] id], @"user_id", [NSString stringWithFormat:@"%@",contact_number], @"conatct_number",nil];
    
    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys:parameters, @"user_request", nil];
    
    NSString *path = [NSString stringWithFormat:@"user_requests.json"];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:path parameters:params];
    [request setTimeoutInterval:20.0];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //        NSArray *error = [JSON objectForKey:@"errors"];
        //        if (error) {
        //            [[AppDelegate user] setErrorInfo:@"phone number invalid"];
        //        } else {
        //            NSLog(@"Login is successfull");
        //            [[AppDelegate user] setErrorInfo:Nil];
        //            NSLog(@"json values %@", JSON);
        //            [[AppDelegate user] setId:[NSString stringWithFormat:@"%d",[[JSON objectForKey:@"id"] intValue]]];
        //        }
        //        if (completionBlock) {
        //            completionBlock(Nil);
        //        }
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error = %@", error);
        //        [[AppDelegate user] setErrorInfo:@"phone number has already been taken"];
        //        if (completionBlock) {
        //            completionBlock(error);
        //        }
    }];
    [operation start];
}

+ (void) getContactProfileWithCompletionBlock:(void (^)(NSError *error))completionBlock{
    OMHTTPClient *client = [OMHTTPClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"get_contact_profile.json?contact_id=%@",[[AppDelegate user] contactId]];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:Nil];
    [request setTimeoutInterval:20.0];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [AppDelegate user].contactProfile = [[NSMutableDictionary alloc] init];
        [[AppDelegate user] setContactProfile:JSON];
        if (completionBlock) {
            completionBlock(Nil);
        }
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error = %@", error);
        if (completionBlock) {
            completionBlock(error);
        }
    }];
    [operation start];
}

@end
