global class portalLoginHistory implements Schedulable {
    global void execute(SchedulableContext ctx) {
        batchPortalLogin bp = new batchPortalLogin();
        database.executeBatch(bp);
    }
}