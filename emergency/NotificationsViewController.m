//
//  NotificationsViewController.m
//  emergency
//
//  Created by Marco Velluto on 17/09/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import "NotificationsViewController.h"
#import "Database.h"
#import "DetailNotificheViewController.h"

@interface NotificationsViewController ()

@end

@implementation NotificationsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    values = [[NSMutableArray alloc] init];
    db = [[Database alloc] init];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    values = [db allElements];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarningc
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return values.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = [[values objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.detailTextLabel.text = [[values objectAtIndex:indexPath.row] objectForKey:@"data"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"pushSingleNotification" sender:[NSString stringWithFormat:@"%i", indexPath.row]];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailNotificheViewController *dnvc = segue.destinationViewController;
    NSString *senderStr = (NSString *)sender;
    int row = [senderStr intValue];
    dnvc.textNotitication = (NSDictionary *)[values objectAtIndex:row];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) { //Eliminazione Cella.
        NSDictionary *dic = [values objectAtIndex:indexPath.row];
        int numberRecord = (int) [[dic objectForKey:@"id"] intValue];
        [db removeObjectFromNumerId:numberRecord];
        
        [values removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}
- (IBAction)pressButtonTrash:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Attenzione" message:@"Stai per cancellare tutte le notifiche. \n Continuare ?" delegate:self cancelButtonTitle:@"Annulla" otherButtonTitles:@"Conferma", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            //Button Cancel.
            break;
        case 1:
            //Button Conferma.
            [db removeAll];
            break;
        default:
            //Non si verificherà mai.
            break;
    }
    [self viewWillAppear:YES];
}

@end
