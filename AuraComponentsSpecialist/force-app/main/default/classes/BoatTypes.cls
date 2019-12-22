public class BoatTypes {
    @AuraEnabled
	public static List<BoatType__c> getBoatTypes(){
		// System.debug('Fetching types');

		List<BoatType__c> types = [SELECT Id, Name FROM BoatType__c ORDER BY Name ASC];

		// System.debug(types);

		return types;
	}
}