global class scheduleUserLicenses implements Schedulable {
   global void execute(SchedulableContext SC) {
      userLicenseGet.getUsers();
   }
}