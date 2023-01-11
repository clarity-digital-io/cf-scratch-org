import { wire, LightningElement } from "lwc";
import getSetup from "@salesforce/apex/SetupController.getSetup";

export default class AppSetup extends LightningElement {
  @wire(getSetup)
  wiredSetup({ error, data }) {
    if (data) {
      console.log({ data });
    } else if (error) {
      console.log({ error });
    }
  }
}
