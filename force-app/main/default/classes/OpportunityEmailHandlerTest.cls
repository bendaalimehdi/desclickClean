@IsTest
private class OpportunityEmailHandlerTest {

    @IsTest
    static void testSendEmailWithPDFForIds() {
        // Créer des données de test
        Account testAccount = new Account(
            Name = 'Test Account',
            Enseigne__c = 'TestEnseigne',
            Email__c = 'bendaalimehdi@gmail.com'
        );
        insert testAccount;

        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity', 
            StageName = 'Prospecting', 
            CloseDate = Date.today(),
            AccountId = testAccount.Id,
            Send_PDF__c = False
        );
        insert testOpportunity;

        // Set up mock data for Visualforce page
        PageReference pdfPage = Page.pdf; // Replace 'OpportunityDetailsPDF' with your actual VF page name
        Test.setCurrentPage(pdfPage);

        // Add parameters to the page
        pdfPage.getParameters().put('id', testOpportunity.Id);

        Test.startTest();
        testOpportunity.Send_PDF__c = true; // update to true, which should fire the trigger
        update testOpportunity;
        OpportunityEmailHandler.sendEmailWithPDFForIds(new List<Id>{testOpportunity.Id});
        Test.stopTest();

         // Check that an email was sent
         System.assertEquals(1, Limits.getEmailInvocations(), 'An email should have been sent');
    }
}