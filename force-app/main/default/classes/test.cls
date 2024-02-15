@isTest
private class OpportunityEmailHandlerTest {
    @isTest static void testSendEmailWithPDF() {
        // Create test opportunities and contacts
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@example.com'
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
        List<Id> opportunityIds = new List<Id>{testOpportunity.Id};
        Test.startTest();
        OpportunityEmailHandler.sendEmailWithPDF(opportunityIds);
        Test.stopTest();

        // Retrieve the updated opportunity to check if the email was sent
        Opportunity updatedOpportunity = [SELECT Email_Sent__c FROM Opportunity WHERE Id = :testOpportunity.Id][0];

        // Check if the email was sent and the opportunity was updated
        System.assertEquals(true, updatedOpportunity.Email_Sent__c);

        // Check if an email was sent with the correct subject
        List<Messaging.SingleEmailMessage> sentEmails = [SELECT Subject FROM Messaging.SingleEmailMessage WHERE TargetObjectId = :testOpportunity.Id];
        System.assertEquals(1, sentEmails.size());
        System.assertEquals('Devis', sentEmails[0].Subject);

        // Check if a PDF attachment was sent with the correct filename
        List<Messaging.EmailFileAttachment> attachments = [SELECT ContentType, Filename FROM Messaging.EmailFileAttachment WHERE ParentId IN :sentEmails];
        System.assertEquals(1, attachments.size());
        System.assertEquals('application/pdf', attachments[0].ContentType);
        System.assertEquals('Quote.pdf', attachments[0].Filename);
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
        List<Id> opportunityIds = new List<Id>{testOpportunity.Id};
        Test.startTest();
        OpportunityEmailHandler.sendEmailWithPDF(opportunityIds);
        Test.stopTest();

        // Retrieve the updated opportunity to check if the email was not sent
        Opportunity updatedOpportunity = [SELECT Email_Sent__c FROM Opportunity WHERE Id = :testOpportunity.Id][0];

        // Check if the email was not sent and the opportunity was not updated
        System.assertEquals(false, updatedOpportunity.Email_Sent__c);

        // Check if no emails were sent
        List<Messaging.SingleEmailMessage> sentEmails = [SELECT Subject FROM Messaging.SingleEmailMessage WHERE TargetObjectId = :testOpportunity.Id];
        System.assertEquals(0, sentEmails.size());
    }
}
