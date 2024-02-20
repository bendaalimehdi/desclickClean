public class OpportunityEmailHandler {
 
    public static void sendEmailWithPDFForIds(List<Id> opportunityIds) {
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();

        // Query for opportunities and their related contacts
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([SELECT Id, Name, ContactId, CEmail__c FROM Opportunity WHERE Id IN :opportunityIds]);

        for (Opportunity opp : oppMap.values()) {
            // Ensure there's a contact associated with the opportunity
            if (opp.CEmail__c != null) {
                System.debug('Sending email for Opportunity: ' + opp.Name);
                PageReference pdfPage = Page.pdf; // Replace 'pdf' with the name of your Visualforce page
                pdfPage.getParameters().put('id', opp.Id);

                Blob pdfBlob;
                try {
                    pdfBlob = pdfPage.getContentAsPDF();
                } catch (Exception e) {
                    // Handle exception
                    System.debug('Error generating PDF: ' + e.getMessage());
                    continue;
                }

                Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                attach.setFileName('Quote.pdf');
                attach.setBody(pdfBlob);

                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setSubject('Devis');
                email.setToAddresses(new List<String>{opp.CEmail__c});
                email.setPlainTextBody('Bonjour, voila votre devis');

                Id orgWideAddressId = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress  LIMIT 1].Id;
                email.setOrgWideEmailAddressId(orgWideAddressId);

                email.setFileAttachments(new List<Messaging.EmailFileAttachment>{attach});
                emailList.add(email);

                Opportunity oppToUpdate = new Opportunity(Id = opp.Id, Email_Sent__c = true);
                opportunitiesToUpdate.add(oppToUpdate);
                System.debug('Email List Size: ' + emailList.size());
            }
        }

        // Update opportunities to mark emails as sent
        if (!opportunitiesToUpdate.isEmpty()) {
            update opportunitiesToUpdate;
        }

        Messaging.sendEmail(emailList);
    }

    
}
