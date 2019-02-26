public class ClaritySurveyHandler {

    public class Clarity {

        public String recordId; 

        public String type;

        public Integer rating;  

        public String status;  

    }

    public static void log(String res) {

        List<Clarity> cltys = (List<Clarity>)JSON.deserialize(res, List<Clarity>.class); 

        List<Clarity_Survey_Response__c> surveys = new List<Clarity_Survey_Response__c>(); 

        for (Clarity clty : cltys) {

            surveys.add(
                new Clarity_Survey_Response__c(
                    //Case__c   = clty.recordId,
                    Status__c =  clty.status 
                )
            );

        }

        insert surveys; 
        
    }
}
