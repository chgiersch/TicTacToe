//
//  ViewController.m
//  MySafari
//
//  Created by Gabriel Borri de Azevedo on 1/7/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *networkActivityIndicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;


    //    self.urlTextField.delegate = self;
    [self loadWebPage:@"http://www.wikihow.com/Win-at-Tic-Tac-Toe"];
    self.backButton.enabled = false;
    //    [self.scrollView setScrollEnabled:YES];
    self.urlTextField.delegate = self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![textField.text hasPrefix:@"http://"])
    {
        NSString *httpString = @"http://";
        NSString *correctedString = [httpString stringByAppendingString:textField.text];
        [self loadWebPage:correctedString];
    }
    else
    {
        [self loadWebPage:textField.text];
    }
    self.backButton.enabled = true;
    return true;
}

-(void)loadWebPage:(NSString *)string
{
    NSURL *urlString = [NSURL URLWithString:string];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:urlString];
    [self.webView loadRequest:urlRequest];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    self.networkActivityIndicator.hidden = false;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.networkActivityIndicator.hidden = true;
    self.backButton.enabled = [self.webView canGoBack];
    self.forwardButton.enabled = [self.webView canGoForward];

    //Display current web page URL in textField
    NSString *webPageURLString = self.webView.request.URL.absoluteString;
    self.urlTextField.text = webPageURLString;

    //Display current web page title in Navigation Bar
    NSString *webPageTitleString = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title = webPageTitleString;
}

- (IBAction)onBackButtonPressed:(UIBarButtonItem *)sender
{
    [self.webView goBack];
}
- (IBAction)onForwardButtonPressed:(UIBarButtonItem *)sender
{
    [self.webView goForward];
}
- (IBAction)onStopLoadButtonPressed:(UIBarButtonItem *)sender
{
    [self.webView stopLoading];
}

- (IBAction)onReloadButtonPressed:(UIBarButtonItem *)sender
{
    [self.webView reload];
}

//- (IBAction)onAddButtonPressed:(UIButton *)sender
//{
//    UIAlertView *alert = [UIAlertView new];
//    alert.delegate = self;
//    alert.title = @"Coming soon!";
//    [alert addButtonWithTitle:@"Dismiss"];
//    [alert show];
//}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    if(translation.y < 0)
    {   // react to dragging down
        self.urlTextField.hidden = TRUE;
    }
    else
    {   // react to dragging up
        self.urlTextField.hidden = FALSE;
    }
}

//-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
//{
//    self.urlTextField.hidden = false;
//}

@end
