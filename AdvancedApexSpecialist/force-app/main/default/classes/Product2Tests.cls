@isTest (seeAllData=false)
private class Product2Tests {

    /**
     * @name product2Extension_UnitTest
     * @description UnitTest for product2Extension
    **/
	
	@isTest
    private static void Product2Extension_UnitTest() {
		
		Pagereference pageRef = Page.Product2New;
		Product2 prod = new Product2(Name='Test Product2', IsActive=true);
		ApexPages.StandardController controller = new ApexPages.StandardController(prod);

        Test.startTest();
        	Product2Extension ext = new Product2Extension(controller);
			System.assertEquals(ext.productsToInsert.size(), Constants.DEFAULT_ROWS);
            ext.AddRows();
			System.assertEquals(ext.productsToInsert.size(), 2*Constants.DEFAULT_ROWS);

			for (Integer i=0; i < Constants.DEFAULT_ROWS; i++) {	
				Product2 p = new Product2();
				p.Name = 'Test Product2 ' +i;
				p.IsActive = true;
				p.Initial_Inventory__c = 10;
				p.Family = String.ValueOf(Constants.PRODUCT_FAMILY[Math.mod(i, Constants.PRODUCT_FAMILY.size())]);

				PricebookEntry pb = new PricebookEntry();
				pb.IsActive = true;
				pb.UnitPrice = 100;

				ext.productsToInsert.get(i).productRecord = p;
				ext.productsToInsert.get(i).pricebookEntryRecord = pb;
			}
            ext.Save();
			ext.GetFamilyOptions();
			ext.GetInventory();
			System.assertEquals(Constants.DEFAULT_ROWS, [SELECT Id FROM Product2].size());

        Test.stopTest();
    }

	@isTest
	private static void Product2Trigger_UnitTest() {
		Test.startTest();
			CollaborationGroup cg = new CollaborationGroup();
			cg.Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS;
			cg.CollaborationType = 'Public';
			insert cg;

			Product2 p = new Product2();
			p.Name = 'Test Product';
			p.Family = String.valueof(Constants.PRODUCT_FAMILY[Integer.valueof(Math.random()*Constants.PRODUCT_FAMILY.size())]);
			p.Initial_Inventory__c = 100;
			p.Quantity_Ordered__c = 0;
			insert p;

			p.Quantity_Ordered__c = 105;
			update p;
		Test.stopTest();
	}
}