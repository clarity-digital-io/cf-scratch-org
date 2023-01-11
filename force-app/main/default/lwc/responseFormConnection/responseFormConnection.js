import { api, LightningElement } from "lwc";
import connectionSearch from "@salesforce/apex/ResponseController.connectionSearch";

export default class ResponseFormConnection extends LightningElement {
  @api connection;

  handleConnectionSearch(event) {
    const target = event.target;
    connectionSearch({
      ...event.detail,
      connection: this.connection.forms__Salesforce_Object__c
    })
      .then((results) => {
        target.setSearchResults(results);
      })
      .catch((error) => {
        window.console.log("error", error);
      });
  }

  handleConnectionSelectionChange(event) {
    let selected = {
      connectionId: this.connection.Id,
      recordId: event.target.getSelection()[0].id
    };
    const searchEvent = new CustomEvent("responseconnection", {
      detail: JSON.stringify(selected)
    });
    this.dispatchEvent(searchEvent);
  }
}
