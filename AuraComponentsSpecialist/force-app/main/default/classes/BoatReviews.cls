public class BoatReviews {
	@AuraEnabled
	public static List<BoatReview__c> getAll(String boatId){
		// System.debug('Grabbing reviews');
		List<BoatReview__c> recs = [SELECT Id,Name,Comment__c,Rating__c,LastModifiedDate,CreatedDate,CreatedById,CreatedBy.Name,CreatedBy.SmallPhotoUrl,CreatedBy.CompanyName
			FROM BoatReview__c WHERE Boat__c = :boatId];
		// System.debug(recs);
		return recs;
	}
}