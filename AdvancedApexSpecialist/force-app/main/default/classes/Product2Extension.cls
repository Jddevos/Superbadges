public class Product2Extension {

    public List<ProductWrapper> productsToInsert {get;set;}

    public Product2Extension(ApexPages.StandardController controller){
        productsToInsert = new List<ProductWrapper>();
        AddRows();
    }

    public void AddRows(){
        for ( Integer i=0; i<Constants.DEFAULT_ROWS; i++ ){
			ProductWrapper pw = new ProductWrapper();
            productsToInsert.add(pw);
        }
    }

    public List<ChartHelper.ChartData> GetInventory(){
        return ChartHelper.GetInventory();
    }

    public PageReference Save(){
		Savepoint sp = Database.setSavepoint();
        // System.debug('Savepoint created');
		try {
			// System.debug('Trying to save records');
			Map<Integer,Product2> productMap = new Map<Integer,Product2>();
			Map<Integer,PricebookEntry> pricebookEntryMap = new Map<Integer,PricebookEntry>();
			Integer index = 0;
			
			for (ProductWrapper pw : productsToInsert) {
				// System.debug(pw);
				if (String.isNotBlank(pw.productRecord.Name) && 
				pw.productRecord.Initial_Inventory__c != null && 
				pw.productRecord.Initial_Inventory__c > 0 &&
				pw.pricebookEntryRecord.isActive &&
				pw.pricebookEntryRecord.UnitPrice != null &&
				pw.pricebookEntryRecord.UnitPrice > 0) {
					// System.debug('index: ' +index);
					// System.debug(pw.productRecord);
					// System.debug(pw.pricebookEntryRecord);

					productMap.put(index, pw.productRecord);
					pricebookEntryMap.put(index, pw.pricebookEntryRecord);
					index++;
				}
			}

			// System.debug('Inserting products');
			// System.debug(productMap.values());
			insert productMap.values();

			List<PricebookEntry> pbesToInsert = new List<PricebookEntry>();
			for (Integer mapIndex : productMap.keySet()) {
				Product2 curPRD = productMap.get(mapIndex);
				PricebookEntry curPBE = pricebookEntryMap.get(mapIndex);
				// System.debug(curPRD);
				// System.debug(curPBE);

				if (curPRD.Id != null) {
					curPBE.Product2Id = curPRD.Id;	// Connect PBE to product
					curPBE.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;	// Connect PBE to standard pricebook
					curPBE.IsActive = true;	// Set PBE to ACTIVE
					pbesToInsert.add(curPBE);
				}
			}
            
			// System.debug('Inserting PBEs');
			// System.debug(pbesToInsert);
			insert pbesToInsert;

            //If successful clear the list and display an informational message
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,productsToInsert.size()+' Inserted'));
            productsToInsert.clear();   //Do not remove
            addRows();  //Do not remove
        } catch (Exception e){
			apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,Constants.ERROR_MESSAGE));
			System.debug('Something went wrong while inserting. Rolling back.');
			System.debug(e);
			Database.rollback(sp);
        }
        return null;
    }

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

	public class ProductWrapper {
		public Product2 productRecord {get;set;}
		public PriceBookEntry pricebookEntryRecord {get;set;}

		public ProductWrapper() {
			productRecord = new Product2(Initial_Inventory__c = 0);
			pricebookEntryRecord = new PricebookEntry(UnitPrice = 0.0);
		}
	}
// =====================
	// public void AddRows(){
	// 	for ( Integer i=0; i<Constants.DEFAULT_ROWS; i++ ){
	// 		ProductWrapper prodWrapper = new ProductWrapper();
	// 		productsToInsert.add( prodWrapper );
	// 	}
	// }
	// public List<ChartHelper.ChartData> GetInventory(){
	// 	return ChartHelper.GetInventory();
	// }
	// public PageReference Save(){
	// 	SavePoint sp1 = Database.setSavepoint();
	// 	try {
	// 		Map<Integer, Product2> products = new Map<Integer, Product2>();
	// 		Map<Integer, PriceBookEntry> priceBookEntries = new Map<Integer, PriceBookEntry>();    
	// 		Integer index = 0;
	// 		for(ProductWrapper prdWrapper : productsToInsert) {
	// 			if(String.isNotBlank(prdWrapper.productRecord.Name) && prdWrapper.pricebookEntryRecord.UnitPrice!=null && 
	// 			   prdWrapper.productRecord.Initial_Inventory__c!=null && prdWrapper.productRecord.isActive && 
	// 			   prdWrapper.productRecord.Initial_Inventory__c != 0 && prdWrapper.pricebookEntryRecord.UnitPrice!=0){
						  
	// 				products.put(index,prdWrapper.productRecord);
	// 				priceBookEntries.put(index,prdWrapper.pricebookEntryRecord);
	// 				index ++;
	// 			}
	// 		}
			
	// 		insert products.values();
			
	// 		List<PriceBookEntry> pbList = new List<PriceBookEntry>();
	// 		for(Integer mapIndex : products.keySet()) {
	// 			PriceBookEntry currentPBEntry = priceBookEntries.get(mapIndex);
	// 			if(products.get(mapIndex).Id!=null) {
	// 				currentPBEntry.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
	// 				System.debug('' + products.get(mapIndex).Id);
	// 				currentPBEntry.Product2Id = products.get(mapIndex).Id;
	// 				currentPBEntry.IsActive = true;
	// 				pbList.add(currentPBEntry);
	// 			}
				
	// 		}
			
	// 		insert pbList;

	// 		//If successful clear the list and display an informational message
	// 		apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,pbList.size()+' Inserted'));
	// 		productsToInsert.clear();   //Do not remove
	// 		addRows();  //Do not remove
	// 	} catch (Exception e){
	// 		apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,Constants.ERROR_MESSAGE));
	// 		Database.rollback(sp1);
	// 	}
	// 	return null;
	// }
	// public List<SelectOption> GetFamilyOptions(){
	// 	List<SelectOption> options = new List<SelectOption>();
	// 	options.add(new SelectOption(Constants.SELECT_ONE,Constants.SELECT_ONE));
	// 	for(Schema.PicklistEntry entry : Constants.PRODUCT_FAMILY){
	// 		options.add(new SelectOption(entry.getLabel(),entry.getValue()));
	// 	}
	// 	return options;
	// }
}