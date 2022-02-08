global class UpdateIssuesBombrilSchedulable implements Schedulable{
    global void execute(SchedulableContext scMain) {
        UpdateIssuesBombril clsBatch = new UpdateIssuesBombril();
        ID idBatch = Database.executeBatch(clsBatch, 100);
    }
}