public class ClaritySurvey {
    
    @InvocableMethod(label='Send Survey on Case' description='Requests a Clarity Survey')
    public static void send(List<Case> cases){
        ClaritySurveyRequest.send(JSON.serialize(cases)); 
    }

}
