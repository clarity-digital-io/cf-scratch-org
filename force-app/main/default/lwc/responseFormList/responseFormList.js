import { LightningElement, api, wire } from "lwc";
import { NavigationMixin } from "lightning/navigation";

import FORM_FACTOR from "@salesforce/client/formFactor";
import getResponses from "@salesforce/apex/ResponseController.getResponses";
import formSearch from "@salesforce/apex/ResponseController.formSearch";

export default class ResponseFormList extends NavigationMixin(
  LightningElement
) {
  @api isNew = false;
  @api isEdit = false;
  columns = [];

  constructor() {
    super();
    this.columns = [
      {
        label: "Form Name",
        fieldName: "FormTitle",
        type: "text",
        cellAttributes: { iconName: "standard:record" }
      },
      { label: "Response Name", fieldName: "Name", type: "text" },
      { label: "Status", fieldName: "Status", type: "text" },
      { type: "action", typeAttributes: { rowActions: this.getRowActions } }
    ];
    this.addEventListener(
      "connectionsready",
      this.handleConnectionsReady.bind(this)
    );
  }

  readyForResponse = true;
  showFormSelection = true;
  showConnectionSelection = false;
  showForm = false;
  showResponseControls = false;
  formId;

  @api showModal = false;
  @api recordId;

  responses;
  @wire(getResponses, { recordId: "$recordId" })
  wiredResponses({ error, data }) {
    if (data) {
      this.responses = data.map((record) => {
        return {
          ResponseId: record.Id,
          FormId: record.forms__Form__c,
          FormTitle: record.forms__Form__r.forms__Title__c,
          Name: record.Name,
          Status: record.forms__Status__c
        };
      });
    }
  }

  handleConnectionsReady() {
    this.showFormSelection = false;
    this.showConnectionSelection = false;
    this.showResponseControls = true;
  }

  handleNewResponse() {
    if (FORM_FACTOR == "Large") {
      this.showFormSelection = true;
      this.showConnectionSelection = false;
      this.showForm = false;
      this.showResponseControls = false;
      this.formId = null;
      this.isNew = true;
      this.showModal = true;
    }

    if (FORM_FACTOR == "Small") {
      window.location.href = "clarityforms://response";
    }
  }

  modalCloseHandler() {
    this.showFormSelection = true;
    this.showConnectionSelection = false;
    this.showForm = false;
    this.showResponseControls = false;
    this.formId = null;
    this.showModal = false;
  }

  handleFormSearch(event) {
    const target = event.target;
    formSearch(event.detail)
      .then((results) => {
        target.setSearchResults(results);
      })
      .catch((error) => {
        window.console.log("error", error);
      });
  }

  handleFormSelectionChange(event) {
    window.console.log(
      "event.target.getSelection()",
      event.target.getSelection()
    );
    this.formId = event.detail[0];
  }

  handleStartForm() {
    if (this.formId != null) {
      this.showFormSelection = false;
      this.showConnectionSelection = true;
      this.showForm = true;
    }
  }

  handleSave() {
    this.template.querySelector("c-response-form").handleSave();
  }

  handleSubmit() {
    this.template.querySelector("c-response-form").handleSubmit();
  }

  getRowActions(row, doneCallback) {
    let actions = [];
    if (row.Status == "In Progress") {
      actions.push({
        label: "Edit",
        iconName: "utility:edit",
        name: "edit"
      });
      actions.push({
        label: "Delete",
        iconName: "utility:delete",
        name: "delete"
      });
    }

    if (row.Status == "Submitted") {
      actions.push({
        label: "View",
        iconName: "utility:preview",
        name: "view"
      });
    }

    doneCallback(actions);
  }

  handleRowAction(event) {
    const action = event.detail.action.name;
    const row = event.detail.row;
    window.console.log(
      "event.detail.row",
      event.detail.row,
      JSON.stringify(event.detail.row)
    );
    switch (action) {
      case "delete":
        this.deleteResponse(row);
        break;
      case "view":
        this.viewResponse(row);
        break;
      case "edit":
        this.editResponse(row);
        break;
      default:
    }
  }

  deleteResponse(row) {
    window.console.log("row", row);
  }

  viewResponse(row) {
    window.console.log("row", row);
  }

  editResponse(row) {
    if (FORM_FACTOR == "Large") {
      this.showFormSelection = false;
      this.showConnectionSelection = false;
      this.showForm = true;
      this.showResponseControls = true;
      this.formId = row.FormId;
      this.responseId = row.ResponseId;
      this.isEdit = true;
      this.showModal = true;
    }
  }
}
