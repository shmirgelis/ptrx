public with sharing class BusController {
    @AuraEnabled(cacheable=true)
    public static List<BusCompanyWrapper> getBusCompaniesWithBusesAndPassengers() {
        List<Bus_Company__c> companies = [
            SELECT Id, Name,
                (SELECT Id, Name, Number_Of_Passengers__c, Bus_Status__c,
                    (SELECT Id, Name FROM Passengers__r)
                 FROM Buses__r)
            FROM Bus_Company__c
        ];
        List<BusCompanyWrapper> results = new List<BusCompanyWrapper>();
        for (Bus_Company__c company : companies) {
            List<BusWrapper> busList = new List<BusWrapper>();
            for (Bus__c bus : company.Buses__r) {
                Integer numberOfPassengers = bus.Number_Of_Passengers__c != null ? Integer.valueOf(bus.Number_Of_Passengers__c) : 0;
                String busStatus = bus.Bus_Status__c != null ? bus.Bus_Status__c : 'Over Capacity';
                busList.add(new BusWrapper(bus, bus.Passengers__r, numberOfPassengers, busStatus));
            }
            results.add(new BusCompanyWrapper(company, busList));
        }
        return results;
    }

    public class BusCompanyWrapper {
        @AuraEnabled public Bus_Company__c company { get; set; }
        @AuraEnabled public List<BusWrapper> buses { get; set; }
        public BusCompanyWrapper(Bus_Company__c c, List<BusWrapper> b) {
            company = c;
            buses = b;
        }
    }

    public class BusWrapper {
        @AuraEnabled public Bus__c bus { get; set; }
        @AuraEnabled public List<Passenger__c> passengers { get; set; }
        @AuraEnabled public Integer numberOfPassengers { get; set; }
        @AuraEnabled public String busStatus { get; set; }
        public BusWrapper(Bus__c b, List<Passenger__c> p, Integer passengerCount, String status) {
            bus = b;
            passengers = p;
            numberOfPassengers = passengerCount;
            busStatus = status;
        }
    }

    @AuraEnabled
    public static void runBusStatusUpdateBatch() {
        Database.executeBatch(new BusStatusUpdateBatch(), 200);
    }
}