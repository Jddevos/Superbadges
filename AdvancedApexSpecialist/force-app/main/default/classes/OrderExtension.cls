/**
 * @name OrderExtension
 * @description This class is provided for you to facilitate the Super Badge
**/
public class OrderExtension {

	public Order orderRecord {get;set;}
	public List<OrderItem> orderItemList {get;set;}
	public String selectedFamily {get;set;}
	public List<chartHelper.chartData> pieData {get;set;}
	public Decimal total {get;set;}

	public Map<Id,OrderItem> orderItemMap;
	ApexPages.StandardSetController standardSetController;

	public OrderExtension(ApexPages.StandardController standardController){
		orderRecord = (Order)standardController.getRecord();
		orderItemMap = new Map<id,OrderItem>();
		if ( orderRecord.Id != null ){
			orderRecord = queryOrderRecord(orderRecord.Id);
		}

		loadOrder();
		loadEntries();
	}


	//ToDo: Implement your own method to populate orderItemList
	//  that you will call after pagination and/or family selection
	public void loadOrder() {
		for (OrderItem oi : orderRecord.OrderItems) {
			orderItemMap.put(oi.Product2Id, oi);
		}
		loadPieChart();
	}

	public void loadPieChart() {
		this.total = 0;
		pieData = new List<ChartHelper.ChartData>();

		for (OrderItem oi : orderItemMap.values()) {
			if (oi.Quantity > 0) {
				ChartHelper.ChartData cd = new ChartHelper.ChartData(oi.Product2.Name, oi.UnitPrice * oi.Quantity);
				total += oi.UnitPrice * oi.Quantity;
				pieData.add(cd);
			}
		}
	}

	public void loadEntries() {
		String query = 'SELECT Id, Name, UnitPrice, Pricebook2Id, ';
		query += 'Product2Id, Product2.Name, Product2.Quantity_Remaining__c, Product2.Family';
		query += ' FROM PricebookEntry WHERE isActive = true';

		if (String.isNotBlank(selectedFamily) && selectedFamily != Constants.SELECT_ONE) {
			query += ' AND Product2.Family = \'' +selectedFamily+ '\'';
		}

		standardSetController = new ApexPages.StandardSetController(Database.getQueryLocator(query));
		standardSetController.setPageSize(Constants.DEFAULT_ROWS);

		loadOrderItems();
	}

	public void loadOrderItems() {
		orderItemList = new List<OrderItem>();
		for (SObject o : standardSetController.getRecords()) {
			PricebookEntry pbe = (PricebookEntry)o;

			if (orderItemMap.containsKey(pbe.Product2Id)) {
				orderItemList.add(orderItemMap.get(pbe.Product2Id));
			} else {
				OrderItem oi = new OrderItem();
				oi.Product2Id = pbe.Product2Id;
				oi.Product2 = pbe.Product2;
				oi.Quantity = 0;
				oi.UnitPrice = pbe.UnitPrice;
				oi.PricebookEntryId = pbe.Id;

				orderItemList.add(oi);
				orderItemMap.put(pbe.Product2Id, oi);
			}
		}
	}


	/**
	 * @name OnFieldChange
	 * @description
	**/
	public void OnFieldChange(){
		//ToDo: Implement logic to store the values changed on the page
		//      and populate pieData
		//      and populate total

		for(OrderItem oi : orderItemList) {
			orderItemMap.put(oi.Product2Id, oi);
		}

		loadPieChart();
	}


	/**
	 * @name SelectFamily
	 * @description
	**/
	public void SelectFamily(){
		//ToDo: Implement logic to filter based on the selected product family

		loadEntries();
	}

	/**
	 * @name Save
	 * @description
	**/
	public void Save(){
		//ToDo: Implement logic to save the Order and populated OrderItems

		Savepoint sp = Database.setSavepoint();
		// System.debug('Savepoint created');
		try {
			if (orderRecord.Pricebook2Id == null) {
				orderRecord.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
			}
			upsert orderRecord;

			List<OrderItem> itemsToUpsert = new List<OrderItem>();
			List<OrderItem> itemsToDelete = new List<OrderItem>();

			for (OrderItem oi : orderItemMap.values()) {
				if (oi.Quantity > 0) {
					if (oi.OrderId == null) {
						oi.OrderId = orderRecord.Id;
					} 
					itemsToUpsert.add(oi);
				} else if (oi.Id != null) {
					itemsToDelete.add(oi);
				}
			}
			
			// System.debug(itemsToUpsert);
			// System.debug(itemsToDelete);

			upsert itemsToUpsert;
			delete itemsToDelete;
		} catch (Exception e) {
			apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,Constants.ERROR_MESSAGE));
			System.debug('Something went wrong while inserting. Rolling back.');
			System.debug(e);
			Database.rollback(sp);
		}
		loadPieChart();
	}


	/**
	 * @name First
	 * @description
	**/
	public void First(){
		standardSetController.first();
		loadOrderItems();
	}


	/**
	 * @name Next
	 * @description
	**/
	public void Next(){
		standardSetController.next();
		loadOrderItems();
	}


	/**
	 * @name Previous
	 * @description
	**/
	public void Previous(){
		standardSetController.previous();
		loadOrderItems();
	}

	/**
	 * @name Last
	 * @description
	**/
	public void Last(){
		standardSetController.last();
		loadOrderItems();
	}

	/**
	 * @name GetHasPrevious
	 * @description
	**/
	public Boolean GetHasPrevious(){
		return standardSetController.getHasPrevious();
	}

	/**
	 * @name GetHasNext
	 * @description
	**/
	public Boolean GetHasNext(){
		return standardSetController.getHasNext();
	}

	/**
	 * @name GetTotalPages
	 * @description
	**/
	public Integer GetTotalPages(){
		return Integer.valueOf(Math.ceil(Decimal.valueOf(standardSetController.getResultSize())/Decimal.valueOf(standardSetController.getPageSize())));
	}

	/**
	 * @name GetPageNumber
	 * @description
	**/
	public Integer GetPageNumber(){
		return standardSetController.getPageNumber();
	}

	/**
	 * @name GetFamilyOptions
	 * @description
	**/
	public List<SelectOption> GetFamilyOptions(){
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption(Constants.SELECT_ONE,Constants.SELECT_ONE));
		for(Schema.PicklistEntry entry : Constants.PRODUCT_FAMILY){
			options.add(new SelectOption(entry.getValue(),entry.getLabel()));
		}
		// System.debug('Returning Options');
		// System.debug(options);
		return options;
	}

	/**
	 * @name QueryOrderRecord
	 * @description
	**/
	public static Order QueryOrderRecord(Id orderId){
		return [
			SELECT Id, AccountId, EffectiveDate, Name, Status, Pricebook2Id,
				(
					SELECT Id, OrderId, Quantity, UnitPrice, PricebookEntryId, Product2Id,
						 Product2.Name, Product2.Family, Product2.Quantity_Remaining__c
					FROM OrderItems
				)
			FROM Order
			WHERE Id = :orderId
		];
	}

}