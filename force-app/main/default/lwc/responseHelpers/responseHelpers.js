export const getCriteriaControllers = (questions) => {
  let controllers = questions.reduce((accum, question) => {
    if (
      question.forms__Question_Criteria__r != null &&
      question.forms__Question_Criteria__r.length > 0
    ) {
      question.forms__Question_Criteria__r.forEach((criteria, i) => {
        if (accum.has(criteria.forms__Field__c)) {
          let conditions = accum.get(criteria.forms__Field__c);
          conditions.concat([criteria]);
          accum.set(criteria.forms__Field__c, conditions);
        } else {
          accum.set(criteria.forms__Field__c, [criteria]);
        }
      });
    }
    return accum;
  }, new Map());

  return controllers;
};

export const getCriteriaControlledQuestions = (questions) => {
  let questionsControlled = questions.reduce((accum, question) => {
    if (
      question.forms__Question_Criteria__r != null &&
      question.forms__Question_Criteria__r.length > 0
    ) {
      accum.set(
        question.Id,
        question.forms__Question_Criteria__r.map((criteria) => criteria)
      );
    }
    return accum;
  }, new Map());

  return questionsControlled;
};

export const calculateLogic = (
  questionId,
  logicType,
  answers,
  controlledQuestions
) => {
  if (!controlledQuestions.has(questionId)) {
    return true;
  }

  if (Object.keys(answers).length.size == 0) {
    return false;
  }

  let criteria = controlledQuestions.get(questionId);

  if (logicType == "OR") {
    return criteria.reduce((accum, crit) => {
      let check = answers.hasOwnerProperty(crit.forms__Field__c)
        ? answerCheck(answers[crit.forms__Field__c], crit)
        : false;

      return accum || check;
    }, false);
  }

  if (logicType == "AND") {
    let t = criteria.reduce((accum, crit) => {
      let check = answerCheck(answers[crit.forms__Field__c], crit);

      return accum && check;
    }, true);

    return t;
  }
};
//currently only string checks
const answerCheck = (fieldAnswer, criteria) => {
  let criteriaValue = convertType(criteria);

  switch (criteria.forms__Operator__c) {
    case "Is Not Null":
      return fieldAnswer != undefined &&
        fieldAnswer != null &&
        fieldAnswer != ""
        ? true
        : false;
      break;
    case "Equals":
      return fieldAnswer != undefined && fieldAnswer == criteriaValue
        ? true
        : false;
      break;
    case "Not Equal":
      return fieldAnswer == undefined || fieldAnswer != criteriaValue
        ? true
        : false;
      break;
    case "Is Greater than or equal to":
      return fieldAnswer != undefined && fieldAnswer >= criteriaValue
        ? true
        : false;
      break;
    case "Is Less than or equal to":
      return fieldAnswer == undefined || fieldAnswer <= criteriaValue
        ? true
        : false;
      break;
    default:
      break;
  }
};

const convertType = ({ forms__Value__c, forms__Type__c }) => {
  switch (forms__Type__c) {
    case "Boolean":
      return forms__Value__c.toLowerCase() == "true";
      break;
    case "Number":
      return parseInt(forms__Value__c);
      break;
    default:
      return forms__Value__c;
      break;
  }
};
