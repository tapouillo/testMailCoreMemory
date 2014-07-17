//
//  AppDelegate.m
//  testMailCoreMemory
//
//  Created by Stéphane QUERAUD on 16/07/2014.
//  Copyright (c) 2014 Stéphane QUERAUD. All rights reserved.
//

#import "AppDelegate.h"
#import <MailCore/MailCore.h>

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}


-(IBAction) pressButton:(id)sender
{
    NSLog(@"press button");
    int maxEmails = 10;
    NSString *folder = @"INBOX";
    MCOIMAPMessagesRequestKind kind =  MCOIMAPMessagesRequestKindUid |
    MCOIMAPMessagesRequestKindFullHeaders |
    MCOIMAPMessagesRequestKindFlags |
    MCOIMAPMessagesRequestKindHeaders |
    MCOIMAPMessagesRequestKindInternalDate | MCOIMAPMessagesRequestKindGmailMessageID | MCOIMAPMessagesRequestKindStructure;
    
    
    __block MCOIMAPSession *session =  [[MCOIMAPSession alloc] init];
   
    [session setHostname:@"imap.gmail.com"];
    [session setPort:993];
    [session setUsername:@"email@gmail.com"];
    [session setPassword:@"password"];
    [session setConnectionType:MCOConnectionTypeTLS];
    
    MCOIMAPFolderInfoOperation *infoOperation = [session folderInfoOperation:folder];
    [infoOperation start:^(NSError *error, MCOIMAPFolderInfo *info)
     {
         
         uint64_t location = MAX([info messageCount] - maxEmails + 1, 1);
         uint64_t size = [info messageCount] < maxEmails ? [info messageCount] - 1 : maxEmails - 1;
         MCOIndexSet *numbers = [MCOIndexSet indexSetWithRange:MCORangeMake(location, size)];
         
         MCOIMAPFetchMessagesOperation *fetchOperation = [session fetchMessagesByNumberOperationWithFolder:folder requestKind:kind numbers:numbers];
         
         [fetchOperation start:^(NSError * error, NSArray * fetchedMessages, MCOIndexSet * vanishedMessages)
          {
             
              if(error)
              {
                      NSLog(@"Error downloading message headers:%@", error);
              }
              else
              {
                  for (MCOIMAPMessage * message in fetchedMessages)
                  {
                        NSLog(@"mail from: %@",message.header.from);
                      
                  }
                  
              }
              
              MCOIMAPOperation * op = [session disconnectOperation];
              [op start:^(NSError * error)
               {
                   
                   if (!error)
                   {
                       NSLog (@" disconnet ok, getmailcount and latest email");
                   }
                   session = nil;
                   
               }
               ];
         
          }];

     }];
}

@end
