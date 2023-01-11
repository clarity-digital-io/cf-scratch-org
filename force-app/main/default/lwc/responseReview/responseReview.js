import { api, track, LightningElement } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getResponse from "@salesforce/apex/ResponseController.getResponse";

export default class responseReview extends LightningElement {
  @api recordId;
  @track loading = true;
  answers = [];

  connectedCallback() {
    getResponse({ recordId: this.recordId })
      .then((response) => {
        this.answers = response.forms__Answers__r;
        this.loading = false;
        window.console.log("something", this.answers);
      })
      .catch((error) => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error retrieving response",
            message: error.body.message,
            variant: "error"
          })
        );
      });
  }
}
