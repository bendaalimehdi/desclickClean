@isTest
public class OpportunityEmailTriggerTest {
    @isTest
    static void testEmailTrigger() {
        // Create test data
        Account testAccount = new Account(
            Name = 'Test Account',
            Enseigne__c = 'TestEnseigne',
            Email__c = 'bendaalimehdi@gmail.com');
        insert testAccount;

        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity', 
            StageName = 'Prospecting', 
            CloseDate = Date.today(),
            AccountId = testAccount.Id);
        insert testOpportunity;

        // Ensure Send_PDF__c and Email_Sent__c are false initially
        testOpportunity.Send_PDF__c = false;
        testOpportunity.Email_Sent__c = false;
        update testOpportunity;

        // Set Send_PDF__c to true to meet trigger criteria
        testOpportunity.Send_PDF__c = true;
        update testOpportunity;

        // Verify that the trigger initiated a batch job
        List<AsyncApexJob> jobs = [SELECT Id FROM AsyncApexJob WHERE JobType = 'BatchApex' AND Status = 'Queued'];
        System.assertNotEquals(0, jobs.size(), 'Expected a batch job to be queued');
    }
}
