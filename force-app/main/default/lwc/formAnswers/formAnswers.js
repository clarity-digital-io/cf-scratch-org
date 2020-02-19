import { api, track, LightningElement } from 'lwc';
import getAnswerColumns from '@salesforce/apex/FormController.getAnswerColumns';

export default class formAnswers extends LightningElement {
    @api recordId;
    @track data;
    @track columns;
    @track loading = true; 

    connectedCallback() {
        getAnswerColumns({ recordId: this.recordId })
            .then(result => {

                this.columns = result.Columns;

                let attachmentColumns = result.Columns.filter(column => {
                    return column.type === 'attachments';
                }).map(column => {
                    return column.fieldName;
                });

                if(attachmentColumns.length > 0) {
                    
                    let rows = result.Data.map(d => {

                        let newRow = {...d}; 

                        attachmentColumns.forEach(element => {
                            
                            let hasAttachment = d.hasOwnProperty(element);

                            if(hasAttachment) {

                                let value = JSON.parse(d[element]);

                                newRow[element] = value; 
                        
                            }

                        });

                        return newRow; 

                    });

                    this.data = rows;

                } else {

                    this.data = result.Data;

                }

								this.loading = false; 

            })
            .catch(error => {
                window.console.log(error);
            });
    }
}