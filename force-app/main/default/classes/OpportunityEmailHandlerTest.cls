@isTest
private class OpportunityEmailHandlerTest {
    @isTest static void testSendEmailWithPDF_EmailSent() {
        // Create test opportunities and contacts
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'bendaalimehdi@gmail.com'
        );
        insert testContact;

        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = System.today().addMonths(1),
            ContactId = testContact.Id
        );
        insert testOpportunity;

        // Call the method to send emails
        Test.startTest();
        System.debug('Calling sendEmailWithPDFForIds');
        OpportunityEmailHandler.sendEmailWithPDFForIds(new List<Id>{testOpportunity.Id});
        Test.stopTest();

        // Retrieve the updated opportunity to check if the email was sent
        Opportunity updatedOpportunity = [SELECT Email_Sent__c FROM Opportunity WHERE Id = :testOpportunity.Id];

        // Check if the email was sent and the opportunity was updated
        System.assertEquals(true, updatedOpportunity.Email_Sent__c, 'Email should have been sent');
    }

    @isTest static void testSendEmailWithPDF_NoContactEmail() {
        // Create test opportunities and contacts
        Contact testContact = new Contact(
            FirstName = 'Jane',
            LastName = 'Doe',
            Email = null
        );
        insert testContact;

        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity 2',
            StageName = 'Prospecting',
            CloseDate = System.today().addMonths(1),
            ContactId = testContact.Id
        );
        insert testOpportunity;

        // Call the method to send emails
        Test.startTest();
        OpportunityEmailHandler.sendEmailWithPDFForIds(new List<Id>{testOpportunity.Id});
        Test.stopTest();

        // Retrieve the updated opportunity to check if the email was not sent
        Opportunity updatedOpportunity = [SELECT Email_Sent__c FROM Opportunity WHERE Id = :testOpportunity.Id];

        // Check if the email was not sent and the opportunity was not updated
        System.assertEquals(false, updatedOpportunity.Email_Sent__c, 'Email should not have been sent');
    }
}
