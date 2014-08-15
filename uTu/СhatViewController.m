//
//  СhatViewController.m
//  sample-chat
//
//  Created by Igor Khomenko on 10/18/13.
//  Copyright (c) 2013 Igor Khomenko. All rights reserved.
//

#import "СhatViewController.h"
#import "ChatMessageTableViewCell.h"
#import "AppDelegate.h"
#import "UIFont+uTu.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, weak) IBOutlet UITextField *messageTextField;
@property (nonatomic, weak) IBOutlet UIButton *sendMessageButton;
@property (nonatomic, weak) IBOutlet UITableView *messagesTableView;

- (IBAction)sendMessage:(id)sender;

@end

@implementation ChatViewController{
    NSDateFormatter *dateFormatter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([[[UIDevice currentDevice] systemVersion] hasPrefix: @"7"]){
        UILabel *nav_titlelbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width,40)];
        nav_titlelbl.text=@"uTu Chat";
        nav_titlelbl.textAlignment=NSTextAlignmentCenter;
        nav_titlelbl.textColor = [UIColor whiteColor];
        nav_titlelbl.font = [UIFont Museo700Regular18];
        self.navigationItem.titleView=nav_titlelbl;
    }
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"h:mm a"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMessageView:) name:@"RelaodMessages" object:nil];
	// Do any additional setup after loading the view.
    
//    if(self.opponent != nil){
//        self.messages = [[LocalStorageService shared] messageHistoryWithUserID:self.opponent.ID];
//    }else{
//        self.messages = [NSMutableArray array];
//    }
    
    self.messagesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSInteger numberOfRows = [self.messagesTableView numberOfRowsInSection:0];
    if(numberOfRows > 0)
    {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.messagesTableView numberOfRowsInSection:0] - 1) inSection:0];
        [self.messagesTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    
    NSMutableDictionary *contact = [[[AppDelegate user] utuContacts] objectForKey:[[AppDelegate user] contactId]];
    
    if (contact) {
        if ([contact objectForKey:@"name"] && [contact objectForKey:@"name"] != [NSNull null]) {
            self.nameLabel.text = [contact objectForKey:@"name"];
        }else{
            self.nameLabel.text = [contact objectForKey:@"number"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *imageURL = [contact objectForKey:@"image_url"];
            if (imageURL){
                imageURL = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [self.profilePic setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"ola-mundo-icon.png"]];
            }
        });
    }
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(ClickEventOnName)];
    [tapRecognizer setDelegate:self];
    //Don't forget to set the userInteractionEnabled to YES, by default It's NO.
    self.nameLabel.userInteractionEnabled = YES;
    [self.nameLabel addGestureRecognizer:tapRecognizer];
    
    [self pullMessages];
    [AFUser readMessages];
    
    [UIView animateWithDuration:0.3 animations:^{
        if ([UIScreen mainScreen].bounds.size.height == 568) {
            
        }else{
            self.messagesTableView.frame = CGRectMake(self.messagesTableView.frame.origin.x,
                                                      self.messagesTableView.frame.origin.y,
                                                      self.messagesTableView.frame.size.width,
                                                      344);
            NSInteger numberOfRows = [self.messagesTableView numberOfRowsInSection:0];
            if(numberOfRows > 0)
            {
                NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.messagesTableView numberOfRowsInSection:0] - 1) inSection:0];
                [self.messagesTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }
    }];

    
}

-(void) ClickEventOnName
{
    NSLog(@"conatact prfile");
//    self.contactsProfileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactsProfileViewController"];
//    [self.navigationController pushViewController:self.contactsProfileViewController animated:YES];
    
    self.contactsProfileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactsProfileViewController"];
    [self.contactsProfileViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:self.contactsProfileViewController animated:YES completion:nil];
}

- (void) reloadMessageView:(NSNotification *) notification{
    [AFUser readMessages];
    [self.messagesTableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger numberOfRows = [self.messagesTableView numberOfRowsInSection:0];
        if(numberOfRows > 0)
        {
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.messagesTableView numberOfRowsInSection:0] - 1) inSection:0];
            [self.messagesTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    });
}

