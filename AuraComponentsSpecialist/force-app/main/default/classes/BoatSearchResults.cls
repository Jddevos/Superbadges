public class BoatSearchResults {
	@AuraEnabled
    public static List<Boat__c> getBoats(String boatTypeId) {
		// System.debug('Fetching boats');
		// System.debug('boatTypeId: ' +boatTypeId);

		String qString = 'SELECT Id,Name,BoatType__c,Contact__r.Name,Description__c,Geolocation__latitude__s,Geolocation__longitude__s,Length__c,Picture__c,Price__c,Year_Built__c FROM Boat__c ';
		qString += boatTypeId != null && boatTypeId != '' ? 'WHERE BoatType__c = \'' +boatTypeId+ '\' ' : '';
		qString += 'ORDER BY Name ASC';

		// System.debug('Final query: ' +qString);

		List<Boat__c> boats = Database.query(qString);

		// System.debug(boats);

		return boats;
    }
}