global class Question implements Comparable {
  public Question__c question;

  public Question(Question__c q) {
    question = q;
  }

  global Integer compareTo(Object compareTo) {
    Question compareToQuestion = (Question) compareTo;

    Integer returnValue = 0;
    if (question.Order__c > compareToQuestion.question.Order__c) {
      returnValue = 1;
    } else if (question.Order__c < compareToQuestion.question.Order__c) {
      returnValue = -1;
    }

    return returnValue;
  }
}
