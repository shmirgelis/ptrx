@isTest
private class BusStatusUpdateBatchTest {
    @TestSetup
    static void prepareTestData(){
        List<Bus__c> buses = new List<Bus__c>();
        for(Integer i = 0; i <= 5; i++) {
            Bus__c bus = new Bus__c(Name = 'Bus ' + i);
            buses.add(bus);
        }
        insert buses;

        List<Passenger__c> passengers = new List<Passenger__c>();
        for(Integer i = 0; i <= 75; i++) {
            Passenger__c passenger = new Passenger__c();
            if(i < 5){
                passenger.Name = 'Passenger ' + i;
                passenger.Bus__c = buses[1].Id;
            }
            else if(i >= 5 && i < 15){
                passenger.Name = 'Passenger ' + i;
                passenger.Bus__c = buses[2].Id;
            }
            else if(i >= 15 && i < 30){
                passenger.Name = 'Passenger ' + i;
                passenger.Bus__c = buses[3].Id;
            }
            else if(i >= 30 && i < 50){
                passenger.Name = 'Passenger ' + i;
                passenger.Bus__c = buses[4].Id;
            }
            else {
                passenger.Name = 'Passenger ' + i;
                passenger.Bus__c = buses[5].Id;
            }           
            passengers.add(passenger);
        }
        insert passengers;
    }

    @isTest
    static void busStatusUpdateTest() {
        List<Bus__c> buses = [SELECT Id, Name, Number_Of_Passengers__c FROM Bus__c];
        Test.startTest();
        Database.executeBatch(new BusStatusUpdateBatch(), 200);      
        Test.stopTest();
        List<Bus__c> updatedBuses = [SELECT Id, Name, Bus_Status__c FROM Bus__c];
        Assert.areEqual('Available', updatedBuses[0].Bus_Status__c, 'Bus 0 should be Available');
        Assert.areEqual('Available', updatedBuses[1].Bus_Status__c, 'Bus 1 should be Available');
        Assert.areEqual('Limited Seats', updatedBuses[2].Bus_Status__c, 'Bus 2 should have Limited Seats');
        Assert.areEqual('Limited Seats', updatedBuses[3].Bus_Status__c, 'Bus 3 should have Limited Seats');
        Assert.areEqual('Full', updatedBuses[4].Bus_Status__c, 'Bus 4 should be Full');
        Assert.areEqual(null, updatedBuses[5].Bus_Status__c, 'Bus 5 should not have a status due to exception');
    }
}