- (void)pullMessages{
    void(^pullMessagesCompletionBlock)(NSError *error) = ^void(NSError *error)
    {
        // hide the mbHud
        NSInteger numberOfRows = [self.messagesTableView numberOfRowsInSection:0];
        if(numberOfRows > 0)
        {
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.messagesTableView numberOfRowsInSection:0] - 1) inSection:0];
            [self.messagesTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        if (error) {
            NSLog(@"error %@",error);
            //show server error message.
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Server Error"
                                  message: @"Something went wrong. Please try again."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }else{
            [self.messagesTableView reloadData];
        }
    };
    
    if (pullMessagesCompletionBlock) {
        [AFUser pullMessageWithCompletionBlock:pullMessagesCompletionBlock];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Set keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    // Set chat notifications
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatDidReceiveMessageNotification:)
//                                                 name:kNotificationDidReceiveNewMessage object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatRoomDidReceiveMessageNotification:)
//                                                 name:kNotificationDidReceiveNewMessageFromRoom object:nil];
//    
//    // Set title
//    if(self.opponent != nil){
//        self.title = self.opponent.login;
//    }else if(self.chatRoom != nil){
//        self.title = self.chatRoom.name;
//    }
//    
//    
//    // Join room
//    if(self.chatRoom != nil && ![self.chatRoom isJoined]){
//        [[ChatService instance] joinRoom:self.chatRoom completionBlock:^(QBChatRoom *joinedChatRoom) {
//            // add the Admin to room
//            [joinedChatRoom addUsers:@[@291]];
//        }];
//    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
//    [self.chatRoom leaveRoom];
}

-(BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

#pragma mark
#pragma mark Actions

- (IBAction)sendMessage:(id)sender{
    if(self.messageTextField.text.length == 0){
        return;
    }
    
    NSString *message = self.messageTextField.text;
    
    NSDate *timeNow = [NSDate date];
    int date = [timeNow timeIntervalSince1970];
    NSString *datestring = [NSString stringWithFormat:@"%d",date];

    NSDictionary *messageDict = [NSDictionary dictionaryWithObjectsAndKeys:[[AppDelegate user] id],@"message_from",[[AppDelegate user] contactId],@"message_to",message,@"message",datestring,@"message_time",@"send",@"message_type",nil];
    
    [[[AppDelegate user] contactMessages] addObject:messageDict];
    [[NSUserDefaults standardUserDefaults] setObject:[[AppDelegate user] contactMessages]  forKey:[[AppDelegate user] contactId]];

    
    [self.messagesTableView reloadData];
    
    self.messageTextField.text = @"";
    
    void(^sendMessageCompletionBlock)(NSError *error) = ^void(NSError *error)
    {
        // hide the mbHud
        
        if (error) {
            NSLog(@"error %@",error);
            //show server error message.
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Server Error"
                                  message: @"Something went wrong. Please try again."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }else{
            [self.messagesTableView reloadData];
            NSInteger numberOfRows = [self.messagesTableView numberOfRowsInSection:0];
            if(numberOfRows > 0)
            {
                NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.messagesTableView numberOfRowsInSection:0] - 1) inSection:0];
                [self.messagesTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }
    };
    
    if (sendMessageCompletionBlock) {
        [AFUser sendMessageWithCompletionBlock:sendMessageCompletionBlock withMessage:messageDict];
    }
    
}


#pragma mark
#pragma mark Chat Notifications

