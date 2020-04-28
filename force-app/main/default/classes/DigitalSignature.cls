public with sharing class DigitalSignature {
	
	@AuraEnabled
	public static Blob sign(String signature, String body) {

		String algorithmName = 'RSA';
		String key = '';

		Clarity_Digital_Signature_Config__c config = [SELECT Id, Private_Key__c FROM Clarity_Digital_Signature_Config__c LIMIT 1];

		key = config.Private_Key__c; 

		Blob privateKey = EncodingUtil.base64Decode(key);
		Blob input = Blob.valueOf(signature + 'body');
		Blob signed = Crypto.sign(algorithmName, input, privateKey);
		return signed;
	}
	
}
