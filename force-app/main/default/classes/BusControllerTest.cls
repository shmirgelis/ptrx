@isTest
public class BusControllerTest {
    @testSetup
    static void prepareTestData() {
       Bus_Company__c busCompany = new Bus_Company__c(Name = 'Bus Company');
       insert busCompany;

       List<Bus__c> buses = new List<Bus__c>();
       Bus__c bus = new Bus__c( Name = 'Bus', Bus_Company__c = busCompany.Id);
       buses.add(bus);
       Bus__c busNoPasengers = new Bus__c( Name = 'BusNoPassengers', Bus_Company__c = busCompany.Id);
       buses.add(busNoPasengers);
       Bus__c busOverCapacity = new Bus__c( Name = 'BusOverCapacity', Bus_Company__c = busCompany.Id);
       buses.add(busOverCapacity);
       insert buses;

       List<Passenger__c> passengers = new List<Passenger__c>();
        for (Integer i = 0; i < 3; i++) {
            passengers.add(new Passenger__c(
                Name = 'Passenger ' + i,
                Bus__c = bus.Id
            ));
        }
        for (Integer i = 0; i < 21; i++) {
            passengers.add(new Passenger__c(
                Name = 'PassengerOverCapacity ' + i,
                Bus__c = busOverCapacity.Id
            ));
        }
        insert passengers;
    }

    @isTest
    static void getBusCompaniesWithBusesAndPassengersTest() {
        Test.startTest();
        BusController.runBusStatusUpdateBatch();
        List<BusController.BusCompanyWrapper> results = BusController.getBusCompaniesWithBusesAndPassengers();
        Test.stopTest();

        for (BusController.BusCompanyWrapper companyWrap : results) {
            if (companyWrap.buses != null && companyWrap.buses.size() > 0) {
                for (BusController.BusWrapper busWrap : companyWrap.buses) {
                    Assert.areNotEqual(null, busWrap.bus, 'Bus should not be null');
                    Assert.areNotEqual(null, busWrap.numberOfPassengers, 'Number of passengers should not be null');
                    Assert.areNotEqual(null, busWrap.busStatus, 'Bus status should not be null');
                }
            }
        }
    }
}