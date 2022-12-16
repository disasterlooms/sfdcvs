@isTest
private class testFreshDeskTickets {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void testFreshDeskCallout() {
        
        String ticketId = ' ';
        freshDeskTicket.getTicketData(ticketId);
        
    }
}