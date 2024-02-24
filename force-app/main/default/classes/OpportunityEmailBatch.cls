public class OpportunityEmailBatch implements Database.Batchable<SObject> {
    List<Id> opportunityIds;

    public OpportunityEmailBatch(List<Id> oppIds) {
        this.opportunityIds = oppIds;
    }

    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([SELECT Id FROM Opportunity WHERE Id IN :opportunityIds]);
    }

    public void execute(Database.BatchableContext context, List<Opportunity> scope) {
        // Extract opportunity IDs from the scope
        List<Id> opportunityIdsInScope = new List<Id>();
        for (Opportunity opp : scope) {
            opportunityIdsInScope.add(opp.Id);
        }
    
        // Call the static method with the correct parameter type
        OpportunityEmailHandler.sendEmailWithPDFForIds(opportunityIdsInScope);
    }

    public void finish(Database.BatchableContext context) {
        // Optional: Add any post-processing logic if needed
    }
}