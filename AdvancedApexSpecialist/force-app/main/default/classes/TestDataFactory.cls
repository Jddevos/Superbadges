/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
**/
public with sharing class TestDataFactory {

	/**
	 * @name ConstructCollaborationGroup
	 * @description
	**/
	public static CollaborationGroup ConstructCollaborationGroup(){
		//ToDo: Ensure this method returns a single Chatter CollaborationGroup
		//    whose Name starts with 'TEST' followed by the INVENTORY_ANNOUNCEMENTS constant
		//    and configured so anyone can join, see and post updates.
		
		CollaborationGroup cg = new CollaborationGroup();

		cg.Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS;
		cg.CollaborationType = 'Public';

		// System.debug(cg);
		return cg;
	}

	/**
	 * @name CreateProducts
	 * @description Constructs a list of Product2 records for unit tests
	**/
	public static List<Product2> ConstructProducts(Integer cnt){
		//ToDo: Ensure this method returns a list, of size cnt, of uniquely named Product2 records
		//  with all the required fields populated
		//  and IsActive = true
		//  an Initial Inventory set to 10
		//  and iterating through the product family picklist values throughout the list.

		List<Product2> products = new List<Product2>();

		for (Integer i=1; i<=cnt; i++) {
			Product2 p = new Product2();
			p.Name = 'Test Product ' +i;
			p.IsActive = true;
			p.Initial_Inventory__c = 10;
			p.Family = Constants.PRODUCT_FAMILY[Math.mod(i,Constants.PRODUCT_FAMILY.size())].getValue();
			
			products.add(p);
		}

		// System.debug('products size: ' +products.size());
		// System.debug(products);
		return products;
	}

	/**
	 * @name CreatePricebookEntries
	 * @description Constructs a list of PricebookEntry records for unit tests
	**/
	public static List<PricebookEntry> ConstructPricebookEntries(List<Product2> prods){
		//ToDo: Ensure this method returns a corresponding list of PricebookEntries records
		//  related to the provided Products
		//  with all the required fields populated
		//  and IsActive = true
		//  and belonging to the standard Pricebook
		
		List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();

		for (Product2 p : prods) {
			PricebookEntry pbe = new PricebookEntry();
			pbe.Product2Id = p.Id;
			pbe.UnitPrice = 100;
			pbe.IsActive = true;
			pbe.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;

			pricebookEntries.add(pbe);
		}

		// System.debug('pricebookEntries size: ' +pricebookEntries.size());
		// system.debug(pricebookEntries);
		return pricebookEntries;
	}

	/**
	 * @name CreateAccounts
	 * @description Constructs a list of Account records for unit tests
	**/
	public static List<Account> ConstructAccounts(Integer cnt){
		//ToDo: Ensure this method returns a list of size cnt of uniquely named Account records
		//  with all of the required fields populated.
		
		List<Account> accounts = new List<Account>();

		for (Integer i=1; i<=cnt; i++) {
			Account a = new Account();
			a.Name = 'Test Account '+i;

			accounts.add(a);
		}

		// System.debug('accounts size: ' +accounts.size());
		// System.debug(accounts);
		return accounts;
	}

	/**
	 * @name CreateContacts
	 * @description Constructs a list of Contacxt records for unit tests
	**/
	public static List<Contact> ConstructContacts(Integer cnt, List<Account> accts){
		//ToDo: Ensure this method returns a list, of size cnt, of uniquely named Contact records
		//  related to the provided Accounts
		//  with all of the required fields populated.
		
		List<Contact> contacts = new List<Contact>();

		for (Integer i=1; i<=cnt; i++) {
			Contact c = new Contact();
			c.LastName = 'Test Contact '+i;
			c.AccountId = accts[Math.mod(i,accts.size())].Id;

			contacts.add(c);
		}

		// System.debug('contacts size: ' +contacts.size());
		// System.debug(contacts);
		return contacts;
	}

	/**
	 * @name CreateOrders
	 * @description Constructs a list of Order records for unit tests
	**/
	public static List<Order> ConstructOrders(Integer cnt, List<Account> accts){
		//ToDo: Ensure this method returns a list of size cnt of uniquely named Order records
		//  related to the provided Accounts
		//  with all of the required fields populated.
		
		List<Order> orders = new List<Order>();

		for (Integer i=1; i<=cnt; i++) {
			Order o = new Order();
			o.Name = 'Test Order ' +i;
			o.AccountId = accts[Math.mod(i,accts.size())].Id;
			o.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
			o.Status = Constants.DRAFT_ORDER_STATUS;
			o.EffectiveDate = System.today();

			orders.add(o);
		}

		// System.debug('orders size: ' +orders.size());
		// system.debug(orders);
		return orders;
	}

	/**
	 * @name CreateOrderItems
	 * @description Constructs a list of OrderItem records for unit tests
	**/
	public static List<OrderItem> ConstructOrderItems(integer cnt, list<pricebookentry> pbes, list<order> ords){
		//ToDo: Ensure this method returns a list of size cnt of OrderItem records
		//  related to the provided Pricebook Entries
		//  and related to the provided Orders
		//  with all of the required fields populated.
		//  Hint: Use the DEFAULT_ROWS constant for Quantity as it will be used in the next challenge

		List<OrderItem> orderItems = new List<OrderItem>();

		for (Integer i=1; i<=cnt; i++) {
			OrderItem oi = new OrderItem();
			oi.Quantity = Constants.DEFAULT_ROWS;
			oi.UnitPrice = 100;
			oi.PricebookEntryId = pbes[Math.mod(i,pbes.size())].Id;
			oi.OrderId = ords[Math.mod(i,ords.size())].Id;

			orderItems.add(oi);
		}

		// System.debug('orderItems size: ' +orderItems.size());
		// system.debug(orderItems);
		return orderItems;
	}

	/**
	 * @name SetupTestData
	 * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
	**/
	public static void InsertTestData(Integer cnt){
		//ToDo: Ensure this method calls each of the construct methods
		//  and inserts the results for use as test data.

		System.debug(cnt);

		CollaborationGroup cg = ConstructCollaborationGroup();
		insert cg;
		List<Product2> products = ConstructProducts(cnt);
		insert products;
		List<PricebookEntry> pricebookEntries = ConstructPricebookEntries(products);
		insert pricebookEntries;
		List<Account> accounts = ConstructAccounts(cnt);
		insert accounts;
		List<Contact> contacts = ConstructContacts(cnt, accounts);
		insert contacts;
		List<Order> orders = ConstructOrders(cnt, accounts);
		insert orders;
		List<OrderItem> orderItems = ConstructOrderItems(cnt, pricebookEntries, orders);
		insert orderItems;
	}

	public static void RemoveTestData() {
		String groupName = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS;
		delete [SELECT Id FROM CollaborationGroup WHERE Name = :groupName];

		delete [SELECT Id FROM OrderItem WHERE UnitPrice = 100 AND Quantity = :Constants.DEFAULT_ROWS ];
		delete [SELECT Id FROM Order WHERE Name LIKE 'Test Order %'];
		delete [SELECT Id FROM Contact WHERE LastName LIKE 'Test Contact %'];
		delete [SELECT Id FROM Account WHERE Name LIKE 'Test Account %'];
		delete [SELECT Id FROM PricebookEntry WHERE UnitPrice = 100 AND IsActive = true AND Pricebook2Id = :Constants.STANDARD_PRICEBOOK_ID];
		delete [SELECT Id FROM Product2 WHERE Name LIKE 'Test Product %'];
	}
}