- (void)chatDidReceiveMessageNotification:(NSNotification *)notification{
    
    // Reload table
    [self.messagesTableView reloadData];
    if(self.messages.count > 0){
        [self.messagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0]
                                      atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)chatRoomDidReceiveMessageNotification:(NSNotification *)notification{
//    QBChatMessage *message = notification.userInfo[kMessage];
//    NSString *roomName = notification.userInfo[kRoomName];
//    
//    if([self.chatRoom.JID rangeOfString:roomName].length <=0 ){
//        return;
//    }
//    
//    [self.messages addObject:message];
    
    // Reload table
    [self.messagesTableView reloadData];
    if(self.messages.count > 0){
        [self.messagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0]
                                      atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

#pragma mark
#pragma mark UITableViewDelegate & UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//	return [self.messages count];
    return [[[AppDelegate user] contactMessages] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *ChatMessageCellIdentifier = @"ChatMessageCellIdentifier";
//    
//    ChatMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatMessageCellIdentifier];
//    if(cell == nil){
//        cell = [[ChatMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChatMessageCellIdentifier];
//    }
    NSDictionary *message = [[[AppDelegate user] contactMessages] objectAtIndex:indexPath.row];
    
    ChatMessageTableViewCell *cell = [[ChatMessageTableViewCell alloc] init];
    
    NSTimeInterval interval = [[message objectForKey:@"message_time"] intValue];
    
    NSDate *date = [[NSDate date] dateByAddingTimeInterval:interval];
    
    [cell.dateLabel setText:[dateFormatter stringFromDate:date]];
    
    BOOL isleft;
    if ([[message objectForKey:@"message_type"] isEqualToString:@"send"]) {
        isleft = TRUE;
    }else{
        isleft = FALSE;
    }
    //
    [cell configureCellWithMessage:[message objectForKey:@"message"] is1To1Chat:isleft];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *message = [[[AppDelegate user] contactMessages] objectAtIndex:indexPath.row];
    BOOL isleft;
    if ([[message objectForKey:@"message_type"] isEqualToString:@"send"]) {
        isleft = TRUE;
    }else{
        isleft = FALSE;
    }
    CGFloat cellHeight = [ChatMessageTableViewCell heightForCellWithMessage:[message objectForKey:@"message"] is1To1Chat:isleft];
    return cellHeight;
}


#pragma mark
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    NSInteger numberOfRows = [self.messagesTableView numberOfRowsInSection:0];
    if(numberOfRows > 0)
    {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.messagesTableView numberOfRowsInSection:0] - 1) inSection:0];
        [self.messagesTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    return YES;
}


#pragma mark
#pragma mark Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)note
{
    [UIView animateWithDuration:0.3 animations:^{
        if ([UIScreen mainScreen].bounds.size.height == 568) {
            self.messageTextField.transform = CGAffineTransformMakeTranslation(0, -215);
            self.sendMessageButton.transform = CGAffineTransformMakeTranslation(0, -215);
            self.messagesTableView.frame = CGRectMake(self.messagesTableView.frame.origin.x,
                                                      self.messagesTableView.frame.origin.y,
                                                      self.messagesTableView.frame.size.width,
                                                      self.messagesTableView.frame.size.height-219);
            NSInteger numberOfRows = [self.messagesTableView numberOfRowsInSection:0];
            if(numberOfRows > 0)
            {
                NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.messagesTableView numberOfRowsInSection:0] - 1) inSection:0];
                [self.messagesTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }else{
            self.messageTextField.transform = CGAffineTransformMakeTranslation(0, -215);
            self.sendMessageButton.transform = CGAffineTransformMakeTranslation(0, -215);
            self.messagesTableView.frame = CGRectMake(self.messagesTableView.frame.origin.x,
                                                      self.messagesTableView.frame.origin.y,
                                                      self.messagesTableView.frame.size.width,
                                                      self.messagesTableView.frame.size.height-216);
            NSInteger numberOfRows = [self.messagesTableView numberOfRowsInSection:0];
            if(numberOfRows > 0)
            {
                NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.messagesTableView numberOfRowsInSection:0] - 1) inSection:0];
                [self.messagesTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }
		
    }];
}

- (void)keyboardWillHide:(NSNotification *)note
{
    [UIView animateWithDuration:0.3 animations:^{
        if ([UIScreen mainScreen].bounds.size.height == 568) {
            self.messageTextField.transform = CGAffineTransformIdentity;
            self.sendMessageButton.transform = CGAffineTransformIdentity;
            self.messagesTableView.frame = CGRectMake(self.messagesTableView.frame.origin.x,
                                                      self.messagesTableView.frame.origin.y,
                                                      self.messagesTableView.frame.size.width,
                                                      self.messagesTableView.frame.size.height+219);
            NSInteger numberOfRows = [self.messagesTableView numberOfRowsInSection:0];
            if(numberOfRows > 0)
            {
                NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.messagesTableView numberOfRowsInSection:0] - 1) inSection:0];
                [self.messagesTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }else{
            self.messageTextField.transform = CGAffineTransformIdentity;
            self.sendMessageButton.transform = CGAffineTransformIdentity;
            self.messagesTableView.frame = CGRectMake(self.messagesTableView.frame.origin.x,
                                                      40,
                                                      self.messagesTableView.frame.size.width,
                                                      360);
            NSInteger numberOfRows = [self.messagesTableView numberOfRowsInSection:0];
            if(numberOfRows > 0)
            {
                NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.messagesTableView numberOfRowsInSection:0] - 1) inSection:0];
                [self.messagesTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }
		
    }];
}

- (IBAction)addfriendTochatButton:(id)sender {
}

- (IBAction)moreOptionsButton:(id)sender {
}
@end
