//
//  ViewController.m
//  WordADay
//
//  Created by Lucas Steuber on 8/11/15.
//  Copyright (c) 2015 Lucas Steuber. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *word;
@property (weak, nonatomic) IBOutlet UILabel *definition;

@end

@implementation ViewController
- (IBAction)newWord:(id)sender {
    [self getNewWord];
}

- (IBAction)moreInfo:(id)sender {
    NSString *combo = [NSString stringWithFormat: @"http://dictionary.reference.com/browse/%@", self.word.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:combo]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getNewWord];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getNewWord {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filePath = [mainBundle pathForResource:@"dictionary" ofType:@"txt"];
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *values = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    
    NSUInteger randomIndex = arc4random() % [values count];
    NSString *word = values[randomIndex];

    NSString *urlp1 = @"http://api.wordnik.com:80/v4/word.json/";
    NSString *urlp2 = @"/definitions?limit=1&includeRelated=true&sourceDictionaries=wiktionary&useCanonical=false&includeTags=false&api_key=[WORDNIK API KEY]";
    
    NSString *combo = [NSString stringWithFormat: @"%@%@%@", urlp1, word, urlp2];
    NSURL *wordnik = [NSURL URLWithString: combo];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:wordnik
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];
    // Fetch the JSON response
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    NSError *jsonArrayError;
    NSString *desc;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: urlData options: NSJSONReadingMutableContainers error: &jsonArrayError];
    
    if (!jsonArray) {
        NSLog(@"Error parsing JSON: %@", jsonArrayError);
    } else {
        for(NSDictionary *myDict in jsonArray){
            desc = [myDict objectForKey:@"text"];
        }
    }

    
    self.word.text = word;
    self.definition.text = desc;
}
@end
