public with sharing class unlockRecordsInv {
	@InvocableMethod(label='UnLock a record')
	public static void UnLockRecord(list<string> recordIds) {
		Approval.unlock(recordIds[0]);
	}
}