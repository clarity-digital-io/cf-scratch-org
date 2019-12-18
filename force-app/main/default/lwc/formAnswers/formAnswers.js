import { api, track, LightningElement } from 'lwc';
import getAnswerColumns from '@salesforce/apex/FormController.getAnswerColumns';

// export default class formAnswers extends LightningElement  {
//     @api recordId;
//     @track error;
//     @track data;
//     @track columns;
//     // @wire(getAnswerColumns, { recordId: '$recordId' })
//     // wiredData({ error, data }) {
//     //     if (data) {
//     //         window.console.log(data);
//     //         this.data = data.Data;
//     //         this.columns = data.Columns;
//     //     } else if (error) {
//     //         window.console.log('error', error); 
//     //         this.error = error;
//     //     }
//     // }

//     connectedCallback() {
//         getAnswerColumns('$recordId')
//             .then(data => {
//                 window.console.log(data);
//                 this.data = data.Data;
//             })
//             .catch(error => {
//                 this.error = error;
//             });
//     }
// }

// const columns = [
//     {label: 'Opportunity name', fieldName: 'opportunityName', type: 'text'},
//     {label: 'Confidence', fieldName: 'confidence', type: 'percent', cellAttributes:
//     { iconName: { fieldName: 'trendIcon' }, iconPosition: 'right' }},
//     {label: 'Amount', fieldName: 'amount', type: 'currency', typeAttributes: { currencyCode: 'EUR'}},
//     {label: 'Contact Email', fieldName: 'contact', type: 'email'},
//     {label: 'Contact Phone', fieldName: 'phone', type: 'phone'},
//     {label: 'Attachments', fieldName: 'attachments', type: 'attachments'},
// ];

// const data = [{
//         id: 'a',
//         opportunityName: 'Cloudhub',
//         confidence: 0.2,
//         amount: 25000,
//         contact: 'jrogers@cloudhub.com',
//         phone: '2352235235',
//         trendIcon: 'utility:down',
//         attachments: '/sfc/servlet.shepherd/version/download/0680x0000029NHMAA2'
//     },
//     {
//         id: 'b',
//         opportunityName: 'Quip',
//         confidence: 0.78,
//         amount: 740000,
//         contact: 'quipy@quip.com',
//         phone: '2352235235',
//         trendIcon: 'utility:up',
//         attachments: ''
//     }
// ];

export default class formAnswers extends LightningElement {
    @api recordId;
    @track data;
    @track columns;

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

            })
            .catch(error => {
                window.console.log(error);
            });
    }
}