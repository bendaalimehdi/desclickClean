trigger EmailTrigger on Opportunity (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        List<Id> opportunityIdsToSendPDF = new List<Id>();

        for (Opportunity opp : Trigger.new) {
            if (opp.Send_PDF__c && opp.Send_PDF__c != Trigger.oldMap.get(opp.Id).Send_PDF__c
                && !opp.Email_Sent__c) {
                opportunityIdsToSendPDF.add(opp.Id);
            }
        }

        if (!opportunityIdsToSendPDF.isEmpty()) {
            OpportunityEmailBatch batch = new OpportunityEmailBatch(opportunityIdsToSendPDF);
            Database.executeBatch(batch);
        }
    }
}