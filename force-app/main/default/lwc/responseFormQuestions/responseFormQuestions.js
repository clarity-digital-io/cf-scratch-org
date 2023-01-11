import { wire, track, api, LightningElement } from "lwc";
import getQuestions from "@salesforce/apex/ResponseController.getQuestions";
import {
  calculateLogic,
  getCriteriaControllers,
  getCriteriaControlledQuestions
} from "c/responseHelpers";

export default class ResponseFormQuestions extends LightningElement {
  @api answers = {};
  @api formId;
  @api responseId;
  questions;
  recordGroupFields;

  //pass in answers when edit and add it to quesetion object in getActiveQuestions
  @wire(getQuestions, { recordId: "$formId" })
  wiredQuestions({ error, data }) {
    console.log("data", data);
    if (data) {
      this.criteriaControllers = getCriteriaControllers(data);
      this.criteriaControlledQuestions = getCriteriaControlledQuestions(data);
      this.recordGroupFields = this.getRecordGroupFields(data);
      this.questions = this.getActiveQuestions(data);
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.questions = undefined;
    }
  }

  getRecordGroupFields(data) {
    return data.reduce((accum, field) => {
      if (field.forms__Record_Group__c) {
        if (accum.has(field.forms__Record_Group__c)) {
          let fields = accum.get(field.forms__Record_Group__c);
          accum.set(field.forms__Record_Group__c, fields.concat(field));
        } else {
          accum.set(field.forms__Record_Group__c, [field]);
        }
      }

      return accum;
    }, new Map());
  }

  getActiveQuestions(data) {
    return data
      .filter((question) => !question.forms__Record_Group__c)
      .map((question) => {
        let answer = this.answers[question.Id] || "";

        let recordGroupFields = this.recordGroupFields.has(question.Id)
          ? this.recordGroupFields.get(question.Id)
          : [];
        console.log("recordGroupFields", recordGroupFields);

        if (
          calculateLogic(
            question.Id,
            question.forms__Logic__c,
            this.answers,
            this.criteriaControlledQuestions
          )
        ) {
          return {
            ...question,
            active: true,
            answer: answer,
            recordGroupFields: recordGroupFields
          };
        }

        return {
          ...question,
          active: false,
          answer: answer,
          recordGroupFields: recordGroupFields
        };
      });
  }

  handleChange(event) {
    if (event.detail.questionId) {
      this.answers[event.detail.questionId] = event.detail.value;
      if (this.criteriaControllers.has(event.detail.questionId)) {
        this.questions = this.questions.map((question, index) => {
          if (
            calculateLogic(
              question.Id,
              question.forms__Logic__c,
              this.answers,
              this.criteriaControlledQuestions
            )
          ) {
            return { ...question, active: true };
          }

          return { ...question, active: false };
        });
      }
    }
  }
}
