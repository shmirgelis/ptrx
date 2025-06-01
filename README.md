# Bus Manager App – Overview

The Bus Manager App is a Salesforce Lightning application that helps with the management of bus companies, buses, and passengers.
Key Features:
* View and manage all bus companies, with quick access to related buses and passengers.
* For each company, see a detailed table of buses, including bus name, status (color-coded for clarity), and number of passengers.
* Easily view and manage passengers assigned to each bus, with names displayed directly in the bus table.
* Update all bus statuses with a single click using the "Click To Update Bus Status" button in "Bus Manager View" tab, which    automatically sets status based on passenger count (Available, Limited Seats, Full, Over Capacity).

App Navigation
The app is organized into four main tabs for easy navigation:

Bus Companies:
Manage bus company records and view related buses and passengers.

Buses:
Create, view, and update bus records, including status and passenger count.

Passengers:
Manage passenger records and assign them to buses.

Bus Manager View:
An interactive dashboard displaying all companies, their buses, and passengers in a single view, with bus status update functionality.


## Bus Manager App – High Level Technical Overview

The Bus Manager App is a modular Salesforce Lightning application designed for efficient management of transportation data. It leverages Salesforce’s platform features, custom metadata, and Lightning Web Components (LWC) for a robust, scalable solution.

## Architecture & Components

Custom Objects:
Bus_Company__c: Represents a bus company.
Bus__c: Represents a bus, related to a company and passengers.
Passenger__c: Represents a passenger, related to a bus.

Tabs:
Custom tabs are defined for Bus Companies, Buses, Passengers, and a custom dashboard (Bus Manager View) for easy navigation.

Lightning Web Components (LWC):
busManagerView: Main dashboard component displaying companies, buses, and passengers in a hierarchical, interactive table.
Uses lightning-datatable for dynamic, responsive data display with custom styling.

Apex Controllers:
BusController:
Provides data aggregation logic, returning wrapper classes with nested company, bus, and passenger data for the LWC.
Exposes methods to run batch processes and retrieve structured data.
BusStatusUpdateBatch:
Apex batch class to update bus statuses based on passenger count.
Can be triggered from the UI via LWC.

Batch Automation:
Users can trigger the batch process from the UI to automatically update bus statuses (Available, Limited Seats, Full, Over Capacity) based on business logic.

Testing:
Comprehensive Apex test classes ensure code coverage and reliability for all controllers and batch processes.

Summary:
The Bus Manager App is a scalable, maintainable Salesforce solution that combines custom objects, Apex logic, and Lightning Web Components to deliver a powerful transportation management experience.
