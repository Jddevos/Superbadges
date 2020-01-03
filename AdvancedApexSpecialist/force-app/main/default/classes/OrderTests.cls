@isTest (seeAllData=false)
private class OrderTests {

	@TestSetup
	private static void SetupTestData() {
		TestDataFactory.InsertTestData(5);
	}

	@isTest
	private static void OrderUpdate_UnitTest() {
		List<Order> orders = [SELECT Id, Status FROM ORDER];
		Product2 oldP2 = [SELECT Id, Quantity_Ordered__c FROM Product2 LIMIT 1];

		for (Order o : orders) {
			o.Status = Constants.ACTIVATED_ORDER_STATUS;
		}
		update orders;

		Product2 newP2 = [SELECT Id, Quantity_Ordered__c FROM Product2 LIMIT 1];

		TestDataFactory.VerifyQuantityOrdered(oldP2, newP2, Constants.DEFAULT_ROWS);
	}

	@isTest
	private static void OrderExtension_UnitTest() {
		PageReference pageRef = Page.OrderEdit;
		Test.setCurrentPage(pageRef);

		ApexPages.StandardController controller = new ApexPages.StandardController([SELECT Id FROM Order LIMIT 1]);
		OrderExtension ext = new OrderExtension(controller);

		Integer dummy = 0;
		dummy = ext.GetTotalPages();
		dummy = ext.GetPageNumber();
		ext.OnFieldChange();
		ext.SelectFamily();
		ext.Next();
		ext.Previous();
		ext.Last();
		ext.First();
		ext.GetHasNext();
		ext.GetHasPrevious();
		ext.GetFamilyOptions();
		ext.Save();
	}
}