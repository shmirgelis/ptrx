import { LightningElement, wire } from 'lwc';
import getBusCompaniesWithBusesAndPassengers from '@salesforce/apex/BusController.getBusCompaniesWithBusesAndPassengers';
import runBusStatusUpdateBatch from '@salesforce/apex/BusController.runBusStatusUpdateBatch'; 
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class BusManagerView extends LightningElement {
    companies = [];
    error;
    columns = [
        { label: 'Bus Name', fieldName: 'Name', type: 'text', cellAttributes: { class: 'small-col' }, initialWidth: 120 },
        { label: 'Bus Status', fieldName: 'busStatus', type: 'text', cellAttributes: { class: 'small-col' }, initialWidth: 120 },
        { label: 'Number of Passengers', fieldName: 'numberOfPassengers', type: 'number', cellAttributes: { class: 'small-col' }, initialWidth: 200 },
        { label: 'Passengers', fieldName: 'passengerNames', type: 'text', wrapText: true, cellAttributes: { class: 'passenger-col' } }
    ];

    @wire(getBusCompaniesWithBusesAndPassengers)
    wiredCompanies({ error, data }) {
        if (data) {
            this.companies = data.map(companyWrap => {
                const buses = (companyWrap.buses || []).map(busWrap => ({
                    Id: busWrap.bus.Id,
                    Name: busWrap.bus.Name,
                    numberOfPassengers: busWrap.numberOfPassengers,
                    passengerNames: (busWrap.passengers || []).map(p => p.Name).join(', '),
                    busStatus: busWrap.busStatus
                }));
                return {
                    company: companyWrap.company,
                    buses
                };
            });
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.companies = [];
        }
    }

    handleRunBatch() {
        runBusStatusUpdateBatch()
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Updating Bus Status.',
                        variant: 'success'
                    })
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.body ? error.body.message : error.message,
                        variant: 'error'
                    })
                );
            });
    }
}