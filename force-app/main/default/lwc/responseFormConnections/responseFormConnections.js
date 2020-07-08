import { api, LightningElement } from 'lwc';

export default class ResponseFormConnections extends LightningElement {
	@api formId;
	@api connections; 
	@api responseConnections = new Map(); 

	handleResponseConnectionChange(event) {
		const detail = JSON.parse(event.detail);
		this.responseConnections.set(detail.connectionId, detail.recordId); 
		if(this.responseConnections.size == this.connections.length) {
			const e = new CustomEvent('connectionsrequired');		
			this.dispatchEvent(e);
		}
	}

}