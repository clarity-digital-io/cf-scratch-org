import { LightningElement, track, api } from "lwc";

export default class ResponseFormQuestion extends LightningElement {
  @api responseId;
  @api question;
  value = "";
  recordGroupFields = [];

  connectedCallback() {
    this.value = this.question.answer ? this.question.answer : "";
    this.recordGroupFields = this.question.recordGroupFields;
  }

  get isInput() {
    return this.question.forms__Type__c == "InputField";
  }

  get isAttachment() {
    return this.question.forms__Type__c == "Attachments";
  }

  get isDropdown() {
    return this.question.forms__Type__c == "Dropdown";
  }

  get isMultipleChoice() {
    return this.question.forms__Type__c == "MultipleChoice";
  }

  get options() {
    if (
      this.question.forms__Type__c == "MultipleChoice" ||
      this.question.forms__Type__c == "Dropdown" ||
      this.question.forms__Type__c == "Checkbox"
    ) {
      return this.question.forms__Question_Options__r
        ? this.question.forms__Question_Options__r.map((option) => {
            return {
              label: option.forms__Label__c,
              value: option.Id
            };
          })
        : [];
    }
  }

  get isSlider() {
    return this.question.forms__Type__c == "Slider";
  }

  get isDate() {
    return this.question.forms__Type__c == "Date";
  }

  get isEmail() {
    return this.question.forms__Type__c == "Email";
  }

  get isNumber() {
    return this.question.forms__Type__c == "Number";
  }

  get isLookup() {
    return this.question.forms__Type__c == "Lookup";
  }

  get isRecordGroup() {
    return this.question.forms__Type__c == "RecordGroup";
  }

  get isImage() {
    return this.question.forms__Type__c == "Image";
  }

  get isCheckbox() {
    return this.question.forms__Type__c == "Checkbox";
  }

  get isFreeText() {
    return this.question.forms__Type__c == "FreeText";
  }

  get isPictureChoice() {
    return this.question.forms__Type__c == "PictureChoice";
  }

  get isGeoLocation() {
    return this.question.forms__Type__c == "GeoLocation";
  }

  get isTextArea() {
    return this.question.forms__Type__c == "Comment";
  }

  handleInputChange(event) {
    const inputEvent = new CustomEvent("answerchange", {
      detail: { value: event.target.value, questionId: this.question.Id },
      bubbles: true,
      composed: true
    });
    this.dispatchEvent(inputEvent);
  }

  handleAttachmentChange(event) {
    console.log("event.detail.files", JSON.stringify(event.detail.files));

    const inputEvent = new CustomEvent("answerchange", {
      detail: {
        value: event.detail.files,
        questionId: this.question.Id
      }
    });
    this.dispatchEvent(inputEvent);
  }

  handleLookupSearch(event) {
    const target = event.target;
    formSearch(event.detail)
      .then((results) => {
        target.setSearchResults(results);
      })
      .catch((error) => {
        window.console.log("error", error);
      });
  }

  handleLookupSelectionChange(event) {
    this.formId = event.detail[0];
  }
}
