import { LightningElement, api } from 'lwc';
import combobox from './combobox.html';
import textarea from './textarea.html';
import multiplechoice from './multiplechoice.html';
import buttongroup from './buttongroup.html';
import slider from './slider.html';
import date from './date.html';
import email from './email.html';
import checkbox from './checkbox.html';
import error from './error.html';

export default class ClarityFormQuestion extends LightningElement {

    @api type
    @api title
    @api required
    @api id
    @api options

    handleChange(event) {
        // Get the string of the "value" attribute on the selected option
        const selectedOption = event.detail.value;
        alert(`Option selected with value: ${selectedOption}`);
    }

    render() {
        switch (this.type) {
            case 'MultipleChoice':
                return multiplechoice;
                break;
            case 'Comment':
                return textarea;
                break;
            case 'Dropdown':
                return combobox;
                break;
            case 'Ranking':
                return error;
                break;
            case 'NetPromoterScore':
                return buttongroup;
                break;
            case 'Slider':
                return slider;
                break;
            case 'Date':
                return date;
                break;
            case 'Email':
                return email;
                break;
            case 'Payment':
                return error;
                break;
            case 'Number':
                return number;
                break;
            case 'Lookup':
                return error;
                break;
            case 'RecordGroup':
                return error;
                break;
            case 'Image':
                return error;
                break;
            case 'Checkbox':
                return checkbox;
                break;
            default:
                return error;
                break;
        }
    }
}
