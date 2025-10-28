# Kobi Transactions Tracker

A Flutter application to track personal transactions with a mock API.  
The app displays transaction history, total payments, and visualizes expenses with a donut chart.

---

## Overview

Kobi Transactions Tracker allows users to:

- View a list of transactions with merchant, category, date, amount, currency, and status.
- See the total payments in a central donut chart.
- Pull-to-refresh the transaction list.
- Quickly identify pending and completed transactions.

All transaction data is simulated using [Mocki.io](https://mocki.io/) endpoints.

---

## Setup Instructions

1. **Clone the repository**

3. Install dependencies
   flutter pub get

4. Run the app

   flutter run


   

## Libraries Used

flutter_riverpod
 — State management

fl_chart
 — Donut chart visualization

intl
 — Date formatting

http
 — API requests

flutter_animate
 — UI animations

Design & State Management Decisions

State Management: Riverpod was chosen for reactive state handling and transaction filtering.

UI: Material Design with a soft, seamless color palette (ultra-light pink background) and clean AppBar.

Chart: Donut chart represents absolute transaction amounts for visual clarity.

Currency Handling: Each transaction includes a Currency object to allow multi-currency support in the future.

Responsiveness: Layout adjusts padding for tablet vs mobile screens.



## API Simulation

The app uses a Mocki.io endpoint to simulate fetching transactions.

Each transaction contains: id, merchant, category, logo, amount, currency, date, method, status.

Total payment and currency are included at the root level.

The mock API allows you to test the app without a real backend. You can replace it with your own endpoint as needed.

<<<Example JSON structure:

{
  "totalPayment": 897.9,
  "currency": "USD",
  "transactions": [
    {
      "id": 1,
      "merchant": "Netflix",
      "category": "Production Company",
      "logo": "https://upload.wikimedia.org/wikipedia/commons/0/08/Netflix_2015_logo.svg",
      "amount": -17.99,
      "date": "2025-10-10T20:24:00",
      "method": "Visa **** 1234",
      "status": "Completed"
    }
  ]
}

## Notes

The project is modular and easily extendable for real API integration.

Amounts display currency symbols for clarity.

Pending transactions are visually indicated in the UI.

Pull-to-refresh updates the transactions from the mock API endpoint.

