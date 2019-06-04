import { LightningElement, api } from 'lwc';

export default class ClarityFormRender extends LightningElement {

    @api multiplechoice;
    @api comment;
    @api dropdown;
    @api ranking;
    @api netpromoterscore;
    @api slider;
    @api date;
    @api email;
    @api payment;
    @api number;
    @api lookup;
    @api recordgroup;
    @api image;
    @api checkbox;
    @api attachments;
    @api esignature;

    @api type
    @api formresponseid
    @api lookupobject
    @api recordgroupobject;
    @api title
    @api required
    @api maxLength
    @api maxrange
    @api minrange
    @api step
    @api questionid
    @api options
    @api flow

    connectedCallback() {
        console.log('quesitonId: ', this.questionid);
        this.multiplechoice = this.type == 'MultipleChoice' ? true : false;
        this.comment = this.type == 'Comment' ? true : false;
        this.dropdown = this.type == 'Dropdown' ? true : false;
        this.ranking = this.type == 'Ranking' ? true : false;
        this.netpromoterscore = this.type == 'NetPromoterScore' ? true : false;
        this.slider = this.type == 'Slider' ? true : false;
        this.date = this.type == 'Date' ? true : false;
        this.email = this.type == 'Email' ? true : false;
        this.payment = this.type == 'Payment' ? true : false;
        this.number = this.type == 'Number' ? true : false;
        this.lookup = this.type == 'Lookup' ? true : false;
        this.recordgroup = this.type == 'RecordGroup' ? true : false;
        this.image = this.type == 'Image' ? true : false;
        this.checkbox = this.type == 'Checkbox' ? true : false;
        this.attachments = this.type == 'Attachments' ? true : false;        
        this.esignature = this.type == 'eSignature' ? true : false;
    }

    save(event) {
        const selectedEvent = new CustomEvent('formsave', { detail: event.detail });
        this.dispatchEvent(selectedEvent);
    }
}