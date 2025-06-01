public with sharing class BusStatusUpdateBatch implements Database.Batchable<sObject> {
     public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, Name, Number_Of_Passengers__c FROM Bus__c');
    }
     
    public void execute(Database.BatchableContext bc, List<Bus__c> busList) { 
        if(!busList.isEmpty()) {
            update setBusStatus(busList);                                
        }        
    }   
     
    public void finish(Database.BatchableContext bc) {}
    

    private List<Bus__c> setBusStatus(List<Bus__c> busList) {
        List<Bus__c> busesWithNewStatus = new List<Bus__c>();
        for (Bus__c bus : busList) {   
            try {
                if (bus.Number_Of_Passengers__c < 10) {
                    bus.Bus_Status__c = 'Available';
                } else if (bus.Number_Of_Passengers__c >= 10 && bus.Number_Of_Passengers__c < 20) {
                    bus.Bus_Status__c = 'Limited Seats';
                } else if (bus.Number_Of_Passengers__c == 20) {
                    bus.Bus_Status__c = 'Full';
                } else {
                    throw new CustomBusCapacityException('Bus capacity exceeded for ' + bus.Name + ' bus');
                }
                busesWithNewStatus.add(bus);
            } catch (CustomBusCapacityException e) {
                System.debug('Custom exception caught: ' + e.getMessage());
            }           
        }         
        return busesWithNewStatus;
    }
}